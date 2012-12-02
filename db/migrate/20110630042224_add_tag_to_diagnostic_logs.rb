class AddTagToDiagnosticLogs < ActiveRecord::Migration
  def self.up
    add_column :diagnostic_logs, :tag, :string
  end

  def self.down
    remove_column :diagnostic_logs, :tag
  end
end
