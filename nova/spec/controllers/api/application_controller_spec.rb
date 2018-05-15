# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ApplicationController, type: :controller do

  let(:user) { create(:user) }

  describe "before_action :verify_request_from_same_origin" do
    controller do
      def index
        render plain: "ok"
      end
    end

    subject { get :index }

    before { sign_in(user) }

    context 'with correct headers' do
      include_context 'request from nova site'

      it { is_expected.to have_http_status(:ok) }
    end

    context 'with incorrect headers' do
      before do
        request.headers['Host'] = 'example.com'
        request.headers['Origin'] = 'http://evil.example.co.jp'
      end

      it { is_expected.to have_http_status(:forbidden) }
    end

    context 'with empty origin header' do
      before do
        request.headers['Host'] = 'example.com'
        request.headers['Origin'] = ''
      end

      it { is_expected.to have_http_status(:forbidden) }
    end

    context 'with empty host header' do
      before do
        request.headers['Host'] = ''
        request.headers['Origin'] = 'http://example.com'
      end

      it { is_expected.to have_http_status(:forbidden) }
    end
  end
end
