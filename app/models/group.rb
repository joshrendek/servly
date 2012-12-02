class Group < ActiveRecord::Base
  belongs_to :domain
  has_many :group_servers
  has_many :servers, :through => :group_servers
  has_many :alerts, :as => :alertable  

  attr_accessible :domain_id, :name, :notes
end
