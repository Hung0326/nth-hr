# frozen_string_literal: true

# Import data from CSV
class ImportData
  attr_accessor :csv

  def initialize(csv)
    @csv = csv
  end

  def import_data
    import_companies
    import_jobs
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'import_data_csv.log'))
  end

  private

  def import_companies
    csv['company name'].each_with_index do |name, index|
      Company.find_or_create_by(name: name.strip) do |company|
        company.address           =  csv['company address'][index]
        company.short_description =  csv['benefit'][index]
      end
    rescue StandardError => e
      logger.error "Import_companies: #{e}"
    end
  end

  def import_jobs
    csv.each do |val|
      desc = "#{val['requirement']} #{(val['description'])}"
      # Get ID Company to create job
      company = Company.find_by name: val['company name'].strip
      company_id = company.try(:id) || Company::COMPANY_SECURITY
      # Get data city do create relationship city_jobs
      city_names = val['work place'].delete('[]\"')
      city = City.find_or_create_by(name: city_names.strip) { |record| record.area = City.areas['domestic'] }
      # Get data Industry do create relationship industry_jobs
      industry_name = val['category'].gsub(',', '/').gsub('/', ' / ')
      industry = Industry.find_or_create_by(name: industry_name.strip)

      record = Job.find_or_initialize_by(name: val['name'], company_id: company_id) do |job|
        job.level = val['level']
        job.salary = val['salary']
        job.description = desc
        job.city_ids.blank? ? job.cities << city : job.cities == city
        job.industry_ids.blank? ? job.industries << industry : job.industries == industry
      end
      record.save && IndexData.indexed(record) if record.new_record?
    rescue StandardError => e
      logger.error "Import_jobs: #{e}"
    end
  end
end
