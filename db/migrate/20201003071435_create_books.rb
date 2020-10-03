class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :description
      t.string :isbn
      t.index :isbn, unique: true

      t.timestamps
    end
  end
end
