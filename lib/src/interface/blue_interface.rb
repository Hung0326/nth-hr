# frozen_string_literal: true

# Inherience from base
class BlueInterface < Base
  def fill_company_name
    page.search('.top-job .top-job-info .tit_company').text
  end

  def fill_city_name
    page.search('.info-workplace .value a').map(&:text).join(',')
  end

  def fill_expiration_date
    page.xpath('//ul//li[position()=4]//div').text
  end

  def fill_salary
    page.xpath('//ul//li[position()=3]//div').text
  end

  def fill_industry_name
    page.xpath('//ul//li[position()=5]//div').text
  end

  def fill_description
    page.search('.left-col').to_s
  end

  def exist_level?
    noname = page.xpath('//ul//li[position()=2]/b').last.text
    noname.include?('Cấp bậc')
  end

  def fill_lever
    exist_level? ? page.xpath('//ul//li[position()=2]/div').last.text : ''
  end

  def fill_experience
    page.xpath('//ul//li[position()=7]/b').text
  end
end
