# frozen_string_literal: true

require 'spec_helper'

describe 'netplan' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {}
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('netplan.io').with_ensure('present') }
      it { is_expected.to contain_file('/etc/netplan') }
      
      context 'Purge un-managed' do
        let(:params) do
          super().merge({
            'purge_configs' => true,
            'purge_ignore'  => '90-NM*'
          })
        end
        it { is_expected.to contain_file('/etc/netplan').with(
          'purge' => params['purge_configs'],
          'ignore' => params['purge_ignore'],
        )}
        context 'Generate configs from hiera' do
          let(:params) do
            super().merge({
              'configs' => {
                'example1' => {},
                'example2' => {},
                'example3' => {},
              }
            })
          end
          it {
            params['configs'].each do | name, hash |
              is_expected.to contain_file("/etc/netplan/90-#{name}.yaml").that_notifies('Exec[netplan_cmd]')
            end
          }
        end
      end
    end
  end
end
