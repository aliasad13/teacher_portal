class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def dashboard
    @users = User.page(params[:page]).per(10)
  end

  private

  def admin_only
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end