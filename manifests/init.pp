# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include netplan
class netplan (
  Array $package_dependencies = ['netplan.io'],
  Boolean $apply = true,
  Boolean $purge_configs = false,
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
  ensure_packages($package_dependencies)
  file { '/etc/netplan':
    ensure  => directory,
    purge   => $purge_configs,
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
