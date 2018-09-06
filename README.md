# Infra-Memcached
New Relic Infrastructure extension to report useful memcached stats. This integration uses `memcached-tool stats` to collect performance counters.

## Disclaimer
New Relic has open-sourced this integration to enable monitoring of this technology. This integration is provided AS-IS WITHOUT WARRANTY OR SUPPORT, although you can report issues and contribute to this integration via GitHub. Support for this integration is available with an [Expert Services subscription](newrelic.com/expertservices).

## Pre-reqs
* Infrastructure agent installed
* A server w/ Memcached installed
* Memcached-tool installed --> https://github.com/memcached/memcached/blob/master/scripts/memcached-tool

## Installation
1. Copy repo/zip to machine running Infrastructure
2. Run `install.sh`

## Configuration
* Default host/port is localhost/11211 - These can be changed in `memcached-config.yml` if needed.
* If more stats are needed, just add another stat to `template.json` and to the array within `memcached.sh`

## Event Data
Events will be displayed under **MemcachedSample** within Insights. A sample dashboard is also included (`dashboard.json`) that can be uploaded via the [Insights Dashboard API](https://docs.newrelic.com/docs/insights/insights-api/manage-dashboards/insights-dashboard-api)
