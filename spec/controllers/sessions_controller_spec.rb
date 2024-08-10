require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  # Create a user instance manually
  let(:user) do
    User.create!(
      email: 'test@example.com',
      username: 'testuser',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  let(:valid_attributes) { { login: user.username, password: 'password123' } }
  let(:invalid_attributes) { { login: user.username, password: 'wrongpassword' } }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'signs the user in and redirects to the correct path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path) # Adjust according to your expected path
        expect(controller.current_user).to eq(user)
        expect(flash[:notice]).to eq(I18n.t('devise.sessions.signed_in'))
      end
    end

    context 'with invalid attributes' do
      it 'does not sign the user in and re-renders the new template with an alert' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
        expect(controller.current_user).to be_nil
        expect(flash[:alert]).to eq(I18n.t('devise.failure.invalid', authentication_keys: 'Login'))
      end
    end
  end
end
