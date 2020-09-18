# frozen_string_literal: true

class IndexData
  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'indexed_data_to_solr.log'))
  end

  def self.indexed(job)
    solr = SolrSetting::SolrServer.connection
    data = {}
    data[:id] = job.id
    data[:name] = job.name
    data[:company_name] = job.company.name
    data[:salary] = job.salary
    data[:description] = job.description
    data[:industries] = job.industry_jobs.map(&:industry).map(&:name)
    data[:industry_id] = job.industry_jobs.map(&:industry_id)
    data[:locations] = job.city_jobs.map(&:city).map(&:name)
    data[:location_id] = job.city_jobs.map(&:city_id)
    solr.add data, add_attributes: {commitWithin: 10}
  rescue StandardError => e
    logger.error "Indexed data to Solr have error: #{e}"
  end
end
