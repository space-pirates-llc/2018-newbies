# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    subject { get :new }

    it { is_expected.to have_http_status(:ok) }
    it { is_expected.to render_template(:new) }
  end

  describe 'POST #create' do
    subject { post :create, params: { user: user_params } }

    context 'with valid params' do
      let(:user_params) { attributes_for(:user) }

      it { is_expected.to redirect_to(signup_path) }
    end

    context 'with invalid params' do
      let(:user_params) { { nickname: 'invalid' } }

      it { is_expected.to have_http_status(:bad_request) }
      it { is_expected.to render_template(:new) }
    end
  end
end
