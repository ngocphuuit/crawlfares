class CreateSkyscans < ActiveRecord::Migration
  def change
    create_table :skyscans do |t|
      t.text :pricingsession

      t.timestamps
    end
  end
end
