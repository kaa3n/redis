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

redis '2.8.9' do
  action :install
  source "http://download.redis.io/releases/redis-#{version_number}.tar.gz"
end

service "redis_6379" do
  action [ :start ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end
