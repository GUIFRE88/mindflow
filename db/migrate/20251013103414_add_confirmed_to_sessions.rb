class AddConfirmedToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :confirmed, :boolean, default: false, null: false
  end
end
