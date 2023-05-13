class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, limit: 64, null: false
      t.string :email, limit: 500, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
