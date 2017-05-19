
actions :install

property :source, String
property :version, String, name_property: true

action :install do
 
  source_url = source   

  remote_file "/tmp/redis-#{version}.tar.gz" do
    #source "http://download.redis.io/releases/redis-#{version}.tar.gz"
    source source_url
    notifies :run, "execute[unzip_redis_archive]", :immediately
  end

  execute 'unzip_redis_archive' do
    command "tar xzf /tmp/redis-#{version}.tar.gz"
    cwd "/tmp"
    action :nothing
    notifies :run, "execute[redis_build_and_install]", :immediately
  end

  execute "redis_build_and_install" do
    command "make && make install"
    cwd "/tmp/redis-#{version}"
    action :nothing
    notifies :run, "execute[install_server_redis]", :immediately
  end

  execute "install_server_redis" do
    command "echo -n | ./install_server.sh"
    cwd "/tmp/redis-#{version}/utils"
    action :nothing
  end
end

