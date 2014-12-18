class AddSearchToFare < ActiveRecord::Migration
  def change
    add_column :fares, :search, :text
  end
end
