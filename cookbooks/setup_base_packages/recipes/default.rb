#
# Cookbook:: setup_base_packages
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

apt_repository 'google-chrome' do
   uri 'http://dl.google.com/linux/chrome/deb/'
   key 'https://dl-ssl.google.com/linux/linux_signing_key.pub'
   distribution 'stable'
   components ['main']
   arch 'amd64'
   cache_rebuild true
end

package 'google-chrome-stable'
package 'default-jre'
