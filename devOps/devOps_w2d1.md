## Chef Recipes

`setup.rb` & `deploy.rb` = 2 of main responsibilities of DevOps Engineer

DevOps has a lot of bug-hunting.

`deploy.rb` = like typing commands into terminal--except defined by a script file in Chef's DSL (want all commands to be idempotent--rolling back commands on failure)

```rb
execute " " do
  cwd node[:app][:path]
  command " "
  environment ({"NODE_ENV": "production", "HOME": "/home/ubuntu"})
  user "ubuntu"
end
```

Every cookbook can define its own attributes--ENV variables (such as default settings) that can be used throughout--defined as a JSON document/object (`node`).

Example Code:

`default['ngnix']['version'] = '1.12.1'`

```rb
include_recipe 'nginx::<RECIPE>'

package node['nginx']['package_name'] do
  options package_install_opts
  notifies :reload, 'ohai[reload_nginx]', :immediately
end
```

`service` = process that runs on machine for a long time

Chef is a DSL in Ruby.

* templates

Opsworks custom JSON overrides Chef JSON (under **Stack Settings**).

### `setup.rb`
* included recipes
* app dependencies
* init.d service
* Nginx config
* Unicorn config

Berkshelf is a public cookbook repo.

List dependencies in `metadata.rb`. Install w/ `berks vendor <path>`.

Recipes = scripts for Opsworks to run

Templates = store file template needed on machine (e.g. config)

Other cookbooks can define Libraries or Custom Resources

`setup.rb` allows recipes to be run in other cookbooks

#### init.d = service that monitors & runs background tasks/processes

```rb
template "NAME" do
  path "/etc/init.d/APP"
  source "NAME.erb"
  owner "root"
  group "root"
  mode "0755" #group & other can read & execute
end

service "APP" do
  supports restart: true, start: true, stop: true, reload: true
  action [ :enable ]
end

template "#{node['nginx']['dir']}/sites-available/APP" do
  source 'APP_site.erb'
  notifies :reload, 'service[nginx]', :delayed
end

directory "/tmp/sockets" do
  owner "root"
  group "root"
  mode "0777" #chmod (a Linux/bash command converted to binary & then a #) # user, group, other can read, write & execute (4 + 2 + 1 = 7)
  action :create
end
```

`sudo service` lists all running services

`sudo service <SERVICE> status`

### `deploy.rb`
* Git
* dependencies

Unicorn server performs like Elixir OTP.

### `metadata.rb`
like `package.json` in what it does

(Friday's code needs a 1-line change--specifying the version of `apt`; talk to Gene)

When your code was working & nothing's been changed, the issue is probably version-locking (i.e. a dependent package has been updated--w/o specifying the old version, a new, backwards-incompatible one can create "bugs").

I'll probably need to research deploying to AWS with Phoenix more on my own anyways... This survey just helps to orient me.
