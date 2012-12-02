class CreateTeamUsers < ActiveRecord::Migration
  def self.up
    create_table :team_users do |t|
      t.integer :user_id
      t.integer :domain_id
      t.integer :team_id

      t.timestamps
    end
  end

  def self.down
    drop_table :team_users
  end
end
