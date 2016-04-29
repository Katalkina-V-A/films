class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.attachment :cover
      t.decimal :price, precision: 8, scale: 2
      t.integer :amount
      t.string :author
      t.string :series
      t.integer :year
      t.string :publishing

      t.timestamps null: false
    end
  end
end
