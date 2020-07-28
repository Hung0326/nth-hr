# frozen_string_literal: true

# Description/Explanation of Person class
class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, options: 'COLLATE=utf8_general_ci' do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.text :cv
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
