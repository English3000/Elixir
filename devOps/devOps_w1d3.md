## CI & CD w/ Jenkins
(typ takes 5 yrs for new tech to be adopted)

(Docker as an alternative to Jenkins--can run 16 containers on a machine/server)

other CI's (Travis, Codeship, Solano Labs, CircleCI)... cost money; all inspired by Jenkins (which can do the most, & is extensible)

w/ AWS: [CodePipeline](https://aws.amazon.com/codepipeline/)

source control mgmt -> continuous integration{run tests, build artifacts, publish artifacts (to S3), trigger deploy (w/ OpsWorks)} -> deployment system

every time you find a bug, you write a test (to ensure it's gone) = **regression testing** (this is typ. all of a co's testing)

### CI
artifacts = prod js files, rails assets

config'd by config file in source code repo

can do multiple branches

working on a team means more "overhead" involved in changing code

### Jenkins
* Jenkins = build workflow mgr w/ web UI *(in Elixir terms, it's another pipeline of plugs)*
  * workflow stages: source control, build steps, post-build steps (if this fails, build could still be successful)
* plugins (to hook into workflow)
* projects can trigger each other

lack of **version locking** = really bad problem (common cause of bugs)

RVM lets build server switch btwn versions for diff. code

(use NVM for NodeJS)

migrations are serial, so they don't merge well (need to drop & re-seed)

(may need to rename full stack project's test db to `full-stack-project_test`; in `config/database.yml`)

$VARIABLE

#### Plugins
we need:
* defaults
* RVM (or asdf for Elixir)
* NVM Wrapper

#### Source Control
Jenkins's GitHub plugin uses github webhooks

#### Build Steps
we'll use bash script (execute shell)

#### Post-Build Steps
* source control triggering
* publish test results
* notify dev's

### [Reading](https://technologyconversations.com/2014/04/29/continuous-delivery-introduction-to-concepts-and-tools/)
Some of the commonly used CI tools are Jenkins, Hudson, Travis and Bamboo. Basic principle behind all of them is the detection of changes in the code repository and triggering a set of jobs or tasks.

However, the “real” continuous delivery/deployment pipeline is much more complex than what Travis & Circle CI are capable of...?
