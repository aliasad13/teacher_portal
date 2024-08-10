class UsersController < ApplicationController
  before_action :admin_only, only: [:index, :update_role]

  def home
    if current_user.teacher?
      redirect_to teacher_dashboard_path, notice: 'Welcome to the Teacher Dashboard.'
    end
  end

  def dashboard
    if current_user.admin?
      redirect_to admin_dashboard_path
    elsif current_user.teacher?
      redirect_to teacher_dashboard_path
    else
      redirect_to home_users_path, alert: 'Please wait for the admin to assign a role'
    end
  end

  def update_role
    @user = User.find(params[:id])
    if @user.update(role: params[:role])
      redirect_to root_path, notice: 'User role updated successfully.'
    else
      redirect_to root_path, alert: 'Failed to update user role.'
    end
  end

  private

  def admin_only
    redirect_to root_path unless current_user.admin?
  end
end