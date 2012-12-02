class CreateUrlMonitors < ActiveRecord::Migration
  def self.up
    create_table :url_monitors do |t|
      t.string :url
      t.float :response_time
      t.integer :status_code
      t.string :keyword
      t.integer :domain_id
      t.text :current_run
      t.integer :current_status

      t.timestamps
    end
  end

  def self.down
    drop_table :url_monitors
  end
end
