## AWS
(Google Cloud runs on AWS hardware)
### Services
(often just scaling open-source services)
1. [EC2 (Elastic Compute Cloud)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) (the other services built on top of this)
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

we'll use *Let's Encrypt* (free)

### Route53
to config DNS rules (point DNS to hosted zone)

### CloudWatch
monitors CPU, RAM, network, hard disk (so service informs you of problem, rather than customer)--plenty of metrics
* notifies dev by email

### OpsWorks
* automates machine config (fleet mgmt)
* uses "layers" to specify roles for each machine
* use Chef/Puppet to autho setup scripts (triggered by instance lifecycle events or API)

### IAM
allows teams of devs to use same AWS acct w/ separate permissions config'd by an admin

* can create non-human roles for API usage

### API, Tokens & CLI
AWS API req's auth via 2 tokens:
* `aws_access_key_id`
* `aws_secret_access_key`

manage via *(Account Name) > My Security Credentials*

* put credentials in `~/.aws` in `/credentials` & `config` (which stores default region)

#### [EC2 setup](https://github.com/appacademy/dev_ops/blob/master/projects/ci-cd.md)
(you can pin services to AWS nav)

RVM = Ruby Version Manager--it makes sure app is using most up-to-date version (Elixir uses Distillery; for Phase 3, only need to do PostgreQL part)
@ Phase 4

## [& More...](https://github.com/appacademy/dev_ops#w1d2---ci--cd-jenkins)

What is AWS?
> a global cloud platform (used by 80% of Fortune 500 co's)

> a hosting provider that gives you a bunch of services (per hour billing per instance)

> can auto-scale how many instances you have running based on metrics you set

Jenkins is an open-source CI library that, in short, will allow us to run our tests against the given codebase and then either deploy the code or log the failed test cases.

Continuous integration entails pushing every new commit to a continuously running build server.

**[Jenkins](https://jenkins.io/doc/) is a build server.**

Video on Jenkins (which is written in Java & is popular b/c of its plug-in support)
1. click *New Item*
2. select *Freestyle project*
3. under *Source Code Mgmt* tab, select *Git* & enter repo URL
  * under *Build* tab, select *Invoke top-level Maven targets*
    * in *Goals* input, write `compile`
4. click *Build Now*
  * shows console output

Jenkins executes testing in repo.

Create another new item (Code_Review). For build input, type `-P metrics pmd:pmd`. For *Post-build Actions*, select *Publish PMD analysis results*. Apply & save. Build Now.

Click *PMD Warnings*.

Create a third new item (Test). (Same repo for all.) In build input, write `test`. Build Now. (On success, can deploy to prod.)

On home page, click *+*. Select *Build Pipeline View* & name it. Select Compile as *Initial job*. Apply & save.

On home page, configure Code_Review. Under *Build Triggers* tab, enter Compile as *Project to watch*. (Adds this to pipeline.)

Go to build pipeline & click *Run*.

Shortcomings of a single Jenkins server:
* if you req. diff. env's for your build & test jobs
* if you have multiple projects w/ diff. OS's

Hence, Jenkins distributed architecture of a Jenkins master/load balancer & slaves, which provide the desired env.

To add Jenkins slaves:
1. Click *Manage Jenkins*
2. Scroll & click *Manage Nodes*
3. Click *New Node*. Click *Permanent Agent* & name slave server.
4. Launch method: *via SSH*. Enter *Remote root directory*. Enter IP address of *Host* (can add credentials).

Click the slave server (an agent) to see its logs.

---

Webhooks send messages to external systems about activity in your projects (can specify via GitHub).

Continuous integration (CI) is the automated process of integrating code from potentially multiple sources in order to build and test it.

Having automated tests alone is great, but their real value comes into play when they are connected with your source control platform to automatically run every time you push updated code. This connection and automation is what makes continuous integration possible.

 Not having to run them locally every time I make changes saves me time.

If unit tests require a database to perform their work, the CI environment must provide that database.

For API testing, the CI service needs to allow you to run a server that can receive and process the API calls. This may require the ability to install additional packages and services into the CI environment.

Functional testing can be the most awkward form of testing to perform in a CI environment, considering the wide range of software and platforms needed to perform the tests. My team has been running Selenium tests locally for some time now to do browser testing, but recently we took the time to learn how to use [Sauce Labs](https://saucelabs.com), a hosted Selenium testing service, to execute functional browser tests against our code during CI.

Now, whatever OS a developer is working on, their pushed code will be tested by several versions of Windows, Mac, and Linux in half a dozen browsers, all automatically and without tying up their computer while the tests run.

Planning for parallel execution of tests can help speed up the testing process significantly.

**[Docker video](https://www.youtube.com/watch?v=N3pPjYxLvkY&feature=youtu.be)**

Libraries and artifacts are typically not deployed to running systems but rather built and pushed into a repository for other applications to consume. If you’re writing a NodeJS library, you would “deliver” it to npmjs.org. (so you'll have cont. delivery OR deployment)
