#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Translated Instructions From:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis
#

include_recipe "apt::default"
include_recipe 'build-essential::default'


package "tcl8.5"

version_number = node['redis']['version']

remote_file "/tmp/redis-#{version_number}.tar.gz" do
  source "http://download.redis.io/releases/redis-#{version_number}.tar.gz"
  notifies :run, "execute[unzip_redis_archive]", :immediately
end

# unzip the archive
execute 'unzip_redis_archive' do
  command "tar xzf /tmp/redis-#{version_number}.tar.gz" 
  cwd "/tmp"
  action :nothing
  notifies :run, "execute[redis_build_and_install]", :immediately
end

# Configure the application: make and make install
execute "redis_build_and_install" do
  command "make && make install" 
  cwd "/tmp/redis-#{version_number}"
  action :nothing
  notifies :run, "execute[install_server_redis]", :immediately
end

# Install the Server
execute "install_server_redis" do
  command "echo -n | ./install_server.sh" 
  cwd "/tmp/redis-#{version_number}/utils"
  action :nothing
end

service "redis_6379" do
  action [ :start ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end
