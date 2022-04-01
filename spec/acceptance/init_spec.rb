# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'matterbridge' do
  context 'with defaults' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        'include matterbridge'
      end
    end
    describe service('matterbridge') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
