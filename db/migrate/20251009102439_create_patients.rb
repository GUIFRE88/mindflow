class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.date :birth_date
      t.text :notes
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :patients, :status
    add_index :patients, :email
  end
end
