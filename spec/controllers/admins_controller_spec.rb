require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  let(:admin) do
    User.create!(
      email: 'admin@example.com',
      username: 'adminuser',
      password: 'password123',
      password_confirmation: 'password123',
      role: 'admin'
    )
  end

  let(:user) do
    User.create!(
      email: 'user@example.com',
      username: 'regularuser',
      password: 'password123',
      password_confirmation: 'password123',
      role: 'user'
    )
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #dashboard' do
    context 'when user is not logged in' do
      it 'redirects to the sign-in page' do
        get :dashboard
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in but not an admin' do
      before do
        sign_in user
      end

      it 'redirects to the root path with an access denied alert' do
        get :dashboard
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access denied.')
      end
    end

    context 'when user is an admin' do
      before do
        sign_in admin
      end

      it 'renders the dashboard template' do
        get :dashboard
        expect(response).to render_template(:dashboard)
      end

      it 'assigns @users with paginated user records' do
        # Create additional users for pagination testing
        15.times do |i|
          User.create!(
            email: "user#{i}@example.com",
            username: "user#{i}",
            password: 'password123',
            password_confirmation: 'password123',
            role: 'user'
          )
        end

        get :dashboard, params: { page: 1 }
        expect(assigns(:users).count).to eq(10) # Should match per-page limit
        expect(assigns(:users).current_page).to eq(1)
      end
    end
  end
end
