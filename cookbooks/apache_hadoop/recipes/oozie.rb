primary_url = node.oozie.download_url.primary
secondary_url = node.oozie.download_url.secondary

base_package_filename = File.basename(primary_url)
cached_package_filename = "#{Chef::Config.file_cache_path}/#{base_package_filename}"

remote_file cached_package_filename do
  source primary_url
  retries 2
  owner node.oozie.user
  group node.apache_hadoop.group
  mode "0755"
  ignore_failure true
  # TODO - checksum
  action :create_if_missing
end

remote_file cached_package_filename do
  source secondary_url
  retries 2
  owner node.oozie.user
  group node.apache_hadoop.group
  mode "0755"
  # TODO - checksum
  action :create_if_missing
  not_if { ::File.exist?(cached_package_filename) }
end

hin = "#{node.oozie.home}/.#{base_package_filename}_downloaded"
base_name = File.basename(base_package_filename, ".tar.gz")
# Extract and install hadoop
bash 'extract-oozie' do
  user "root"
  code <<-EOH
	tar -zxf #{cached_package_filename} -C #{node.apache_hadoop.dir}
        ln -s #{node.apache_hadoop.dir}/#{node.oozie.version} #{node.oozie.base_dir}
        # chown -L : traverse symbolic links
        chown -RL #{node.oozie.user}:#{node.apache_hadoop.group} #{node.oozie.home}
        chown -RL #{node.oozie.user}:#{node.apache_hadoop.group} #{node.oozie.base_dir}
        # remove the config files that we would otherwise overwrite
        rm -f #{node.oozie.home}/etc/hadoop/mapred-site.xml
        touch #{hin}
        chown -RL #{node.oozie.user}:#{node.apache_hadoop.group} #{node.oozie.home}
	EOH
  not_if { ::File.exist?("#{hin}") }
end
