# frozen_string_literal: true

require 'spec_helper'

describe 'netplan::config' do
  let(:title) { 'default' }
  let(:pre_condition) { 'include netplan' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      context 'simple_config' do
        let(:title) { 'simple_config' }
        let(:params) do
          super().merge(
            {
              'ensure' => 'present',
              'priority' => 20,
              'settings' => {
                'version' => 2,
                'renderer' => 'networkd',
                'ethernets' => {
                  'eth0' => {
                    'dhcp4' => true,
                  },
                },
              },
            },
          )
        end

        it { is_expected.to contain_file("/etc/netplan/#{params['priority']}-#{title}.yaml").with_mode('0600') }
        it { is_expected.to contain_file("/etc/netplan/#{params['priority']}-#{title}.yaml").that_notifies('Exec[netplan_cmd]') }
      end
    end
  end
end
