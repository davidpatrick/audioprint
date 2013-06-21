class CreateProduces < ActiveRecord::Migration
  def change
    create_table :produces do |t|
      t.string :name
      t.decimal :price

      t.timestamps
    end
  end
end
