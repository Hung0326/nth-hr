# frozen_string_literal: true

require 'service/import_data'

# Description/Explanation of Person class
namespace :csv do
  task import_csv: :environment do
    csv = ImportData.new
    csv.import_data
  end
end
