class CreateAccountExports < ActiveRecord::Migration[8.2]
  def change
    create_table :account_exports, id: :uuid do |t|
      t.uuid :account_id, null: false
      t.integer :status, null: false

      t.timestamps
    end

    add_index :account_exports, :account_id
  end
end
