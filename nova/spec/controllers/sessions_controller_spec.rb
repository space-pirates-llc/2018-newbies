# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe 'GET #new' do
    subject { get :new }
    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template(:new) }
  end

  describe 'POST #create' do
    subject { post :create, params: { user: user_params } }
    context 'with valid params' do
      context 'correct password' do
        context 'activated user' do
          let(:user) { create(:user) }
          let(:user_params) { user.slice(:email, :password) }

          it 'redirect correct path' do
            is_expected.to redirect_to(root_path) 
          end
        end

        context 'unactivated user' do 
          let(:user) { create(:user) }
          let(:user_params) { user.slice(:email, :password) }

          it 'inactivated user with correct password should be redirect to the root' do
            is_expected.to redirect_to(root_path) 
          end
        end
      end
    end

    context 'with invalid params' do
      let(:user_params) { { email: 'invalid' } }
      it 'return status' do 
        is_expected.to have_http_status(302)
        is_expected.to redirect_to(login_path) 
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy }

    context 'with logged in' do
      before do
        login!
      end

      it { is_expected.to redirect_to(login_path) }
    end

    context 'without logged in' do
      it { is_expected.to redirect_to(login_path) }
    end
  end
end