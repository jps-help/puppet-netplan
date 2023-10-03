# Changelog

All notable changes to this project will be documented in this file.

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
