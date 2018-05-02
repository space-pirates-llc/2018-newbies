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
      let(:user) { create(:user) }
      let(:user_params) { user.slice(:email, :password) }

      it { is_expected.to redirect_to(dashboard_path) }
      it 'should set current user' do
        subject

        expect(current_user).to eq(user)
      end
    end

    context 'with invalid params' do
      let(:user_params) { { email: 'invalid' } }

      it { is_expected.to have_http_status(:bad_request) }
      it { is_expected.to render_template(:new) }
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
