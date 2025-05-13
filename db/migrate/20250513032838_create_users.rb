class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :referral_code, null: false
      t.references :referred_by, foreign_key: { to_table: :users }, null: true
      t.integer :referral_count, default: 0
      t.integer :reward_points, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :referral_code, unique: true
  end
end
