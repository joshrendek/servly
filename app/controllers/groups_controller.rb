class GroupsController < ApplicationController

  skip_before_filter :restricted_to_groups, :only => [:index, :show]



  # GET /groups
  # GET /groups.xml
  def index
    g = user_is_restricted_to_these_groups
    if g != 0
      @groups = g
    else
      @groups = subdomain.groups
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  def add_server
    GroupServer.create(:domain_id => subdomain_id, :server_id => params[:gs][:server_id], :group_id => params[:id])
    
    redirect_to group_path(params[:id]), :notice => "Server added to group."
  end

  def remove_server
    @gs = subdomain.groups.find(params[:id]).group_servers.where(:server_id => params[:server_id]).first
    if @gs.destroy
      redirect_to group_path(params[:id]), :notice => "Server removed from group."
    else
      redirect_to group_path(params[:id]), :error => "Server unable to be removed from group."
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    if user_is_restricted_to_these_groups == 0 || user_is_restricted_to_these_groups.size == 0
      @group = subdomain.groups.find(params[:id])
    else
      @group = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.where(:group_id => params[:id]).first.group
    end



    @servers = @group.servers

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = subdomain.groups.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @group.domain_id = subdomain_id

    respond_to do |format|
      if @group.save
        flash[:message] = "Group was created successfully."
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = subdomain.groups.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = subdomain.groups.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
end
