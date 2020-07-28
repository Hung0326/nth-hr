# frozen_string_literal: true

require 'open-uri'
require 'src/interface_web'

# rake task
namespace :crawler do
  task populate: :environment do
    Company.find_or_create_by(name: 'Bảo mật') do |company|
      company.address = 'Vui lòng xem trong mô tả công việc'
      company.short_description = 'Vui lòng xem trong mô tả công việc'
    end
    cw = InterfaceWeb.new
    cw.craw_data_cities
    cw.craw_data_companies
    cw.make_data
  end
end
