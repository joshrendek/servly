class DomainUserGroupPermissionsController < ApplicationController
  before_filter :verify_not_owner

  before_filter :check_groups_exist

  def index
    @domain_user_group_permissions = subdomain.domain_users.find(params[:id]).domain_user_group_permissions

    @dupg = DomainUserGroupPermission.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @domain_user_group_permissions }
    end
  end


    # POST /domain_user_group_permissions
    # POST /domain_user_group_permissions.xml
  def create
    @domain_user_group_permission = DomainUserGroupPermission.new(params[:dupg])
    @domain_user_group_permission.domain_user_id = params[:id]
    @domain_user_group_permission.domain_id = subdomain_id

    if @domain_user_group_permission.save
      flash[:message] = 'Domain user group permission was successfully created.'
      redirect_to(permissions_path(params[:id]))
    else
      render :action => "new"
    end
  end


    # DELETE /domain_user_group_permissions/1
    # DELETE /domain_user_group_permissions/1.xml
  def destroy
    @domain_user_group_permission = subdomain.domain_users.find(params[:id]).domain_user_group_permissions.find(params[:permission_id])
    @domain_user_group_permission.destroy
    flash[:message] = "Permission removed"
    redirect_to(permissions_path(params[:id]))

  end

  protected
  def verify_not_owner
    if subdomain.user_id == subdomain.domain_users.find(params[:id]).user.id
      redirect_to user_management_index_path, :notice => "You cannot set permissions on the account owner"
    end
  end

  def check_groups_exist
    if subdomain.groups.size == 0
      flash[:notice] = "You must create a group before you can set a users permissions."
      redirect_to groups_path
    end
  end
end
