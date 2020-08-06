# frozen_string_literal: true

# Description/Explanation of Person class
class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.text :short_description
      t.timestamps
    end
  end
end
