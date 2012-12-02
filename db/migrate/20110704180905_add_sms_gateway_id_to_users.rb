class AddSmsGatewayIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sms_gateway_id, :integer
  end

  def self.down
    remove_column :users, :sms_gateway_id
  end
end
