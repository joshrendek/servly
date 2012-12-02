When /^there has been another user created$/ do
  @user = User.create(:email => "test2@test.com", :password => "test123456", :password_confirmation => "test123456")
  @user.save

  @du = DomainUser.create(:user_id => @user.id, :domain_id => Domain.first.id, :active => 1)
  @du.save


end
When /^I click on the last user's manage link$/ do
  click_link("manage_#{@du.id}")
end