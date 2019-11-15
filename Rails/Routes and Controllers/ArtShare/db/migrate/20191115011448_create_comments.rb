class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :artwork_id, null: false
      t.integer :commenter_id, null: false
      t.string :body, null: false
      t.timestamps
    end
    add_index :comments, :artwork_id
    add_index :comments, :commenter_id
  end
end
