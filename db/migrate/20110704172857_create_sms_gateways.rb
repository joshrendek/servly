class CreateSmsGateways < ActiveRecord::Migration
  def self.up
    create_table :sms_gateways do |t|
      t.string :carrier
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :sms_gateways
  end
end
