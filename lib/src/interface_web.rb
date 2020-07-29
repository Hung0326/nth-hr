# frozen_string_literal: true

require 'open-uri'

# Crawler data
class Crawler
  COMPANY_SECURITY = 1
  NUMBER_LINK = 2
  SIZE_LI_INTERFACE_5 = 10

  def path_to_first_link
    Rails.root.join('tmp', 'link.txt')
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'crawler.log'))
  end

  def stop_crawler
    file = File.readlines(path_to_first_link, 'r') if File.exist?(path_to_first_link)
    file.blank? ? '' : file.join
  end

  def safe_link(url)
    Nokogiri::HTML(URI.open(URI.parse(URI.escape(url))))
  end

  def crawl_link(page)
    data = []
    website_companies = []
    website_jobs = []
    begin
      page.times do |i|
        page = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{i + 1}-vi.html"))
        link_companies = page.search('.figcaption .caption @href')
        website_companies += link_companies.map(&:value).uniq
        link_jobs = page.search('.figcaption .title .job_link @href')
        website_jobs += link_jobs.map(&:value)
        break if website_jobs.include?(stop_crawler)
      end
    rescue StandardError => e
      logger.error "Crawler link on page have error #{e}"
    end
    website_companies = website_companies.select(&:present?)
    website_jobs = website_jobs.select(&:present?)
    File.write(path_to_first_link, website_jobs[0])
    data << website_companies << website_jobs
  end

  def link_job_and_companies
    @link_job_and_companies ||= crawl_link(NUMBER_LINK)
  end

  def craw_data_cities
    page = Nokogiri::HTML(URI.open('https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html'))
    locations = page.search('#location option').map(&:text)
    locations.each_with_index do |val, index|
      area = index > City.areas['range'] ? City.areas['international'] : City.areas['domestic']
      City.find_or_create_by(name: val) { |city| city.area = area }
    end
  end

  def craw_data_companies
    link_crawl = link_job_and_companies
    link_crawl[0].each do |url|      
      page = safe_link(url)
      company_name = page.search('.company-info .content .name').text
      Company.find_or_create_by(name: company_name) do |company|
        company.address = page.search('.company-info .info .content p:nth-child(3)').text
        company.short_description = page.search('.main-about-us .content').text
      end
    end
    rescue StandardError => e
      logger.error "Crawler data companies has error: #{e}"
  end
end

  # def make_data
  #   puts 'Please wait for crawl jobs data! . . .'
  #   link_crawl = link_job_and_companies
  #   arr_link = []
  #   link_crawl[1].each do |val|
  #     break if stop_crawler == val
  #     arr_link << val
  #   end
  #   arr_link.reverse!.each_with_index do |path, i|
  #     page = Nokogiri::HTML(URI.open(URI.parse(URI.escape(path))))
  #     if page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[0].present?
  #       crawl_data_jobs_interface_1(page)
  #     elsif page.search('section .template-200').text.present?
  #       crawl_data_jobs_interface_2(page)
  #     elsif page.search('.DetailJobNew ul li').size == SIZE_LI_INTERFACE_5 && !page.search('.right-col ul li').text.include?('Độ tuổi')
  #       crawl_data_jobs_interface_5(page)
  #     end
  #     puts "#{i} - #{path}"
  #   end
  #   puts 'Crawler data jobs success!'
  # end

  # private

  # def add_data(data)
  #   id_company = Company.find_by name: data[:company_name]
  #   id_company = id_company.present? ? id_company.id : COMPANY_SECURITY
  #   id_job = Job.create!(name: data[:name],
  #                       company_id: id_company,
  #                       level: data[:level],
  #                       experience: data[:exprience],
  #                       salary: data[:salary],
  #                       create_date: data[:created_date],
  #                       expiration_date: data[:expiration_date],
  #                       description: data[:description])
  #   make_foreign_industries_table(data[:industry_name], id_job.id)
  #   make_foreign_cities_table(data[:city_name], id_job.id)
  # rescue StandardError => e
  #   puts e
  # end

  # def crawl_data_jobs_interface_1(page)
  #   data = {}
  #   data[:name] = page.search('.apply-now-content .job-desc .title').text
  #   data[:company_name] = page.search('.apply-now-content .job-desc .job-company-name').text
  #   location = []
  #   length = page.search('.detail-box .map p a').size
  #   length.times do |n|
  #     location << page.search(".detail-box .map p a:nth-child(#{n + 1})").text
  #   end
  #   data[:city_name] = location.join(',')
  #   data[:created_date] = page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[0].text
  #   data[:expiration_date] = page.search('.item-blue .detail-box ul li:last')[1].text.delete!("[\n,\t,\r]").split(' ').last
  #   data[:salary] = page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[1].text
  #   industries = page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(2) a').text
  #   industries = industries.delete!("[\n,\t,\r]").split('  ').select(&:present?)
  #   data[:industry_name] = industries.join(',')
  #   data[:description] = page.search('.tabs .tab-content .detail-row:nth-child(n)').to_s
  #   get_level = page.search('.item-blue .detail-box:last ul li:nth-child(3)').text.delete!("[\n,\t,\r]").lstrip.split('Cấp bậc')
  #   get_level = get_level[1].to_s.strip
  #   if get_level.blank?
  #     g_level = page.search('.item-blue .detail-box:last ul li:nth-child(2)').text.delete!("[\n,\t,\r]").lstrip.split('Cấp bậc')
  #     data[:level] = g_level[1].to_s.strip
  #   else
  #     data[:level] = get_level
  #   end
  #   exp = page.search('.item-blue .detail-box:last ul li:nth-child(2)').text.delete!("[\n,\t,\r]").split('Kinh nghiệm')
  #   exp = exp[1].to_s.strip
  #   data[:exprience] = exp
  #   add_data(data)
  # end

  # def crawl_data_jobs_interface_2(page)
  #   data = {}
  #   data[:name] = page.search('.apply-now-content .job-desc .title').text
  #   data[:company_name] = page.search('.top-job .top-job-info .tit_company').text
  #   locations = []
  #   length = page.search('.info-workplace .value a').size
  #   length.times do |n|
  #     locations << page.search(".info-workplace .value a:nth-child(#{n + 1})").text
  #   end
  #   data[:city_name] = locations.join(',')
  #   data[:created_date] = ''
  #   expiration_date = page.search('.info li:nth-child(4)').text
  #   data[:expiration_date] = expiration_date.blank? ? '' : expiration_date.delete!("[\n,\t,\r]").split(' ').last
  #   data[:salary] = page.search('.info li:nth-child(3)').text.split('Lương').last.strip
  #   data[:industry_name] = page.search('.info li:nth-child(5) .value').text
  #   data[:description] = page.search('.left-col').to_s
  #   lv = page.search('.boxtp .info li:nth-child(2)').text
  #   data[:level] = lv.blank? ? '' : lv.delete!("[\n,\t,\r]").strip.split('Cấp bậc').last.strip
  #   exp = page.search('.info li:nth-child(6)').text
  #   data[:exprience] = exp.blank? ? '' : exp.delete!("[\n,\t,\r]").split('Kinh nghiệm').last.strip
  #   add_data(data)
  # end

  # def crawl_data_jobs_interface_5(page)
  #   data = {}
  #   data[:name] = page.search('.info-company h1').text
  #   data[:company_name] = page.search('.info-company .text-job h2').text
  #   data[:city_name] = page.search('.DetailJobNew ul li:nth-child(1) a').text
  #   data[:created_date] = ''
  #   data[:expiration_date] = page.search('.DetailJobNew li:nth-child(9) span').text.strip
  #   data[:salary] = page.search('.DetailJobNew li:nth-child(3) span').text.strip
  #   data[:industry_name] = page.search('.DetailJobNew li:nth-child(2) span').text.strip
  #   data[:description] = page.search('.left-col .detail-row')
  #   data[:level] = page.search('.DetailJobNew ul li:nth-child(6) span').text.strip
  #   data[:exprience] = page.search('.DetailJobNew li:nth-child(5) span').text.strip
  #   add_data(data)
  # end

  # def make_foreign_industries_table(data, id_job)
  #   unless data.blank? && id_job.blank?
  #     content = data.split(',')
  #     content.each do |val|
  #       val.gsub!('&amp;', '&') if val.include?('&amp;')
  #       data_industry = Industry.find_by name: val.strip
  #       id_industry = data_industry.blank? ? Industry.create!(name: val.strip).id : data_industry.id
  #       IndustryJob.create!(industry_id: id_industry, job_id: id_job)
  #     end
  #   end
  # end

  # def make_foreign_cities_table(data, id_job)
  #   return if data.blank? && id_job.blank?
  #   cities = data.split(',')
  #   cities.each do |city|
  #     data_city = City.find_by name: city.strip
  #     id_cities = data_city.blank? ? City.create!(name: city.strip, area: DOMESTIC).id : data_city.id
  #     CityJob.create!(job_id: id_job, city_id: id_cities)
  #   end
  # end
