# @summary Generate netplan YAML files
#
# Create netplan YAML files from a Hash of data.
#
# @example Basic config
#   netplan::config { 'example-config': 
#     settings => {
#       version => 2,
#       renderer => networkd,
#       ethernets => {
#         eth0 => {
#           dhcp4 => true,
#         },
#       },
#     },
#   }
#
# @param ensure
#   Ensure presence/absence of the resource
#
# @param file_name
#   The filename to use for the generated YAML file
#
# @param priority
#   The string/number prefixed to the generated YAML file
#
# @param file
#   The absolute path of the genrated YAML file
#
# @param file_mode
#   The file permissions for the generated YAML file
#
# @param header
#   The file header for the generated YAML file
#
# @param settings
#   A hash of netplan settings to be included in the generated YAML file
#
define netplan::config (
  Enum['present','absent'] $ensure = 'present',
  String $file_name = $title,
  Variant[String, Integer[0]] $priority = 90,
  Stdlib::Absolutepath $file = "/etc/netplan/${priority}-${file_name}.yaml",
  String $file_mode = '0600',
  String $header = '# This file is managed by Puppet. DO NOT EDIT.',
  Hash $settings = {},
) {
  $netplan_yaml = to_yaml({ network => $settings })
  file { $file:
    ensure  => $ensure,
    mode    => $file_mode,
    content => "${header}\n${netplan_yaml}",
    notify  => Exec['netplan_cmd'],
  }
}
