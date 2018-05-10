require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account Activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@mf2018.youki.io"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Panda World")
    end
  end

  #TODO: 途中まで書いたけど、linkがうまく生成されなくてエラーになっているので直す
  # describe "password_reset" do
  #   let(:user) { create(:user, :with_request_password_reset, :with_activated) }
  #   let(:mail) { UserMailer.password_reset(user) }
  #
  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq([user.email])
  #     expect(mail.from).to eq(["info@mf2018.youki.io"])
  #   end
  #
  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Password reset")
  #   end
  # end
end
