# frozen_string_literal: true

# Description/Explanation of Person class
class CreateIndustryJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :industry_jobs do |t|
      t.references :industry
      t.references :job
      t.timestamps
    end
  end
end
