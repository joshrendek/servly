class CreateDiagnosticWorkers < ActiveRecord::Migration
  def self.up
    create_table :diagnostic_workers do |t|
      t.string :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :diagnostic_workers
  end
end
