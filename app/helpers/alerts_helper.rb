module AlertsHelper
  def alertable_users
    subdomain.users.collect {|u| [u.email, "user_#{u.id}"] }
  end
  def alertable_teams
    subdomain.teams.collect {|t| [t.name, "team_#{g.id}"] }
  end

  def alertables
    x = []
    x << ["All users", "subdomain"]
    subdomain.teams.collect {|t| x << ["Team: #{t.name}", "team_#{t.id}"] }
    subdomain.users.collect {|u| x << ["User: " + u.email, "user_#{u.id}"] }
    return x
  end

  def targetables
    x = []
    x << ["All Servers", "subdomain"]
    subdomain.servers.collect {|t| x << ["#{t.hostname}", "server_#{t.id}"] }
    return x
  end

  def start_time_default
    Time.now.advance(:hours => -1 * Time.now.hour, :minutes => -1 * Time.now.min)
  end
  def end_time_default
    start_time_default.advance(:hours => 23, :minutes => 59)
  end
end
