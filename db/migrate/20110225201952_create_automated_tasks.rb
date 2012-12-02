class CreateAutomatedTasks < ActiveRecord::Migration
  def self.up
    create_table :automated_tasks do |t|
      t.integer :domain_id
      t.integer :server_id
      t.string :command
      t.text :output

      t.timestamps
    end
  end

  def self.down
    drop_table :automated_tasks
  end
end
