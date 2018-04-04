## AWS
(Google Cloud runs on AWS hardware)
### Services
(often just scaling open-source services)
1. EC2 (the other services built on top of this)
  * instances
  * key pairs
  * volumes (EBS)
  * load balancers
  * security groups
  * VPCs
2. RDS
3. S3
4. CloudFront
5. Certificate Mgr
6. Route 53
7. OpsWorks

AWS allows you to use computer hardware (need if livestreaming; or VM), pay hourly rate

S3 = storage, pay per data transfer & storage used

#### Regions
Oregon (`us-west-2`) = cheapest near SF

none for S3

Developer Tools = CI/CD

### EC2
#### Instances
to look at the state of the machines you're using

compute (CPU) optimized

get 750 virtual CPU hours free per year

VPC (virtual private computing): all your machines networked to each other

* t2.small (just use defaults)
  * enable CloudWatch in Step 2

#### Key Pairs
EC2 uses SSH keys to access your instances

private keys in `~/.ssh`

`$ ssh -i ~/.ssh/key.pem ubuntu@< public ip >`

#### Volumes (EBS)
By default, instance data doesn't persist on termination (so **don't stop machines**).

EBS (elastic block storage) adds persistent storage--can be attached only to 1 instance at a time.

* auto-mounted in ubuntu under `/mount/`

(we won't be using this)

#### Load Balancers (ELBs)
allows you to add instances to the pool of machines

* configure request routing w/ inbound port/protocol & output port/protocol (under *Listeners*)
* automatic health checks
* many other services auto-add themselves

#### Security Groups (of rules)
applied to all instances & ELBs; similar to a firewall--restrict all traffic to machine according to configured rules
> creates bug where your machines can't access each other

set rules under *Inbound*

#### VPCs
analogous to an office network, w/ an internal IP (we're using the defaults)

### RDS
to setup a db on your EC2 instance

**db maintenance**
* run backups/snapshots (which copies instructions to re-create db into a text file)
* create read replicas (more read-only, follower db's)
* manage instances

DynamoDB is a key-value store

ElastiCache is a a document store

### S3 (file storage)
= a distributed file storage system
* upload files, incl. via AWS API (private or public)

### CloudFront (CDN)
* serve content from S3 (we'll be using default settings) or app server
* configure to custom domain
* configure cache expiry
> may need to delete cache when deploying new version of app

### Certificate Manager
stores SSL certificates for other AWS services (for enabling HTTPS)

#### [EC2 setup](https://github.com/appacademy/dev_ops/blob/master/projects/ci-cd.md)
@ Phase 4

Jenkins is an open-source CI library that, in short, will allow us to run our tests against the given codebase and then either deploy the code or log the failed test cases.

RVM = Ruby Version Manager--it makes sure app is using most up-to-date version
