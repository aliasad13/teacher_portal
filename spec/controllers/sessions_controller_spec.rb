# spec/controllers/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create!(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user and redirects to the root path" do
        post :create, params: { user: { email: @user.email, password: @user.password } }

        expect(response).to redirect_to(root_path)
        expect(controller.current_user).to eq(@user)
      end
    end

    context "with invalid credentials" do
      it "does not log in the user and re-renders the login page" do
        post :create, params: { user: { email: @user.email, password: 'wrongpassword' } }

        expect(response).to render_template(:new)
        expect(controller.current_user).to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    it "logs out the user and redirects to the root path" do
      sign_in @user
      delete :destroy

      expect(response).to redirect_to(root_path) # Update the expectation to match the actual behavior
      expect(controller.current_user).to be_nil
    end
  end
end
