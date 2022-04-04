# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'matterbridge' do
  context 'with minimal config' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'matterbridge':
          config => {
            'irc' => {
              'libera' => {
                'Server' => 'irc.libera.chat:6667',
                'Nick' => 'test',
              },
            },
            'gateway' => {
              'name' => 'foo',
              'enable' => true,
              'inout' => {
                'account' => 'irc.libera',
                'channel' => '#testing',
              },
            },
          },
        }
        PUPPET
      end
    end
    describe service('matterbridge') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
