include_recipe 'java'
#
group node['hadoop_install']['group'] do
  action :create
  not_if "getent group #{node['hadoop_install']['group']}"
end

user node['hadoop_install']['hdfs']['user'] do
  home "/home/#{node['hadoop_install']['hdfs']['user']}"
  system true
  shell "/bin/bash"
  manage_home true
  action :create
  not_if "getent passwd #{node['hadoop_install']['hdfs']['user']}"
end

user node['hadoop_install']['yarn']['user'] do
  home "/home/#{node['hadoop_install']['yarn']['user']}"
  system true
  shell "/bin/bash"
  manage_home true
  action :create
  not_if "getent passwd #{node['hadoop_install']['yarn']['user']}"
end

user node['hadoop_install']['mr']['user'] do
  home "/home/#{node['hadoop_install']['mr']['user']}"
  system true
  shell "/bin/bash"
  manage_home true
  action :create
  not_if "getent passwd #{node['hadoop_install']['mr']['user']}"
end

group node['hadoop_install']['group'] do
  action :modify
  members ["#{node['hadoop_install']['hdfs']['user']}", "#{node['hadoop_install']['yarn']['user']}", "#{node['hadoop_install']['mr']['user']}"]
  append true
end

directory node['hadoop_install']['dir'] do
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "0775"
  recursive true
  action :create
  not_if { File.directory?("#{node['hadoop_install']['dir']}") }
end

directory node['hadoop_install']['data_dir'] do
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "0775"
  recursive true
  action :create
end


 directory node['hadoop_install']['dn']['data_dir'] do
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "0774"
  recursive true
  action :create
end

directory node['hadoop_install']['nn']['name_dir'] do
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "0774"
  recursive true
  action :create
end
#
primary_url = node['hadoop_install']['download_url']['primary']
secondary_url = node['hadoop_install']['download_url']['secondary']
Chef::Log.info "Attempting to download hadoop binaries from #{primary_url} or, alternatively, #{secondary_url}"
#
base_package_filename = File.basename(primary_url)
cached_package_filename = "/tmp/#{base_package_filename}"
#
remote_file cached_package_filename do
  source primary_url
  retries 2
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "0755"
  ignore_failure true
  # TODO - checksum
  action :create_if_missing
end
#
base_package_filename = File.basename(secondary_url)
cached_package_filename = "/tmp/#{base_package_filename}"
#
remote_file cached_package_filename do
  source secondary_url
  retries 2
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "0755"
  # TODO - checksum
  action :create_if_missing
  not_if { ::File.exist?(cached_package_filename) }
end
#
hin = "#{node['hadoop_install']['home']}/.#{base_package_filename}_downloaded"
base_name = File.basename(base_package_filename, ".tar.gz")
# Extract and install hadoop
bash 'extract-hadoop' do
  user "root"
  code <<-EOH
        set -e
	tar -zxf #{cached_package_filename} -C #{node['hadoop_install']['dir']}
        ln -s #{node['hadoop_install']['home']} #{node['hadoop_install']['base_dir']}
        # chown -L : traverse symbolic links
        chown -RL #{node['hadoop_install']['hdfs']['user']}:#{node['hadoop_install']['group']} #{node['hadoop_install']['home']}
        chown -RL #{node['hadoop_install']['hdfs']['user']}:#{node['hadoop_install']['group']} #{node['hadoop_install']['base_dir']}
#        # remove the config files that we would otherwise overwrite
#        rm -f #{node['hadoop_install']['home']}/etc/hadoop/yarn-site.xml
#        rm -f #{node['hadoop_install']['home']}/etc/hadoop/core-site.xml
#        rm -f #{node['hadoop_install']['home']}/etc/hadoop/hdfs-site.xml
#        rm -f #{node['hadoop_install']['home']}/etc/hadoop/mapred-site.xml
#        rm -f #{node['hadoop_install']['home']}/etc/hadoop/log4j.properties
        touch #{hin}
        chown -RL #{node['hadoop_install']['hdfs']['user']}:#{node['hadoop_install']['group']} #{node['hadoop_install']['home']}
	EOH
  not_if { ::File.exist?("#{hin}") }
end
#

directory node['hadoop_install']['logs_dir'] do
   owner node['hadoop_install']['hdfs']['user']
   group node['hadoop_install']['group']
   mode "0775"
   action :create
   recursive true
end

directory node['hadoop_install']['tmp_dir'] do
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "1777"
  action :create
end

bash 'update_permissions_etc_dir' do
  user "root"
  code <<-EOH
    set -e
    chmod 775 #{node['hadoop_install']['conf_dir']}
  EOH
end
#
directory "#{node['hadoop_install']['home']}/journal" do
   owner node['hadoop_install']['hdfs']['user']
   group node['hadoop_install']['group']
   mode "0775"
   action :create
 end
#
#
#
magic_shell_environment 'PATH' do
  value "$PATH:#{node['hadoop_install']['base_dir']}/bin"
end

magic_shell_environment 'HADOOP_HOME' do
  value node['hadoop_install']['base_dir']
end

magic_shell_environment 'HADOOP_CONF_DIR' do
  value "#{node['hadoop_install']['base_dir']}/etc/hadoop"
end

magic_shell_environment 'HADOOP_PID_DIR' do
  value "#{node['hadoop_install']['base_dir']}/logs"
end


template "#{node['hadoop_install']['home']}/etc/hadoop/core-site.xml" do
  source "core-site.xml.erb"
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "755"
  variables({
	  :myNN => "hdfs://space-monster:9000"
  })
end

template "#{node['hadoop_install']['home']}/etc/hadoop/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "755"
end

template "#{node['hadoop_install']['home']}/etc/hadoop/mapred-site.xml" do
  source "mapred-site.xml.erb"
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "755"
end

template "#{node['hadoop_install']['home']}/etc/hadoop/yarn-site.xml" do
  source "yarn-site.xml.erb"
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "755"
end

template "#{node['hadoop_install']['home']}/etc/hadoop/hadoop-env.sh" do
  source "hadoop-env.sh.erb"
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "755"
end

template "#{node['hadoop_install']['home']}/etc/hadoop/slaves" do
  source "slaves.erb"
  owner node['hadoop_install']['hdfs']['user']
  group node['hadoop_install']['group']
  mode "755"
end

