class TeachersController < ApplicationController
  def dashboard
    @student_details = StudentDetail.page(params[:page]).per(10)
  end

end