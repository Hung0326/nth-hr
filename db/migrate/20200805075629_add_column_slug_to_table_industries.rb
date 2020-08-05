class AddColumnSlugToTableIndustries < ActiveRecord::Migration[5.2]
  def change
    add_column :industries, :slug, :string
  end
end
