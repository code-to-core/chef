
   ark "maven" do
     url "http://apache.mirrors.spacedump.net/maven/maven-3/#{node[:maven][:version]}/binaries/apache-maven-#{node[:maven][:version]}-bin.tar.gz"
     version "#{node[:maven][:version]}"
     path "/usr/local/maven/"
     home_dir "/usr/local/jvm/default"
#     checksum  "#{node[:maven][:checksum]}"
     append_env_path true
     owner "#{node[:hdfs][:user]}"
    end
