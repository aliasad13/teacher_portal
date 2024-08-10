require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:admin_user) { User.create!(username: 'admin', password: 'password123', role: 'admin', email: 'admin@example.com') }
  let(:teacher_user) { User.create!(username: 'teacher', password: 'password123', role: 'teacher', email: 'teacher@example.com') }
  let(:regular_user) { User.create!(username: 'user', password: 'password123', role: 'user', email: 'user@example.com') }

  before do
    sign_in admin_user
  end

  describe 'GET #home' do
    context 'when the user is a teacher' do
      before do
        sign_in teacher_user
      end

      it 'redirects to the teacher dashboard' do
        get :home
        expect(response).to redirect_to(teacher_dashboard_path)
        expect(flash[:notice]).to eq('Welcome to the Teacher Dashboard.')
      end
    end

    context 'when the user is not a teacher' do
      it 'does not redirect to the teacher dashboard' do
        get :home
        expect(response).not_to redirect_to(teacher_dashboard_path)
      end
    end
  end

  describe 'GET #dashboard' do
    context 'when the user is an admin' do
      it 'redirects to the admin dashboard' do
        get :dashboard
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end

    context 'when the user is a teacher' do
      before do
        sign_in teacher_user
      end

      it 'redirects to the teacher dashboard' do
        get :dashboard
        expect(response).to redirect_to(teacher_dashboard_path)
      end
    end

    context 'when the user is not an admin or teacher' do
      before do
        sign_in regular_user
      end

      it 'redirects to the home users path with an alert' do
        get :dashboard
        expect(response).to redirect_to(home_users_path)
        expect(flash[:alert]).to eq('Please wait for the admin to assign a role')
      end
    end
  end

  describe 'POST #update_role' do
    let(:user_to_update) { User.create!(username: 'user_to_update', password: 'password123', role: 'user', email: 'user_to_update@example.com') }

    context 'when the update is successful' do
      it 'updates the user role and redirects to root path with a success notice' do
        post :update_role, params: { id: user_to_update.id, role: 'teacher' }
        expect(user_to_update.reload.role).to eq('teacher')
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('User role updated successfully.')
      end
    end

    context 'when the update fails' do
      it 'does not update the user role and redirects to root path with an alert' do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        post :update_role, params: { id: user_to_update.id, role: 'teacher' }
        expect(user_to_update.reload.role).to eq('user') # Role should remain unchanged
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Failed to update user role.')
      end
    end
  end
end
