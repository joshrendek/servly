class TriggeredAlert < ActiveRecord::Base
  belongs_to :alert
  belongs_to :triggerable, :polymorphic => true
  belongs_to :domain

  paginates_per 25

  attr_accessible :domain_id, :alert_id, :triggerable
end
