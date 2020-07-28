# frozen_string_literal: true

require 'open-uri'
require 'logger'
require 'src/interface_web'

# rake task
namespace :crawler do
  task populate: :environment do
    InterfaceWeb.craw_data_cities
    InterfaceWeb.craw_data_companies
    InterfaceWeb.make_data
  end
end
