# frozen_string_literal: true

# ahihi
module Src
  module Interface
    class GreenInterface < Base::Base
      def fill_name
        page.search('.info-company h1').text
      end

      def fill_company_name
        page.search('.info-company .text-job h2').text
      end

      def fill_city_name
        page.search('.DetailJobNew ul li:nth-child(1) a').text
      end

      def fill_expiration_date
        page.xpath('//ul//li[last()-1]//span').children[1].text
      end

      def fill_salary
        page.xpath('//ul//li[last()-2]//span').text
      end

      def fill_industry_name
        page.search('.DetailJobNew li:nth-child(3) span').text.strip
      end

      def fill_description
        page.search('.left-col .detail-row').text
      end

      def fill_lever
        page.search('.DetailJobNew li:nth-child(2) span').text.strip
      end

      def exist_experience?
        noname = page.search('.DetailJobNew li span').text
        noname.include?('Kinh nghiệm')
      end

      def fill_experience
        exist_experience? ? page.search('.DetailJobNew li:nth-child(5) span').text.strip : ''
      end
    end
  end
end
