class Message < ActiveRecord::Base
  belongs_to :log

  attr_accessible :message, :message_type
end
