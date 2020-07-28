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

  @logger ||= Logger.new("#{Rails.root}/log/csv.log")
  def self.donwload_csv
    Net::FTP.open(CONTENT_SERVER_DOMAIN_NAME, CONTENT_SERVER_USER_NAME, CONTENT_SERVER_USER_PASSWORD) do |ftp|
      begin
        ftp.getbinaryfile('jobs.zip')
        Unzip.extract_zip('./jobs.zip', 'lib/csv')
        File.delete('./jobs.zip') if File.exist?('./jobs.zip')
        @logger.info 'Donwload & extract success'
      rescue FileNotFound => e
        @logger.error "#{e.message}"
      end
    end
  end

  def self.data_csv
    donwload_csv
    CSV.parse(File.read('lib/csv/jobs.csv'), headers: true)
  end
end
