class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :domain_users

  has_many :alerts, :as => :alertable

  belongs_to :sms_gateway

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def active_for?(subdomain)
    subdomain.domain_users.where(:user_id => id).first.active
  end
  def alerts_for?(subdomain)
    subdomain.domain_users.where(:user_id => id).first.alerts?
  end

  def relative_domain_user(subdomain)
    subdomain.domain_users.where(:user_id => id).first
  end
end
