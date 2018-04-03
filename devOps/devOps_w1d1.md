## DevOps [w1d1](https://docs.google.com/presentation/d/1b__Wi-IZedLvkngQKcrzzoaQBeWyzdyOBVMbBDzs69o/edit#slide=id.g35f7652615_0_55): Overview (learn the vocab)

**by Gene Hallman**

Learning hardware scalability.

Inteviewers keep asking ?s to see the line btwn what you know & what you don't. (If interviewer runs out of ?s, you win.)

We'll be discussing how to make a db faster.

**Hierarchy of Tech Knowledge:** fn -> app -> microservices (2 apps that need to talk to each other)

> tools & systems for deploying, scaling, & maintaining prod. apps (more niche)

Moving our projects from Heroku & Postgres to AWS.

* Jenkins _(continuous integration/deployment)_

* AWS RDS _(to setup our own db)_

* Puppet, Chef, & AWS Opswork _(for "fleet mgmt", as scale)_ _ask about Docker_

* DNS w/ SSL

* AWS Cloudfront (CDN) _short; only 30 min of content_

* Cloudwatch _(monitoring)_

A computer has 65,000 ports.


### Processes

The OS is responsible for:

A cycle fetches command from memory, reads it, executes it, & stores it in memory (fetch-decode-execute-store cycle = all that the CPU does)

* switching btwn multiple processes so they run "simultaneously" _(context switching--sharing time on CPU)_

* restricting processes based on user permissions

* allowing processes to share resources:
  * RAM w/ "colliding" (where variables are declared)
  * hard drive access
  * network usage (ports)
  * other devices

#### A single process
* each process has its own id (PID)
* a program written in C has to make system calls _(e.g. malloc--memory allocation)_ to the OS to interact w/ computer's resources
  * system calls are fn's that the OS is req'd to provide in C (glibc = interface, impl'd slightly diff'ly by each vendor)

#### as a tree
parent process can start up a new child processes

Kernel = 1st process (which starts up all others)

`$ sudo ps aux` (already installed)

```bash
$ brew install pstree
$ pstree
```

#### Interaction
* **system calls** to resources
* **ENV variables** _(**static** over the process's lifetime; "key-value" pairs)_
* `stdin` _(pipes into process--chainable)_, `stdout` & `stderr` _(pipe out from process)_ to accept text input from keyboard & write text output to screen
* **signals** are ways for outside processes to trigger your process _(similar to an event listener; e.g. _`ctrl + C`_ sends a sigint [signal interruption])_

Thanks to Internet:
* process can ask OS for access to networking interface via a socket, which will assign a port # to your process

Ports 0 - 1024 = pre-allocated

syssocket.h (C library)

### Networking
> OSI stack (7 layers; presentation & session not used anymore); (1) bottom = physical layer (det'n binary comm. via electricity)

> The network layer gives you IP's.

* each process can open 1+ ports (gives your software a unique ID at network-lv)
* ports determine which process will receive an inbound packet
* ports are TCP _(stateful -- know whether msg made it)_ or UDP _(stateless, less reliable & less overhead; useful for streaming live video)_
* each network device has an MAC address _(hardcoded by vendor)_
* any connected device has an IP address

process -> OS |> port -> network -> IP router -> DNS -> URL response

Combining IP & Port allows 2 processes to comm w/ each other

**Network service** = any process that comm's w/ a network

IP addresses btwn 0.0.0.0 - 255.255.255.255 (32 bits total in IPv4; more in IPv6 [hexidecimal], hasn't caught on)

192.68.x.x = reserved for private devices

Internet Service Provider

> Network Address Traversal (& hole-punching)

network connects to wireless router, which gives network an IP address _(hierarchy of routers [which handle a range of IP addresses]; ordered by proximal physical location)_

#### DNS
**maps a human readable domain to an IP address**
* global dir
* hierarchical (ask for it, get it similarly to IP router)
* can have subdomains (as children)
* root of this tree = 13 root-servers
* an IP address can have many domains; a domain has (belongs to?) one IP address
* 1 IP response per DNS request

#### URLs
< protocol >://< subdomain(s) >.< domain >/< path >

HTTP assumes port # is 80, HTTPS = port 443

< protocol >://< user >:< password >@< subdomain(s) >.< domain >:< port >/< path >

protocol = the format of network comm

### Scaling a web app
**Goal: serve more traffic by adding more hardware**

Linear = best-case scenario (2x machines => 2x traffic)

db's are hardest to scale
  * break stack into indiv. process groups
  * dedicate machine to only 1 process group
  * [analyze & track resources of each process, min'z amt of resources on machine](https://aws.amazon.com/ec2/pricing/on-demand/) (decreases cost)
  * scale horizontally by adding more machines

Scaling req's load-balancing.

Statelessness btwn req's makes it easier to scale.

More CPU cycles => more resource time to allocate => faster

### A standard production stack
* load balancers
* web servers
* app servers
* db's
* queues
* job runners
* caches & CDNs

browser - Internet - [load balancer, CDN] - web server - [web service interface(web app), second instance, app 2 < e.g. Gmail & Google Maps >] - [queue, db]

#### App servers
= the backend code
* runs inside web service interface (e.g. RACK/unicorn, WSGI, CGI)
* multi-threaded/-process
* siloed w/ shared db

Least often the bottleneck, but may be CPU/Memory bound

#### Web server interface

#### Web servers
**Apache, Nginx _(for system-lv routing)_**

* provides customizable gateway for performing HTTP-lv actions
* redirects
* authentication/authorization
* SSL endpoint
* performance opt'zn (timeout)
* bound by request queueing/threading/child processes
* may optionally mg the app

#### Database
on its own server b/c could be shared by multiple OS's

* typ. Master/Slave
* Master = read/write
* Slave = read-only (& as redundancy) _-- scale diff'ly if write-heavy_
* Master uses **transaction log shipping** to update Slave
* optimized via:
  * read/write separation
  * query opt'zn
  * microservices
  * async

CPU-bound, usually the bottleneck

#### Load balancer
= fast
* provides an IP that fw's TCP/HTTP packets to other web servers (hosts)
* SSL
* sets custom headers on HTTP (X-forwarded-for)
* common options:
  * hardware (fastest & most expensive)
  * HAProxy
  * Nginx
  * DNS/GeoDNS

#### Second app

#### CDN
client keeps copy of static content locally (caching) -- helps webpage load fast, located globally (using GeoDNS)
* cache control headers

* specifically HTTP cache
* invalidation is tricky

e.g. Akamai, CloudFront, ChinaCache (China has separate providers)

**Technologies:** Squid & Varnish

### What we won't use

#### Job runner
= a dedicated server that runs 1 slow/time-intensive process (would timeout on web request)

typ. uses queue

* comm's async'ly to other processes
* scheduled tasks: Cron, Celery (Django), Resque/Delayed Job

#### Queues
fast, configurable, sometimes subscription interfaces

* used for inter-process comm (IPC)
* feature-rich (e.g. persistence)
* e.g.
  * Redis
  * Kafka
  * MSMQ
  * RabbitMQ

#### Caches
* app cache (not HTTP)
* very fast storage, typ. in-memory (stores results of freq queries)
* invalidation can be a problem
* Memcached
  * older, larger community
  * simple datatypes
  * HTTP cache integration
* Redis
  * more modern, less robust
  * complex datatypes
  * often hand-rolled solutions

### Summary
1. Processes often comm via the network (via a URL)
  * A production web environment often combines many network services together
2. Dedicated hardware per service allows us to customize the machine resources for each set of service requirements, reducing wasted machine resources
3. Load balancers allow traffic to a single endpoint to be shared across multiple machines
4. Due to the nature of data, db's are the most difficult to scale
5. Caching handles redundant processing of static assets, saving time-to-load & money
