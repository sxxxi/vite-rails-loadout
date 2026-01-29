class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.column :first, :string
      t.column :last, :string
      t.column :username, :string
      t.column :password_digest, :string
      t.timestamps
    end
  end
end
