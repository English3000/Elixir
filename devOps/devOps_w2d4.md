## Monitoring: system, app, custom data

### System
* db: CPU utilization (unless dealing w/ Big Data, won't be an issue)
* web servers: response time & request queueing
* job runners: CPU, RAM
* caches & queues: RAM

benchmarking (how many connections your app can handle) w/ Apache Benchmark (`ab` on CLI)

CPU cycle = fetch (a request), decode, execute, store

### App
* track model queries
*   "   timing at diff. layers (MVC)
*   "   users

SAAS Services: **New Relic**, Datadog, Rollbar

### Custom Data
* business metrics
  * click-thru rate
  * total sales
* dev.
  * server processing rate
  * internal queue lengths
  * ...timing

APM services & system monitors offer custom metric tracking _(incl. Cloudwatch)_--to debug at scale...

* open source: StatsD (by Etsy)

Cloudwatch is weak for APM (more for system monitoring)

For notifications: **Pagerduty** ($5/month), Twilio, Google Voice

> SSH to the machine by running the following command in your terminal:
> `ssh -i ~/.ssh/<key>.pem ubuntu@<ip_address from clipboard>`
