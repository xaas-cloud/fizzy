class AddInvolvementToAccesses < ActiveRecord::Migration[8.1]
  def change
    change_table :accesses do |t|
      t.string :involvement, null: false, default: "watching"
    end
  end
end
