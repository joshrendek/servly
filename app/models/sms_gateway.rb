class SmsGateway < ActiveRecord::Base
  attr_accessible :carrier, :address
end
