#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

describe 'apt::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

#    it 'includes the apt recipe' do
#      expect(chef_run).to include_recipe('apt::default')
#    end

    it 'includes the apt recipe' do
      expect(chef_run).to include_recipe('build-essential::default')
    end
end    
    it 'installs the necessary packages' do
#	expect(chef_run).to install_package('build-essential')
	expect(chef_run).to install_package('tcl8.5')
    end

    it 'retrives the source code from remote location' do
	expect(chef_run).to create_remote_file('/tmp/redis-2.8.9.tar.gz')
    end

    it 'unzips the application' do
	#expect(chef_run).to ('/tmp/redis-2.8.9.tar.gz')
	resource = chef_run.remote_file('/tmp/redis-2.8.9.tar.gz')
	expect(resource).to notify('execute[unzip_redis_archive]').to(:run).immediately    
    end

    it 'builds and installs the application' do
	resource = chef_run.execute('tar xzf /tmp/redis-2.8.9.tar.gz')
        expect(resource).to notify('execute[make && make install]').to(:run).immediately
    end

    it 'installs the redis server' do
	resource = chef_run.execute('redis_build_and_install')
        expect(resource).to notify('execute[echo -n | ./install_server.sh]').to(:run).immediately
    end

    it 'starts the service' do
	expect(chef_run).to start_service('redis_6379')
    end
  end
end
