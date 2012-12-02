Given /^the following apis:$/ do |apis|
  Api.create!(apis.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) api$/ do |pos|
  visit apis_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following apis:$/ do |expected_apis_table|
  expected_apis_table.diff!(tableish('table tr', 'td,th'))
end

Given /^I add a user with subdomain "([^"]*)", email "([^"]*)", password "([^"]*)", serverlimit "([^"]*)", alert_limit "([^"]*)", url_monitor_limit "([^"]*)", and user_limit "([^"]*)"$/ do |arg1, arg2, arg3, arg4, arg5, arg6, arg7|
  visit add_user_api_index_path(:key => CONTROL_API_SECRET_KEY, 
                                :password => arg3, 
                                :password_confirmation => arg3,
                                :email => arg2,
                                :subdomain => arg1,
                                :server_limit => arg4,
                                :alert_limit => arg5,
                                :url_monitor_limit => arg6,
                                :user_limit => arg7 ) 
end

Given /^I change the password for "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
  temp = User.first.encrypted_password
  visit change_password_api_index_path(:key => CONTROL_API_SECRET_KEY,
                                       :email => arg1, :pass => arg2)
  temp2 = User.first.encrypted_password
  assert_not_equal temp, temp2
end

When /^I suspend subdomain "([^"]*)"$/ do |arg1|
  visit suspend_domain_api_index_path(:key => CONTROL_API_SECRET_KEY,
                                      :subdomain => arg1)
end


Then /^it should have an API key$/ do
  d = Domain.find_by_subdomain('test')
  assert_not_nil d.api_key
end

