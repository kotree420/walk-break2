class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, unique: true, limit: 20
      t.string :email, null: false, unique: true, limit: 255,
                index: { unique: true, name: 'unique_emails' }

      t.timestamps
    end
  end
end
