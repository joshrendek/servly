class AgentController < ApplicationController
  skip_before_filter :authenticate_user!, :check_permissions, :only => [:installer, :installer_files]
  before_filter :verify_key, :only => [:installer, :installer_files]
  skip_before_filter :restricted_to_groups

  skip_before_filter :verify_domain_user, :except => [:index]
  skip_before_filter :check_server_num
  
  def index
    @key = Domain.find(subdomain_id).api_key 
    @agent_dl = "curl http://#{account_subdomain}.servly.com/agent/installer?key=#{@key} | sh"
    
    @scripts = [
            {:title => "Servly Linux", :filename => "agents/servly.py", :url => "linux"},
            {:title => "Servly BSD", :filename => "agents/servly.py", :url => "bsd"},
            {:title => "Servly Solaris", :filename => "agents/servly.py", :url => "solaris"},
            {:title => "Servly OSX", :filename => "agents/servly.py", :url => "osx"}
    ]
    
  end

  def download
  end

  def installer_files
    @api_key = Domain.find(subdomain_id).api_key    
    file_name = params[:file]
    output = ""
    if file_name == 'core'
      File.open(RAILS_ROOT + "/agents/servly_core.py", "r").each{ |f| output << f }
      render :text => output
    elsif file_name == 'services'
      File.open(RAILS_ROOT + "/agents/servly_services.py", "r").each{ |f| output << f }
      render :text => output
    elsif file_name == 'agent'
      File.open(RAILS_ROOT + "/agents/servly.py", "r").each{ |f| output << f }
      output.gsub!('DOMAIN', Domain.find(subdomain_id).subdomain)
      output.gsub!('KEY', "?key="+@api_key)

      render :text => output
    else
      render :text => 'Servly file not found'
    end
  end

  def installer
    @api_key = Domain.find(subdomain_id).api_key
    
    render :layout => nil    
  end
end
