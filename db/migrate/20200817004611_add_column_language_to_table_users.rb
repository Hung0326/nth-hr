class AddColumnLanguageToTableUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :language, :string, default: 'vi'
  end
end
