class UrlMonitorsController < ApplicationController
  # GET /url_monitors
  # GET /url_monitors.xml
  before_filter :check_limits, :only => [:create, :new]

  def index
    @url_monitors = subdomain.url_monitors

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @url_monitors }
    end
  end

  # GET /url_monitors/1
  # GET /url_monitors/1.xml
  def show
    @url_monitor = subdomain.url_monitors.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @url_monitor }
    end
  end

  # GET /url_monitors/new
  # GET /url_monitors/new.xml
  def new
    @url_monitor = UrlMonitor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @url_monitor }
    end
  end

  # GET /url_monitors/1/edit
  def edit
    @url_monitor = UrlMonitor.find(params[:id])
  end

  # POST /url_monitors
  # POST /url_monitors.xml
  def create
    @url_monitor = UrlMonitor.new(params[:url_monitor])
    @url_monitor.domain_id = subdomain_id

    respond_to do |format|
      if @url_monitor.save
        format.html { redirect_to(@url_monitor, :notice => 'Url monitor was successfully created.') }
        format.xml  { render :xml => @url_monitor, :status => :created, :location => @url_monitor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @url_monitor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /url_monitors/1
  # PUT /url_monitors/1.xml
  def update
    @url_monitor = subdomain.url_monitors.find(params[:id])

    respond_to do |format|
      if @url_monitor.update_attributes(params[:url_monitor])
        format.html { redirect_to(@url_monitor, :notice => 'Url monitor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @url_monitor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /url_monitors/1
  # DELETE /url_monitors/1.xml
  def destroy
    @url_monitor = subdomain.url_monitors.find(params[:id])
    @url_monitor.destroy

    respond_to do |format|
      format.html { redirect_to(url_monitors_url) }
      format.xml  { head :ok }
    end
  end

  private
  def check_limits
    if subdomain.url_monitors.size >= subdomain.server_limit
      flash[:error] = "You must delete a URL monitor or upgrade your package to add another."
      redirect_to url_monitors_path
    end
  end
end
