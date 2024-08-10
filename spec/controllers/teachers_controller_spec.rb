require 'rails_helper'

RSpec.describe TeachersController, type: :controller do
  let(:admin_user) { User.create!(username: 'admin', password: 'password123', role: 'admin', email: 'testadmin@example.com') }
  let(:teacher) { User.create!(username: 'teacher', password: 'password123', role: 'teacher', email: 'testteacher@example.com') }

  before do
    sign_in admin_user
  end

  describe 'GET #dashboard' do
    before do
      15.times do |i|
        StudentDetail.create!(name: "Student #{i}", subject: "Subject #{i}", mark: (i + 1) * 10)
      end
    end

    it 'assigns @student_details and renders the dashboard template' do
      get :dashboard
      expected_student_details = StudentDetail.page(nil).per(10) # Adjust per page if necessary
      expect(assigns(:student_details)).to match_array(expected_student_details)
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:dashboard)
    end
  end

  describe 'GET #dashboard when not signed in' do
    before { sign_out admin_user }

    it 'redirects to sign in page' do
      get :dashboard
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
