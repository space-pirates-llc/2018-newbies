require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do

  describe "GET #new" do
    subject { get :new }

    it "httpリクエストが成功すること" do
      is_expected.to have_http_status(:ok)
      is_expected.to render_template(:new)
    end
  end

  describe "POST #create" do
    subject { post :create, params: { password_reset: password_reset_params } }

    context "signupしているユーザーの場合" do
      let(:user) { create(:user, :with_request_password_reset) }
      let(:password_reset_params) { user.slice(:email) }

      it 'TOPページに遷移すること' do
        is_expected.to redirect_to(root_path)
      end
    end

    context "signupしていないユーザーの場合" do
      let(:password_reset_params) { {email: 'yunayuna@example.com'} }

      it 'パスワードリセット画面にリダイレクトすること' do
        is_expected.to have_http_status(:ok)
        is_expected.to render_template(:new)
      end
    end
  end

  #TODO: authenticated?メソッドがうまくいかないくて、302が返ってきてしまっているので直す
  # describe "GET #edit" do
  #   subject { get :edit, params: { id: user.reset_digest, email: user.email } }
  #   let(:user) { create(:user, :with_request_password_reset) }
  #
  #   it "httpリクエストが成功すること" do
  #     is_expected.to have_http_status(:ok)
  #     is_expected.to render_template(:edit)
  #   end
  # end
  #
  # describe "PUT #update" do
  #   subject { put :update, params: { id: user.reset_digest, email: user.email, user_params } }
  #   let(:user) { create(:user, :with_request_password_reset, :with_activated ) }
  #
  #   context "入力されたパスワードが空の場合" do
  #     let(:user_params) { { password: "", password_reset: "" } }
  #
  #     it "パスワード再設定画面にリダイレクトすること" do
  #       is_expected.to have_http_status(:ok)
  #       is_expected.to render_template(:edit)
  #     end
  #   end
  #
  #   context "正常なパスワードが入力された場合" do
  #     let(:user_params) { { password: "password", password_reset: "password" } }
  #
  #     it "ダッシュボード画面に遷移すること" do
  #       is_expected.to have_http_status(:ok)
  #       is_expected.to redirect_to(dashboard_path)
  #     end
  #   end
  #
  #   context "入力されたパスワードとパスワード(確認)が一致しない場合" do
  #     let(:user_params) { { password: "password", password_reset: "passwo" } }
  #
  #     it "パスワード再設定画面にリダイレクトすること" do
  #       is_expected.to have_http_status(:ok)
  #       is_expected.to render_template(:edit)
  #     end
  #   end
  # end
end
