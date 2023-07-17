# netplan
## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with netplan](#setup)
    * [What netplan affects](#what-netplan-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with netplan](#beginning-with-netplan)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module is used to install and manage netplan.

Since netplan configuration files are simple YAML documents, the module provides a simple 1-to-1 mapping from a Puppet hash to netplan YAML.

## Setup

### What netplan affects

- Netplan YAML files under `/etc/netplan/`

### Beginning with netplan
To get started with netplan, you simply need to include the main class
```
include netplan
```
## Usage
This module is best used by supplying data via Hiera. Generating netplan YAML files with resource statements, although possible, can result in very complex manifests.

The below example shows both methods, although it's strongly recommended to just use Hiera to form your netplan config.
### Basic usage
Make sure to include netplan somewhere in your manifest. By default, this will only ensure that netplan is installed.
```
include netplan

```
Provide Hiera data to build your inteneded netplan YAML file.
```
netplan::configs:
  example-config:
    settings:
      network:
        version: 2
        renderer: networkd
        ethernets:
          eth0:
            dhcp4: true
```
And here is the same config using a `netplan::config` resource instead
```
netplan::config { 'example-config': 
  settings => {
    network => {
      version => 2,
      renderer => networkd,
      ethernets => {
        eth0 => {
          dhcp4 => true,
        },
      },
    },
  },
}
```
### Purge un-managed configs
You can control whether to purge un-managed configs under `/etc/netplan/` using the main class.
#### Resource-like declaration
```
class {'netplan':
  purge_configs => true,
}

```
#### Hiera
```
netplan::purge_configs: true
```
### Control priority of netplan YAML files
Netplan reads all YAML files under `/etc/netplan/` and merges them to generate a single config. The order in which they are read determines the final config, if the same key appears in multiple files.

You can change the priority of a generated file as follows:
```
netplan::configs:
  example-config:
    priority: 10
    settings:
      network:
        version: 2
        renderer: networkd
  example-config-2:
    priority: 20
    settings:
      network:
        ethernets:
          eth0:
            dhcp4: true
```
The above will result in the following under `/etc/netplan/`
- 10-example-config.yaml
- 20-example-config-2.yaml

### Disable automatic netplan apply
By default, this module will run `netplan apply` once resources have been applied. This may not be desirable in some situations.
You can disable this with the following
```
class { 'netplan':
  apply => false,
}
```
Or do the same using Hiera
```
netplan::apply: false
``` 
Disabling `netplan::apply` will cause `netplan get` to be run instead. This acts as a form of validation check even though the config isn't applied immediately.

Please note that even when `netplan::apply` is disabled, to netplan YAML is still written to `/etc/netplan/`, so a reboot could cause network loss if the config is wrong.
## Limitations

This module doesn't perform any comprehensive validation for the generated netplan YAML. It can only ensure the generated file is in YAML syntax. 
***i.e.*** The ownus is on the sysadmin to ensure the generated config is valid for use with netplan.

## Development

Please submit your contributions and issues to GitHub: https://github.com/jps-help/puppet-netplan