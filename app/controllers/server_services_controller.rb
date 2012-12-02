class ServerServicesController < ApplicationController
  before_filter :ownership_required, :except => [:create] 

  protect_from_forgery :except => [:destroy]

  # GET /server_services/1
  # GET /server_services/1.xml
  def show
    @server_service = subdomain.servers.find(params[:server_id]).server_services.where('id = ?', params[:id])
    render :xml => @server_service  
  end

 
  def create
    @server_service = subdomain.servers.find(params[:server_id]).server_services.build(params[:server_service])
    @server_service.domain_id = subdomain_id
    @server_service.status = 0
      if @server_service.save
       redirect_to(@server_service.server, :notice => 'Server service was successfully created.') 
      else
        redirect_to(@server_service.server, :notice => 'Service was unable to be created.')
      end
  end



  def destroy
    @server_service = subdomain.servers.find(params[:server_id]).server_services.where('id = ?', params[:id]).first
    @server_service.destroy

    render :text => 'OK'
    
  end
end
