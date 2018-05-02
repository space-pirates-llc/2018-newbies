# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '#default_meta_tags' do
    subject(:default_meta_tags) { helper.default_meta_tags }

    it { is_expected.to be_a(Hash) }
  end

  describe '#default_meta' do
    context 'with foo/bar controller and show action' do
      it 'should get locales' do
        expect(helper).to receive(:controller_path).and_return('foo/bar')
        expect(helper).to receive(:action_name).and_return('show')

        expect(helper).to receive(:t).with('foo.bar.show.title', default: [:"foo.bar.title", :"foo.title", '']).and_return('spec')

        expect(helper.default_meta('title')).to eq('spec')
      end
    end
  end

  describe '#html_classes' do
    subject(:html_classes) { helper.html_classes }

    before do
      expect(helper).to receive(:controller_path).and_return('foo/bar')
      expect(helper).to receive(:action_name).and_return('show')
    end

    it { is_expected.to include('foo-bar-controller') }
    it { is_expected.to include('show-action') }
  end
end
