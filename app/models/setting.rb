class Setting < ActiveRecord::Base
  belongs_to :domain
  belongs_to :user

  attr_accessible :domain_id, :user_id, :setting_key, :setting_val, :setting_ord
end
