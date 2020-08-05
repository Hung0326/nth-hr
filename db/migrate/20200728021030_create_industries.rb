# frozen_string_literal: true

# Description/Explanation of Person class
class CreateIndustries < ActiveRecord::Migration[5.2]
  def change
    create_table :industries do |t|
      t.string :name
      t.timestamps
    end
  end
end
