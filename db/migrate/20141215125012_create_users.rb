class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :country
      t.string :email
      t.integer :refer_id, index: true
      t.timestamps
    end
  end
end
