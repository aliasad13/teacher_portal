# app/controllers/student_details_controller.rb
class StudentDetailsController < ApplicationController
  before_action :set_student_detail, only: [:show, :edit, :update, :destroy]

  def new
    @student_detail = StudentDetail.new
  end

  def create
    existing_student = StudentDetail.find_by(name: student_detail_params[:name], subject: student_detail_params[:subject])

    if existing_student
      new_mark = existing_student.mark + student_detail_params[:mark].to_i
      if existing_student.update(mark: new_mark)
        redirect_to teacher_dashboard_path, notice: 'Student marks were successfully updated.'
      else
        render json: { success: false, errors: existing_student.errors.full_messages }
      end
    else
      @student_detail = StudentDetail.new(student_detail_params)

      if @student_detail.save
        redirect_to teacher_dashboard_path, notice: 'Student mark was successfully added.'
      else
        render json: { success: false, errors: @student_detail.errors.full_messages }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js # This will render `edit.js.erb`
    end
  end

  def update
    if @student_detail.update(student_detail_params)
      redirect_to teacher_dashboard_path, notice: 'Student mark was successfully updated.'
    else
      format.html { render :edit }
      format.js
    end
  end

  def destroy
    @student_detail.destroy
    redirect_to teacher_dashboard_path, notice: 'Student mark was successfully deleted.'
  end

  private

  def set_student_detail
    @student_detail = StudentDetail.find(params[:id])
  end

  def student_detail_params
    params.require(:student_detail).permit(:name, :subject, :mark)
  end
end