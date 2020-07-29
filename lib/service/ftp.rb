# frozen_string_literal: true

require 'service/unzip'
require 'net/ftp'
require 'logger'
require 'csv'

# Access Ftp Server get file & extract file
class FtpSever
  CONTENT_SERVER_DOMAIN_NAME = '192.168.1.156'
  CONTENT_SERVER_USER_NAME = 'training'
  CONTENT_SERVER_USER_PASSWORD = 'training'
  DIRECTORY_CSV = './jobs.zip'

  def data_csv
    donwload_csv
    CSV.parse(File.read('lib/csv/jobs.csv'), headers: true)  
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/csv.log")
  end

  private

  def donwload_csv
    Net::FTP.open(CONTENT_SERVER_DOMAIN_NAME, CONTENT_SERVER_USER_NAME, CONTENT_SERVER_USER_PASSWORD) do |ftp|
      ftp.getbinaryfile('jobs.zip')
      Unzip.extract_zip(DIRECTORY_CSV, 'lib/csv')
      File.delete(DIRECTORY_CSV) if File.exist?(DIRECTORY_CSV)
      logger.info 'Donwload & extract success'
    end
  end
end
