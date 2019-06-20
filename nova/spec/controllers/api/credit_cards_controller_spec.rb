# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::CreditCardsController, type: :controller do
  include_context 'request from nova site'

  let(:user) { create(:user) }

  describe 'GET #show' do
    subject { get :show }

    context 'without logged in' do
      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'with logged in' do
      before { sign_in(user) }

      it { is_expected.to have_http_status(:ok) }
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { credit_card: { source: stripe.generate_card_token } } }

    context 'without logged in' do
      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'with logged in' do
      before { sign_in(user) }

      it { is_expected.to have_http_status(:created) }
    end
  end
end
