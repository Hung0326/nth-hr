# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'logger'

# Crawler data
module Base
  class Base
    attr_accessor :job, :page

    def initialize(page)
      @job = {}
      @page = page
    end

    def logger
      @logger ||= Logger.new(Rails.root.join('log', 'crawl.log'))
    end

    def create_data
      take_data
      job
    rescue StandardError => e
      logger.error "Crawler data job have error: #{e}"
    end

    private

    def take_data
      job[:name] = fill_name
      job[:company_name] = fill_company_name
      job[:city_name] = fill_city_name
      job[:created_date] = fill_created_date
      job[:expiration_date] = fill_expiration_date
      job[:salary] = fill_salary
      job[:industry_name] = fill_industry_name
      job[:description] = fill_description
      job[:level] = fill_lever
      job[:exprience] = fill_experience
    end

    def fill_name
      page.search('.apply-now-content .job-desc .title').text
    end

    def fill_company_name
      page.search('.apply-now-content .job-desc .job-company-name').text
    end

    def fill_city_name
      page.search('.detail-box .map p a').map(&:text).join(',')
    end

    def fill_created_date
      page.search('.item-blue .detail-box:nth-child(1) ul li:nth-child(1) p')[0].try(:text)
    end

    def fill_expiration_date
      page.xpath('//ul//li[last()]//p').last.text
    end

    def fill_salary
      page.xpath('//ul//li[position()=1]//p')[1].text
    end

    def fill_industry_name
      industries = page.xpath('//ul//li[position()=2]//p//a').map(&:text)
      industries.map(&:strip).join(',')
    end

    def fill_description
      job[:description] = page.search('.tabs .tab-content .detail-row').to_s
    end

    def exist_experience?
      noname = page.search('//ul//li').text
      noname.include?('Kinh nghiệm')
    end

    def fill_lever
      exist_experience? ? page.xpath('//ul//li[position()=3]//p')[1].text.strip : page.xpath('//ul//li[position()=2]//p')[1].text
    end

    def fill_experience
      exist_experience? ? page.xpath('//ul//li[position()=2]//p')[1].text.strip : ''
    end
  end
end
