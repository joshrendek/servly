class CreateDiagnosticLogs < ActiveRecord::Migration
  def self.up
    create_table :diagnostic_logs do |t|
      t.integer :diagnostic_worker_id
      t.string :command
      t.text :output
      t.integer :server_id
      t.integer :domain_id

      t.timestamps
    end
  end

  def self.down
    drop_table :diagnostic_logs
  end
end
