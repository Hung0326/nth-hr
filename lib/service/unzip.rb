# frozen_string_literal: true

require 'zip'

# Description/Explanation of Person class
module Unzip
  def self.extract_zip(file, destination)
    FileUtils.mkdir_p(destination)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(destination, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end
end