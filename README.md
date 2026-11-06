# Secure Stats

Menu bar system monitor for Mac. This is a fork of [Stats](https://github.com/exelban/stats) by Serhiy Mytrovtsiy, under the same [MIT license](LICENSE). His copyright notice stays in the license.

## Install

Download the notarized `Secure Stats.dmg` from [Releases](https://github.com/AlecKinnear/securestats/releases) and open it. Secure Stats installs beside Stats. It does not replace it.

## Defaults

- The ICMP socket opens only while the Network module is running, and it closes when that module is disabled.
- The connectivity ping host is empty. Set a host in the Network settings if you want a ping.
- Public IP lookup is off.
- Update checks are set to Never. Turning them on downloads `Secure Stats.dmg` from this repository.

## Source

The code is [exelban/stats](https://github.com/exelban/stats). Copyright (c) 2019 Serhiy Mytrovtsiy.
