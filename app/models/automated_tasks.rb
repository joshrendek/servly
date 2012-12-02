class AutomatedTasks < ActiveRecord::Base
  attr_accessible :server_id, :command, :output
end
