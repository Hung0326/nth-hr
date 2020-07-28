# frozen_string_literal: true

require 'service/ftp'

# Import data from CSV
class ImportData
  DOMESTIC = 1
  COMPANY_SECURITY = 1

  def import_data
    csv_data = FtpSever.data_csv
    import_industries_from(csv_data)
    import_cities_from(csv_data)
    import_companies_from(csv_data)
    import_jobs_from(csv_data)
  end

  private

  def import_industries_from(csv)
    puts 'Import data industries . . .'
    industries = []
    industries += csv['category'].map(&:strip)
    industries.each do |val|
      val.gsub!(',', '/') if val.include?(',')
      val.gsub!('/', ' / ')
      Industry.find_or_create_by(name: val)
    end
    puts 'Done parse csv industries'
  end

  def import_cities_from(csv)
    puts 'Import data cities . . .'
    cities = csv['work place'].uniq.select(&:present?)
    cities = cities.map { |val| val.delete('[]\"') }
    cities.each do |val|
      next if val.blank?

      City.find_or_create_by(name: val) { |city| city.area = DOMESTIC }
    end
  end

  def import_companies_from(csv)
    puts 'Import data companies . . .'
    csv['company name'].each_with_index do |name, index|
      Company.find_or_create_by(name: name.strip) do |company|
        company.address           =  csv['company address'][index]
        company.short_description =  csv['benefit'][index]
      end
      puts index
    rescue StandardError => e
      puts e
    end
  end

  def import_jobs_from(csv)
    csv['name'].each_with_index do |name, index|
      desc = "#{csv['requirement'][index]} #{(csv['description'][index])}"
      company = Company.find_by name: csv['company name'][index].to_s.strip
      id_company = company.blank? ? COMPANY_SECURITY : company.id
      begin
        job = Job.create!(name: name,
                          company_id: id_company,
                          level: csv['level'][index],
                          salary: csv['salary'][index],
                          create_date: Time.now,
                          description: desc)
        make_foreign_cities_table(csv['work place'][index], job.id)
        make_foreign_industries_table(csv['category'][index], job.id)
        puts index
      rescue StandardError => e
        puts e
      end
    end
  end

  def make_foreign_cities_table(data, id_job)
    data = data.to_s.delete('[]\"')
    city = City.find_or_create_by(name: data.strip) { |record| record.area = DOMESTIC }
    city_id = city.id
    CityJob.create!(job_id: id_job, city_id: city_id)
  end

  def make_foreign_industries_table(data, id_job)
    data = data.to_s.gsub(',', '/').gsub('/', ' / ')
    industry = Industry.find_or_create_by(name: data.strip)
    industry_id = industry.id
    IndustryJob.create!(industry_id: industry_id, job_id: id_job)
  end
end
