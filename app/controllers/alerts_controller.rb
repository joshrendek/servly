class AlertsController < ApplicationController
  before_filter :check_group_existence
  before_filter :check_limits, :only => [:new, :create]
  # GET /alerts
  # GET /alerts.xml
  def index
    @alerts = subdomain.alerts.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alerts }
    end
  end

  # GET /alerts/1
  # GET /alerts/1.xml
  def show
    @alert = subdomain.alerts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @alert }
    end
  end

  # GET /alerts/new
  # GET /alerts/new.xml
  def new
    @alert = Alert.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @alert }
    end
  end

  # GET /alerts/1/edit
  def edit
    @alert = subdomain.alerts.find(params[:id])
  end

  # POST /alerts
  # POST /alerts.xml
  def create
    @alert = Alert.new(params[:alert])
    @alert.domain_id = subdomain_id
    alertable = params[:alertable][:alertable]
    targetable = params[:targetable][:targetable]

    alertable_type = ''
    if alertable.include?('team')
      alertable_type = 'team'
    elsif alertable == 'subdomain'
      alertable_type = 'subdomain'
    else
      alertable_type = 'user'
    end

    targetable_type = ''

    logger.info targetable
    if targetable.include?('server')
      targetable_type = 'server'
    else
      targetable_type = 'subdomain'
    end

    targetable_id = targetable.split('_')[1]
    if targetable_type == "subdomain"
      targetable_obj = subdomain
    elsif targetable_type == "server"
      targetable_obj = subdomain.servers.find(targetable_id)
    end

    @alert.targetable = targetable_obj


    alertable_id = alertable.split('_')[1]
    if alertable_type == "team"
      alertable_obj = subdomain.teams.find(alertable_id)
    elsif alertable_type == "subdomain"
      alertable_obj = subdomain
    else
      alertable_obj = subdomain.users.find(alertable_id)
    end

    @alert.alertable = alertable_obj



    if @alert.save
      redirect_to(alerts_path, :notice => 'Alert was successfully created.')
    else
      render :action => "new"

    end
  end

  # PUT /alerts/1
  # PUT /alerts/1.xml
  def update
    @alert = subdomain.alerts.find(params[:id])

    respond_to do |format|
      if @alert.update_attributes(params[:alert])
        format.html { redirect_to(@alert, :notice => 'Alert was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alert.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.xml
  def destroy
    @alert = subdomain.alerts.find(params[:id])
    @alert.destroy

    respond_to do |format|
      format.html { redirect_to(alerts_url) }
      format.xml  { head :ok }
    end
  end

  private
  def check_group_existence
    if subdomain.groups.size == 0
      redirect_to groups_path, :notice => "You need to create a group first."
    end
  end

  def check_limits
    if subdomain.alerts.size >= subdomain.alert_limit
      flash[:error] = "You must delete a URL monitor or upgrade your package to add another."
      redirect_to alerts_url
    end
  end
end
