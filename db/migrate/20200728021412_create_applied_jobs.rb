# frozen_string_literal: true

# Description/Explanation of Person class
class CreateAppliedJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :applied_jobs do |t|
      t.references :user
      t.references :job
      t.string :name
      t.string :email
      t.text :cv
      t.timestamps
    end
  end
end
