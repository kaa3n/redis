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

# ark 'redis' do
#   source "http://download.redis.io/releases/redis-#{version}.tar.gz"
# end

redis node['redis']['version'] do
  action :install
  source "http://download.redis.io/releases/redis-#{version}.tar.gz"
end


service "redis_6379" do
  action [ :start ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end
