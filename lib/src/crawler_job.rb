# frozen_string_literal: true

# Crawler job
class CrawlerJob < Crawler
  SIZE_LI = 8

  def crawl_link
    website_jobs = []
    number_link.times do |i|
      page = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{i + 1}-vi.html"))
      link_jobs = page.search('.figcaption .title .job_link @href')
      link_jobs.each do |val|
        link = val.value
        return website_jobs if link.include?(link_make_stop_crawler)

        website_jobs << link
      end
    end
    website_jobs
  rescue StandardError => e
    logger.error "Crawler link jobs on page have error #{e}"
  end

  def parse_data
    @parse_data ||= crawl_link.reverse!
  end

  def refresh_first_link
    File.write(path_to_first_link, parse_data.last)
  end

  def craw_data_jobs
    parse_data.each do |path|
      page = safe_link(path)
      if page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[0].present?
        @data = Interface::RedInterface.new(page).create_data
      elsif page.search('section .template-200').text.present?
        @data = Interface::BlueInterface.new(page).create_data
      elsif page.search('.DetailJobNew ul li').size == SIZE_LI && page.search('.right-col ul li').text.exclude?('Độ tuổi')
        @data = Interface::GreenInterface.new(page).create_data
      end
      add_data(@data)
      refresh_first_link
    end
  end

  def add_data(data)
    id_company = (Company.find_by name: data[:company_name]).try(:id) || Company::COMPANY_SECURITY
    job = Job.create(name: data[:name],
                    company_id: id_company,
                    level: data[:level],
                    experience: data[:exprience],
                    salary: data[:salary],
                    create_date: data[:created_date],
                    expiration_date: data[:expiration_date],
                    description: data[:description])
    create_industry_relation(data[:industry_name], job)
    create_city_relation(data[:city_name], job)
    IndexData.indexed(job)
  rescue StandardError => e
    logger.error "Crawler data jobs has error: #{e}"
  end

  def create_industry_relation(data, job)
    industries = data.split(',')
    industries.each do |val|
      val.gsub!('&amp;', '&') if val.include?('&amp;')
      industry = Industry.find_or_create_by name: val.strip
      job.industries << industry
    end
  end

  def create_city_relation(data, job)
    cities = data.split(',')
    cities.each do |city|
      city = City.find_or_create_by(name: city.strip, area: City.areas['domestic'])
      job.cities << city
    end
  end
end
