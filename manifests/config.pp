# @summary Generate netplan YAML files
#
# Create netplan YAML files from a Hash of data.
#
# @example Basic config
#   netplan::config { 'example-config': 
#     settings => {
#       network => {
#         version => 2,
#         renderer => networkd,
#         ethernets => {
#           eth0 => {
#             dhcp4 => true,
#           },
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
#   The number prefixed to the generated YAML file
#
# @param file
#   The absolute path of the genrated YAML file
#
# @param file_mode
#   The file permissions for the generated YAML file
#
# @param settings
#   A hash of netplan settings to be included in the generated YAML file
#
define netplan::config (
  Enum['present','absent'] $ensure = 'present',
  String $file_name = $title,
  Integer $priority = 90,
  Stdlib::Absolutepath $file = "/etc/netplan/${priority}-${file_name}.yaml",
  String $file_mode = '0600',
  Hash $settings = {},
) {
  file { $file:
    ensure  => $ensure,
    mode    => $file_mode,
    content => to_yaml($settings),
    notify  => Exec['netplan_cmd'],
  }
}
