# frozen_string_literal: true

require 'service/ftp'

# Import data from CSV
class ImportDataCSV
  DOMESTIC = 1
  COMPANY_SECURITY = 1

  def import_data
    csv_data = FtpSever.data_csv
    parse_csv_industries(csv_data)
    parse_csv_cities(csv_data)
    parse_csv_companies(csv_data)
    parse_csv_jobs(csv_data)
  end

  private

  def parse_csv_industries(data)
    puts 'Import data industries . . .'
    industries = []
    industries += data['category'].map(&:strip)
    industries.each do |val|
      val.gsub!(',', '/') if val.include?(',')
      val.gsub!('/', ' / ')
      Industry.find_or_create_by(name: val)
    end
    puts 'Done parse csv industries'
  end

  def parse_csv_cities(data)
    puts 'Import data cities . . .'
    cities = data['work place'].uniq.select(&:present?)
    cities = cities.map { |val| val.delete('[]\"') }
    cities.each do |val|
      next if val.blank?

      City.find_or_create_by(name: val) { |city| city.area = DOMESTIC }
    end
  end

  def parse_csv_companies(data)
    puts 'Import data companies . . .'
    data['company name'].each_with_index do |name, index|
      Company.find_or_create_by(name: name.strip) do |company|
        company.address           =  data['company address'][index]
        company.short_description =  data['benefit'][index]
      end
      puts index
    rescue StandardError => e
      puts e
    end
  end

  def parse_csv_jobs(data)
    data['name'].each_with_index do |name, index|
      desc = (data['requirement'][index]).to_s << (data['description'][index]).to_s
      id_company = Company.find_by name: data['company name'][index].to_s.strip
      id_company = id_company.blank? ? COMPANY_SECURITY : id_company.id
      begin
        id_job = Job.create!(name: name,
                             company_id: id_company,
                             level: data['level'][index],
                             experience: '',
                             salary: data['salary'][index],
                             create_date: Time.now,
                             expiration_date: '',
                             description: desc)
        make_foreign_cities_table(data['work place'][index], id_job.id)
        make_foreign_industries_table(data['category'][index], id_job.id)
        puts index
      rescue StandardError => e
        puts e
      end
    end
  end

  def make_foreign_cities_table(data, id_job)
    data = data.to_s.delete('[]\"')
    id_city = City.find_by name: data.strip
    id_city = id_city.blank? ? City.create!(name: data.strip, area: DOMESTIC).id : id_city.id
    CityJob.create!(job_id: id_job, city_id: id_city)
  end

  def make_foreign_industries_table(data, id_job)
    data = data.to_s.gsub(',', '/').gsub('/', ' / ')
    data = data.strip
    id_industry = Industry.find_by name: data
    id_industry = id_industry.blank? ? Industry.create!(name: data.strip).id : id_industry.id
    IndustryJob.create!(industry_id: id_industry, job_id: id_job)
  end
end
