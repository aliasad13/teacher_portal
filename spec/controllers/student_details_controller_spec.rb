require 'rails_helper'

RSpec.describe StudentDetailsController, type: :controller do
  let(:user) { User.create!(email: 'test@example.com', username: 'test_user', password: 'password', role: 'teacher') }

  let(:valid_attributes) {
    { name: "John Doe", subject: "Math", mark: 85 }
  }

  let(:invalid_attributes) {
    { name: "", subject: "", mark: nil }
  }

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new StudentDetail" do
        login_user
        expect {
          post :create, params: { student_detail: valid_attributes }
        }.to change(StudentDetail, :count).by(1)
      end

      it "redirects to the teacher dashboard" do
        login_user
        post :create, params: { student_detail: valid_attributes }
        expect(response).to redirect_to(teacher_dashboard_path)
      end
    end

    context "with invalid params" do
      it "returns a JSON response with errors" do
        login_user
        post :create, params: { student_detail: invalid_attributes }, format: :json
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end

    context "when student already exists" do
      it "updates the existing student's mark" do
        login_user
        existing_student = StudentDetail.create!(valid_attributes)
        new_attributes = valid_attributes.merge(mark: 90)

        expect {
          post :create, params: { student_detail: new_attributes }
        }.not_to change(StudentDetail, :count)

        existing_student.reload
        expect(existing_student.mark).to eq(175) # 85 + 90
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      login_user
      student_detail = StudentDetail.create! valid_attributes
      get :edit, params: { id: student_detail.to_param }, xhr: true
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { mark: 95 }
      }

      it "updates the requested student_detail" do
        login_user
        student_detail = StudentDetail.create! valid_attributes
        put :update, params: { id: student_detail.to_param, student_detail: new_attributes }
        student_detail.reload
        expect(student_detail.mark).to eq(95)
      end
    end

  end

  describe "DELETE #destroy" do
    it "destroys the requested student_detail" do
      login_user
      student_detail = StudentDetail.create! valid_attributes
      expect {
        delete :destroy, params: { id: student_detail.to_param }
      }.to change(StudentDetail, :count).by(-1)
    end

    it "redirects to the teacher dashboard" do
      login_user
      student_detail = StudentDetail.create! valid_attributes
      delete :destroy, params: { id: student_detail.to_param }
      expect(response).to redirect_to(teacher_dashboard_path)
    end
  end
end