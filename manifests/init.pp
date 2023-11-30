# @summary Install and configure netplan
#
# Manages the installation of netplan and controls global options like whether to purge unmanaged files.
#
# @example Basic usage
#   include netplan
#
# @example Purge un-managed files
#   class { netplan:
#     purge_configs => true,
#   }
#
# @example Purge un-managed files, but ignore a given pattern
#   class { netplan:
#     purge_configs => true,
#     purge_ignore  => '90-NM*'
#   }
#
# @param package_dependencies
#   List of packages to install
#
# @param manage_dependencies
#   Whether to install the list of package dependencies or not
#
# @param apply
#   Whether to apply the netplan configuration during the agent run or not
#
# @param purge_configs
#   Whether to purge un-managed netplan YAML files under /etc/netplan
#
# @param purge_ignore
#   Match files to ignore when purging configs under /etc/netplan.
#   Uses the `ignore` attribute of the native puppet `file` resource.
#
# @param configs
#   An optional hash of netplan configurations supplied via hiera
#
class netplan (
  Array $package_dependencies = ['netplan.io'],
  Boolean $manage_dependencies = true,
  Boolean $apply = true,
  Boolean $purge_configs = false,
  Optional[String] $purge_ignore = undef,
  Optional[Hash] $configs = undef,
) {
  case $apply {
    true: {
      $netplan_cmd = 'apply'
    }
    false: {
      $netplan_cmd = 'get'
    }
    default: {
      fail('Invalid value for netplan::apply.')
    }
  }
  if $manage_dependencies == true {
    ensure_packages($package_dependencies)
  }
  file { '/etc/netplan':
    ensure  => directory,
    purge   => $purge_configs,
    ignore  => $purge_ignore,
    recurse => true,
  }
  if $configs {
    $configs.each |String $name, Hash $config| {
      ensure_resource('netplan::config', $name, $config)
    }
  }
  exec { 'netplan_cmd':
    path        => ['/usr/bin','/usr/sbin'],
    command     => "netplan ${netplan_cmd}",
    refreshonly => true,
  }
}
