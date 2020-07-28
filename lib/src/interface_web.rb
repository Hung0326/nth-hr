# frozen_string_literal: true

require 'open-uri'

# Crawler data
class InterfaceWeb  
  def self.crawl_link_for_companies_jobs(page)
    puts "Crawling link on page...\nPLease wait...\n"
    data = []
    website_companies = []
    website_jobs = []

    file = File.readlines('tmp/link.txt', 'r') if File.exist?('tmp/link.txt')
    @@stop_crawl = file.blank? ? '' : file.join    
    page.times do |i|
      page = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{i + 1}-vi.html"))
      link_companies = page.search('.figcaption .caption @href')
      website_companies += link_companies.map(&:value).uniq
      link_jobs = page.search('.figcaption .title .job_link @href')
      website_jobs += link_jobs.map(&:value)
      break if website_jobs.include?(@@stop_crawl)
    end
    website_companies = website_companies.select { |val| val.present? && val != 'javascript:void(0);' }
    website_jobs = website_jobs.select(&:present?)
    puts "Result:\nCompany: #{website_companies.length} link\nJob    : #{website_jobs.length} link\n------------------------"
    File.write('tmp/link.txt', website_jobs[0])
    data << website_companies << website_jobs
  end
 
  def self.get_link_job_and_companies
    @crawl_link_for_companies_jobs ||= crawl_link_for_companies_jobs(2)
  end
  
  def self.safe_link(url)
    Nokogiri::HTML(URI.parse(URI.escape(url)))
  end

  def self.craw_data_cities
    page = Nokogiri::HTML(URI.open('https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html'))
    puts "Crawling data location... \n. \n. \n."
    data_list_cities = []
    data = page.search('#location option')
    list_cities = data.to_s.split('</option>')
    list_cities.each do |x|
      data_list_cities << x.gsub(/(^<[\w\D]*>)/, '').gsub(/\n/, '').rstrip
    end
    puts 'Save data to database...'
    data_list_cities.each_with_index do |val, index|
      area = index > 69 ? 0 : 1
      City.find_or_create_by(name: val) do |city|
        city.name = val
        city.area = area
      end
    end
  end

  def self.craw_data_companies
    puts 'Crawl data companies'
    link_crawl = get_link_job_and_companies
    link_crawl[0].each do |url|
      page = Nokogiri::HTML(URI.open(URI.parse(URI.escape(url))))
      name = ''
      address = ''
      desc = ''
      if page.search('.company-info .info .content .name').text == ''
        name = page.search('.section-page #cp_company_name').text
        address = page.search('.section-page .cp_basic_info_details ul li:nth-child(1)').text
        desc = page.search('.cp_aboutus_item .content_fck').text
      else
        name = page.search('.company-info .info .content .name').text
        address = page.search('.company-info .info .content p:nth-child(3)').text
        desc = page.search('.main-about-us .content').text
      end
      begin
        if name.present? && address.present? && desc.present?
          Company.find_or_create_by(name: name.strip) do |company|
            company.name              = name.strip
            company.address           = address
            company.short_description = desc
          end
          puts name
        end
      rescue StandardError => e
        puts e
      end
    end
  end
  
  def self.add_data(name, company_name, city_name, created_date, expiration_date, salary, industry_name, description, level, exprience)
    begin
      id_company = Company.find_by name: company_name
      id_company = id_company.present? ? id_company.id : 1
      id_job = Job.create!(name: name,
                           company_id: id_company,
                           level: level,
                           experience: exprience,
                           salary: salary,
                           create_date: created_date,
                           expiration_date: expiration_date,
                           description: description)
      make_foreign_industries_table(industry_name, id_job.id)
      make_foreign_cities_table(city_name, id_job.id)
    rescue StandardError => e
      puts e
    end
  end

  def self.crawl_data_jobs_interface_1(page)
    name = page.search('.apply-now-content .job-desc .title').text
    company_name = page.search('.apply-now-content .job-desc .job-company-name').text
    location = []
    length = page.search('.detail-box .map p a').size
    length.times do |n|
      location << page.search(".detail-box .map p a:nth-child(#{n + 1})").text
    end
    city_name = location.join(',')
    created_date = page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[0].text
    expiration_date = page.search('.item-blue .detail-box ul li:last')[1].text.delete!("[\n,\t,\r]").split(' ').last
    salary = page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[1].text
    industries = page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(2) a').text
    industries = industries.delete!("[\n,\t,\r]").split('  ').select(&:present?)
    industry_name = industries.join(',')
    description = page.search('.tabs .tab-content .detail-row:nth-child(n)').to_s
    get_level = page.search('.item-blue .detail-box:last ul li:nth-child(3)').text.delete!("[\n,\t,\r]").lstrip.split('Cấp bậc')
    get_level = get_level[1].to_s.strip
    if get_level.blank?
      g_level = page.search('.item-blue .detail-box:last ul li:nth-child(2)').text.delete!("[\n,\t,\r]").lstrip.split('Cấp bậc')
      level = g_level[1].to_s.strip
    else
      g_level = get_level
      level = g_level
    end
    exp = page.search('.item-blue .detail-box:last ul li:nth-child(2)').text.delete!("[\n,\t,\r]").split('Kinh nghiệm')
    exp = exp[1].to_s.strip
    exprience = exp
    add_data(name, company_name, city_name, created_date, expiration_date, salary, industry_name, description, level, exprience)
  end

  def self.crawl_data_jobs_interface_2(page)
    name = page.search('.apply-now-content .job-desc .title').text
    company_name = page.search('.top-job .top-job-info .tit_company').text
    location = []
    length = page.search('.info-workplace .value a').size
    length.times do |n|
      location << page.search(".info-workplace .value a:nth-child(#{n + 1})").text
    end
    city_name = location.join(',')
    created_date = ''
    expiration_date = page.search('.info li:nth-child(4)').text
    expiration_date = if expiration_date.blank?
                        ''
                      else
                        expiration_date.to_s.delete!("[\n,\t,\r]").split(' ').last
                      end
    salary = page.search('.info li:nth-child(3)').text.split('Lương').last.strip
    industry_name = page.search('.info li:nth-child(5) .value').text
    description = page.search('.left-col').to_s
    lv = page.search('.boxtp .info li:nth-child(2)').text
    level = if lv.blank?
              ''
            else
              lv.delete!("[\n,\t,\r]").strip.split('Cấp bậc').last.strip
            end
    exp = page.search('.info li:nth-child(6)').text
    exprience = if exp.blank?
                  ''
                else
                  exp.delete!("[\n,\t,\r]").split('Kinh nghiệm').last.strip
                end
    add_data(name, company_name, city_name, created_date, expiration_date, salary, industry_name, description, level, exprience)
  end

  def self.crawl_data_jobs_interface_5(page)
    name = page.search('.info-company h1').text
    company_name = page.search('.info-company .text-job h2').text
    city_name = page.search('.DetailJobNew ul li:nth-child(1) a').text
    created_date = ''
    expiration_date = page.search('.DetailJobNew li:nth-child(9) span').text.strip
    salary = page.search('.DetailJobNew li:nth-child(3) span').text.strip
    industry_name = page.search('.DetailJobNew li:nth-child(2) span').text.strip
    description = page.search('.left-col .detail-row')
    level = page.search('.DetailJobNew ul li:nth-child(6) span').text.strip
    exprience = page.search('.DetailJobNew li:nth-child(5) span').text.strip
    add_data(name, company_name, city_name, created_date, expiration_date, salary, industry_name, description, level, exprience)
  end

  def self.make_foreign_industries_table(data, id_job)
    content = data.split(',')
    content.each do |val|
      val.gsub!('&amp;','&') if val.include?('&amp;')
      id_industry = Industry.find_by name: val.strip
      id_industry = id_industry.blank? ? Industry.create!(name: val.strip).id : id_industry.id
      IndustryJob.create!(industry_id: id_industry, job_id: id_job)
    end
  end

  def self.make_foreign_cities_table(data, id_job)
    cities = data.split(',')
    cities.each do |city|
      id_cities = City.find_by name: city.strip
      id_cities = id_cities.blank? ? City.create!(name: city.strip, area: 1).id : id_cities.id
      CityJob.create!(job_id: id_job, city_id: id_cities)
    end
  end

  def self.make_data
    puts 'Please wait for crawl jobs data! . . .'
    link_crawl = get_link_job_and_companies
    arr_link = []
    link_crawl[1].each do |val|
      break if @@stop_crawl == val
      arr_link << val
    end
    arr_link.reverse!.each_with_index do |path, i|
      page = Nokogiri::HTML(URI.open(URI.parse(URI.escape(path))))
      if !page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[0].nil?
        crawl_data_jobs_interface_1(page)
      elsif page.search('section .template-200').text != ''
        crawl_data_jobs_interface_2(page)
      elsif page.search('.DetailJobNew ul li').size == 10 && !page.search('.right-col ul li').text.include?('Độ tuổi')
        crawl_data_jobs_interface_5(page)
      end
      puts "#{i} - #{path}"
    end
    puts 'Crawler data jobs success!'
  end
end
