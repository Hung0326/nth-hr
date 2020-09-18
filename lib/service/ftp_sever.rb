# frozen_string_literal: true

require 'net/ftp'
require 'logger'
require 'csv'

# Access Ftp Server get file & extract file
class FtpSever
  CONTENT_SERVER_DOMAIN_NAME = '192.168.1.156'
  CONTENT_SERVER_USER_NAME = 'training'
  CONTENT_SERVER_USER_PASSWORD = 'training'
  NAME_CSV = 'jobs.zip'

  def data_csv
    # download_csv
    CSV.parse(File.read(Rails.root.join('lib', 'csv', 'jobs.csv')), headers: true)
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'csv.log'))
  end

  private

  def jobs_csv_path
    Rails.root.join(NAME_CSV)
  end

  def download_csv
    Net::FTP.open(CONTENT_SERVER_DOMAIN_NAME, CONTENT_SERVER_USER_NAME, CONTENT_SERVER_USER_PASSWORD) do |ftp|
      ftp.getbinaryfile(NAME_CSV)
      Unzip.extract_zip(jobs_csv_path, Rails.root.join('lib', 'csv'))
      File.delete(jobs_csv_path) if File.exist?(jobs_csv_path)
      logger.info 'Download & extract success'
    rescue StandardError => e
      logger.error "Donwload csv have error: #{e}"
    end
  end
end
