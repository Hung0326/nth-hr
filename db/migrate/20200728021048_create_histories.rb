# frozen_string_literal: true

# Description/Explanation of Person class
class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories, options: 'COLLATE=utf8_general_ci' do |t|
      t.integer :user_id
      t.integer :job_id
      t.timestamps
    end
  end
end
