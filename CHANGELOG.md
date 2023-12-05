# Changelog

All notable changes to this project will be documented in this file.

## Release 2.0.0
### Breaking
- Restrict `netplan::config` `priority` integers to positive values only - [#11](https://github.com/jps-help/puppet-netplan/pull/11)

### Added
- Add a header to generated netplan YAML files - [#11](https://github.com/jps-help/puppet-netplan/pull/11)
- Improve documentation with additional examples - [#11](https://github.com/jps-help/puppet-netplan/pull/11)

### Changed
- Allow string values for `netplan::config` `priority` parameter - [#11](https://github.com/jps-help/puppet-netplan/pull/11)

## Release 1.0.0
### Added
- Add `purge_ignore` parameter for fine-grained control over purging un-managed configs

## Release 0.1.3
### Added
- Allow puppetlabs/stdlib 9.x.x
- Allow Puppet 8

## Release 0.1.2
### Changed
- `netplan::config` resources include the top-level `network` key automatically [BREAKING]
  - Users will need to remove the top-level `network` key from their existing netplan hash/hiera 
## Release 0.1.0

Initial release

**Features**

Install and configure netplan

**Bugfixes**

**Known Issues**
