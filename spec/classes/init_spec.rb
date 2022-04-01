# frozen_string_literal: true

require 'spec_helper'

describe 'matterbridge' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_systemd__unit_file('matterbridge.service') }
        it { is_expected.to contain_user('matterbridge') }
        it { is_expected.to contain_group('matterbridge') }
        it { is_expected.to contain_file('/usr/local/bin/matterbridge').with_ensure('link') }
        it { is_expected.to contain_file('/opt/matterbridge/matterbridge-1.24.1-linux-64bit') }
      end
    end
  end
end
