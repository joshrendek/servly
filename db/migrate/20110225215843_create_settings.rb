class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :domain_id
      t.integer :user_id
      t.string :setting_key
      t.string :setting_val

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
