# RSpecでのリクエスト時に、ヘッダーを設定するshared_context
# api/application_controller.rb での、CSRF対策のチェックを満たす為に必要になる
RSpec.shared_context 'request from nova site' do
  before do
    request.headers['Host'] = "example.com"
    request.headers['Origin'] = "http://example.com"
  end
end
