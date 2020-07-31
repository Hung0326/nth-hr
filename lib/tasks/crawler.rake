# frozen_string_literal: true

require 'open-uri'
require 'src/crawler'
require 'src/crawler_job'

# rake task
namespace :crawler do
  task populate: :environment do
    Company.find_or_create_by(name: 'Bảo mật') do |company|
      company.address = 'Vui lòng xem trong mô tả công việc'
      company.short_description = 'Vui lòng xem trong mô tả công việc'
    end
    cw = Crawler.new
    cw.craw_data_cities
    cw.craw_data_companies
    CrawlerJob.new.craw_data_jobs
  end
end
