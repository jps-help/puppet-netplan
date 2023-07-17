# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   netplan::config { 'namevar': }
define netplan::config (
  Enum['present','absent'] $ensure = 'present',
  String $file_name = $title,
  Integer $priority = 90,
  Stdlib::Absolutepath $file = "/etc/netplan/${priority}-${name}",
  String $file_mode = '0600',
  Hash $settings = {},
) {
  file { $file:
    ensure  => 'file',
    mode    => $file_mode,
    content => to_yaml($settings),
    notify  => Exec['netplan_apply'],
  }
}
