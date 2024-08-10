class TeachersController < ApplicationController
  before_action :admin_only, only: [:index, :update_role]

  def dashboard
    @student_details = StudentDetail.page(params[:page]).per(10)
  end

  private

  def admin_only
    redirect_to root_path unless current_user.admin?
  end
end