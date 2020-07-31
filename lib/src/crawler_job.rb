# frozen_string_literal: true

require 'src/crawler.rb'
require_relative '../src/interface/red_interface.rb'
require_relative '../src/interface/blue_interface.rb'
require_relative '../src/interface/green_interface.rb'

# Crawler data job
class CrawlerJob < Crawler
  def crawl_link(page)
    website_jobs = []
    page.times do |i|
      page = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{i + 1}-vi.html"))
      link_jobs = page.search('.figcaption .title .job_link @href')
      website_jobs += link_jobs.map(&:value)
      break if website_jobs.include?(link_make_stop_crawler)
    end
    File.write(path_to_first_link, website_jobs[0])
    website_jobs.select(&:present?)
  rescue StandardError => e
    logger.error "Crawler link on page have error #{e}"
  end

  def reverse_arr
    arr_link = []
    crawl_link(NUMBER_LINK).each { |val| arr_link << val }
    arr_link.reverse!
  end

  def craw_data_jobs
    reverse_arr.each do |path|
      page = safe_link(path)
      if page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[0].present?
        @data = RedInterface.new(page).create_data
      elsif page.search('section .template-200').text.present?
        @data = BlueInterface.new(page).create_data
      elsif page.search('.DetailJobNew ul li').size == SIZE_LI && page.search('.right-col ul li').text.exclude?('Độ tuổi')
        @data = GreenInterface.new(page).create_data
      end
      add_data(@data)
    end
  end

  def add_data(data)
    id_company = Company.find_by name: data[:company_name]
    id_company = id_company.present? ? id_company.id : COMPANY_SECURITY
    id_job = Job.create!(name: data[:name],
                         company_id: id_company,
                         level: data[:level],
                         experience: data[:exprience],
                         salary: data[:salary],
                         create_date: data[:created_date],
                         expiration_date: data[:expiration_date],
                         description: data[:description])
    create_industry_relation(data[:industry_name], id_job.id)
    create_city_relation(data[:city_name], id_job.id)
  rescue StandardError => e
    logger.error "Crawler data jobs has error: #{e}"
  end

  def create_industry_relation(data, id_job)
    return if data.blank? && id_job.blank?

    industries = data.split(',')
    industries.each do |val|
      val.gsub!('&amp;', '&') if val.include?('&amp;')
      industry = Industry.find_or_create_by name: val.strip
      IndustryJob.create(industry_id: industry.id, job_id: id_job)
    end
  end

  def create_city_relation(data, id_job)
    cities = data.split(',')
    cities.each do |city|
      city = City.find_or_create_by(name: city.strip, area: City.areas['domestic'])
      CityJob.create(job_id: id_job, city_id: city.id)
    end
  end
end
