# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include netplan
class netplan (
  Array $package_dependencies = ['netplan.io'],
  Optional[Hash] $configs = undef,
) {
  ensure_packages($package_dependencies)
  if $configs {
    $configs.each |String $name, Hash $config| {
      ensure_resource($name, $config)
    }
  }
  exec { 'netplan_apply':
    path        => ['/usr/bin','/usr/sbin'],
    command     => 'netplan apply',
    refreshonly => true,
  }
}
