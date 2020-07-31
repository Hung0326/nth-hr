# frozen_string_literal: true

require 'open-uri'

# Crawler data
class Crawler
  COMPANY_SECURITY = 1
  NUMBER_LINK = 5
  SIZE_LI = 8
  RANGE = 69

  def path_to_first_link
    Rails.root.join('tmp', 'link.txt')
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'crawler.log'))
  end

  def link_make_stop_crawler
    file = File.readlines(path_to_first_link, 'r') if File.exist?(path_to_first_link)
    file.blank? ? 'NOT' : file.join
  end

  def safe_link(url)
    Nokogiri::HTML(URI.open(URI.parse(URI.escape(url))))
  end

  def crawl_link(page)
    website_companies = []
    page.times do |i|
      page = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{i + 1}-vi.html"))
      link_companies = page.search('.figcaption .caption @href')
      website_companies += link_companies.map(&:value).uniq
      link_jobs = page.search('.figcaption .title .job_link @href').text
      break if link_jobs.include?(link_make_stop_crawler)
    end
    website_companies.select(&:present?)
  rescue StandardError => e
    logger.error "Crawler link on page have error #{e}"    
  end

  def craw_data_cities
    page = Nokogiri::HTML(URI.open('https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html'))
    locations = page.search('#location option').map(&:text)
    locations.each_with_index do |val, index|
      area = index > RANGE ? City.areas['international'] : City.areas['domestic']
      City.find_or_create_by(name: val) { |city| city.area = area }
    end
  end

  def craw_data_companies
    crawl_link(NUMBER_LINK).each do |url|
      page = safe_link(url)
      company_name = page.search('.company-info .content .name').text
      Company.find_or_create_by(name: company_name) do |company|
        company.address = page.search('.company-info .info .content p:nth-child(3)').text
        company.short_description = page.search('.main-about-us .content').text
      end
    rescue StandardError => e
      logger.error "Crawler data companies has error: #{e}"
    end
  end
end
