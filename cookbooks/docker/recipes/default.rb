#
# Cookbook:: docker
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
apt_repository 'docker' do
   uri 'https://download.docker.com/linux/ubuntu'
   key 'https://download.docker.com/linux/ubuntu/gpg'
   distribution "#{node['lsb']['codename']}"
   components ['stable']
   arch 'amd64'
   cache_rebuild true
end


package 'docker-ce'

