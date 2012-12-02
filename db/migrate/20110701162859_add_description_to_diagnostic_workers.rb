class AddDescriptionToDiagnosticWorkers < ActiveRecord::Migration
  def self.up
    add_column :diagnostic_workers, :description, :string
  end

  def self.down
    remove_column :diagnostic_workers, :description
  end
end
