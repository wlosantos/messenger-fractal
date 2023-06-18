class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :content, null: false, default: ""
      t.integer :moderation_status, null: false, default: 0
      t.timestamp :moderated_at, null: true, default: nil
      t.timestamp :refused_at, null: true, default: nil
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :messages }

      t.timestamps
    end
  end
end
