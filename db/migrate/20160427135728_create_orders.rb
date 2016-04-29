class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.string :email
      t.integer :pay_type
      t.integer :status
      t.integer :delivery_type

      t.timestamps null: false
    end
  end
end
