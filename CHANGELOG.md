# Changelog

All notable changes to this project will be documented in this file.

## Unreleased
### Changed
- `netplan::config` resources include the top-level `network` key automatically [BREAKING]
  - Users will need to remove the top-level `network` key from their existing netplan hash/hiera 
## Release 0.1.0

Initial release

**Features**

Install and configure netplan

**Bugfixes**

**Known Issues**
