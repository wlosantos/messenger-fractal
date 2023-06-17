class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.integer :kind, null: false, default: 0
      t.boolean :read_only, null: false, default: false
      t.boolean :moderated, null: false, default: false
      t.references :origin, null: false, foreign_key: { to_table: :users }
      t.references :moderator, null: true, foreign_key: { to_table: :users }
      t.references :app, null: false, foreign_key: true

      t.timestamps
    end
  end
end
