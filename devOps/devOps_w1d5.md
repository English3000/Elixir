## Puppet, Chef, & AWS OpsWorks (fleet mgmt)
* also Ansible & SaltStack

(devOps mini-course all about scaling our app)

* for repeatable process to create new servers ("orchestration")

### Deploying to a large fleet
Series
* if one server fails (when user's deployment runs a script), its state is corrupted--need an atomic operation (Puppet is better than Chef on this)

Parallel (if one server fails, roll back for all servers--the site is down)
* failures via: bugs, network issues, version locking issues, resource inconsistencies
* reduce risk by: min. network distance, automating, idempotency (clients can make that same call repeatedly while producing the same result) w/ rollback

### Deployment strategies
Cutover (what we'll be doing)
* middle server to enforce consistency across servers

(direct cutover = deployment -> servers)

Pilot
* middle server tests deployment on 1 server; if works, deploy to all

Parallel *(for zero downtime; common in industry)*
* middle server tests deployment to half of servers, let users try them

### Other concerns
* db migrations (write another script to migrate db on deploy)
* load balancing
* A/B testing
* push vs pull
* multiple server roles w/ multiple env's

### Puppet (written in Ruby; has DSL)
* scripts to define "final state" of a server
* each "step" in script is modeled as a "resource"
  * each resource can be dep. on other resources
  * each resource type can modify server's state (deploy/rollback)
* Puppet makes a graph of changes to apply based on dep's
* Puppet server comm's bi-dir. w/ Puppet agents on the machines
* has solo mode

Chef is simpler & quicker to setup

### Chef (terms = cooking analogy; written in Ruby; has DSL)
* "recipes" define "repeatable steps" to get server to desired state
  * recipes combined into pluggable cookbooks
* each "step" in script is modeled as a "resource"
  * each resource should be parameterized & idempotent
* rollback = redeploy w/ prev. params
* Chef server comm's bi-dir. w/ Chef agents on the machines
* has solo mode

### Ansible (written in Python)
* doesn't use middle server; connects to all servers from your machine; pushes modules, which are small programs; then disconnects
* parallel

even simpler but doesn't handle corrupted state--good 1st dip...

### SaltStack
not popular yet, but gaining ground
* similar to Puppet & Chef

### OpsWorks
* AWS service
* client/server model; custom server & custom client agents
* uses Puppet (enterprise) or Chef ("more than enough" until late-stage startup) scripts
* defines EC2 instance lifecycle (when machine does X, run X script)

Units
* Stacks (of layers)
  * groups machines based on shared resources
* Layers (of instances)
  * groups machines based on roles
  * custom recipes per lifecycle event _(Gene hasn't used undeploy or shutdown scripts)_
* Apps (a string used in deployment--just another variable passed to the custom JSON; that's basically all this does)
  * deployable identifier--scripts can use app name

> Done w/ whole project (didn't have to do Phase 3 today)
