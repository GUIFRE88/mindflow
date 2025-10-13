class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.date :session_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :session_type, null: false, default: 'presencial'
      t.text :notes
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :sessions, :session_date
    add_index :sessions, :session_type
    add_index :sessions, :status
    add_index :sessions, [:session_date, :start_time, :user_id], unique: true
  end
end
