# frozen_string_literal: true

# Import data from csv
namespace :csv do
  task import_csv: :environment do
    data_csv = FtpSever.new.data_csv
    ImportData.new(data_csv).import_data
  end
end
