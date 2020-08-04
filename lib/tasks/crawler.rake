# frozen_string_literal: true

require 'open-uri'

# rake task
namespace :crawler do
  task populate: :environment do
    NUMBER_LINK_WILL_BE_CRAWLER = 1
    Company.find_or_create_by(name: 'Bảo mật') do |company|
      company.address = 'Vui lòng xem trong mô tả công việc'
      company.short_description = 'Vui lòng xem trong mô tả công việc'
    end
    cw = Crawler.new(NUMBER_LINK_WILL_BE_CRAWLER)
    cw.craw_data_cities
    cw.craw_data_companies
    CrawlerJob.new(NUMBER_LINK_WILL_BE_CRAWLER).craw_data_jobs            
  end
end
