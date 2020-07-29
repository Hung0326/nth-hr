# frozen_string_literal: true

require 'service/ftp'

# Import data from CSV
class ImportData
  DOMESTIC = 1
  COMPANY_SECURITY = 1

  def import_data
    csv_data = FtpSever.new.data_csv
    import_industries_from(csv_data)
    import_cities_from(csv_data)
    import_companies_from(csv_data)
    import_jobs_from(csv_data)
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'import_data_csv.log'))
  end

  private

  def import_industries_from(csv)
    industries = []
    industries += csv['category'].map(&:strip)
    industries.each do |val|
      val.gsub!(',', '/') if val.include?(',')
      val.gsub!('/', ' / ')
      Industry.find_or_create_by(name: val)
    end
  rescue StandardError => e
    logger.error "Import_industries: #{e}"
  end

  def import_cities_from(csv)
    city_names = csv['work place'].uniq.select(&:present?)
    cities = city_names.map { |val| val.delete('[]\"') }
    cities.each do |val|
      next if val.blank?

      City.find_or_create_by(name: val) { |city| city.area = DOMESTIC }
    end
  rescue StandardError => e
    logger.error "Import_cities: #{e}"
  end

  def import_companies_from(csv)
    csv['company name'].each_with_index do |name, index|
      Company.find_or_create_by(name: name.strip) do |company|
        company.address           =  csv['company address'][index]
        company.short_description =  csv['benefit'][index]
      end
    rescue StandardError => e
      logger.error "Import_companies: #{e}"
    end
  end

  def import_jobs_from(csv)
    csv['name'].each_with_index do |name, index|
      desc = "#{csv['requirement'][index]} #{(csv['description'][index])}"
      company = Company.find_by name: csv['company name'][index].to_s.strip
      company_id = company.try(:id) || COMPANY_SECURITY
      begin
        job = Job.create(name: name,
                         company_id: company_id,
                         level: csv['level'][index],
                         salary: csv['salary'][index],
                         create_date: Time.now,
                         description: desc)
        city_names = csv['work place'][index].to_s.delete('[]\"')
        city = City.find_or_create_by(name: city_names.strip) { |record| record.area = DOMESTIC }
        job.cities << city

        industry_name = csv['category'][index].to_s.gsub(',', '/').gsub('/', ' / ')
        industry = Industry.find_or_create_by(name: industry_name.strip)
        job.industries << industry
        puts index
      rescue StandardError => e
        logger.error "Import_jobs: #{e}"
      end
    end
  end
end
