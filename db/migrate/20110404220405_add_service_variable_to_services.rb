class AddServiceVariableToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :service_variable, :string
  end

  def self.down
    remove_column :services, :service_variable
  end
end
