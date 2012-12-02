class Alert < ActiveRecord::Base
  belongs_to :alertable, :polymorphic => true
  belongs_to :targetable, :polymorphic => true
  belongs_to :domain
  validates_presence_of :threshold_value
  validates_numericality_of :threshold_value
  #has_many :users, :through => AlertUsers
  #
  attr_accessible :threshold_stat, :threshold_value, :active, :threshold_time, :alertable, 
                  :start_time, :end_time, :operator, :targetable

  def self.alertable_stats
    x = []
    Server.columns_hash.each do |s|
      x << [s[0].humanize, s[0]] unless ['id', 'group_id', 'domain_id', 'hostname','created_at', 'release', 'updated_at', 'kernel', 'ip', 'location', 'os', 'ps'].include?(s[0])
    end

    return x
  end

end
