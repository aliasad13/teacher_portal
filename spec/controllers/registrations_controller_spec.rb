# spec/controllers/users/registrations_controller_spec.rb

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:valid_attributes) do
    { email: 'test@example.com', username: 'testuser', password: 'password123', password_confirmation: 'password123' }
  end

  let(:invalid_attributes) do
    { email: '', username: '', password: 'password123', password_confirmation: 'password123' }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end


      it 'redirects to the correct path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(controller.send(:after_sign_up_path_for, User.last))
      end

      it 'sets a flash notice' do
        post :create, params: { user: valid_attributes }
        expect(flash[:notice]).to eq(I18n.t('devise.registrations.signed_up'))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it 'redirects to the new registration path' do
        post :create, params: { user: invalid_attributes }
        expect(response).to redirect_to(new_user_registration_path)
      end

      it 'sets the flash errors' do
        post :create, params: { user: invalid_attributes }
        expect(flash[:errors]).to be_present
      end
    end
  end
end
