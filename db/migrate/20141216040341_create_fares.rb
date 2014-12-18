class CreateFares < ActiveRecord::Migration
  def change
    create_table :fares do |t|
      t.text :detail

      t.timestamps
    end
  end
end
