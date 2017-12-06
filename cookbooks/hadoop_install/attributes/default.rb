##
## Cookbook Name:: hadoop_wrapper
## Attribute:: default
##
## Copyright © 2013-2016 Cask Data, Inc.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##    http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
#
## variables
#jmx_base = '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false'
#
# Java
default['java']['jdk_version'] = 8
## Java
##default['java']['install_flavor'] = 'oracle'
##default['java']['jdk_version'] = 7
##default['java']['oracle']['accept_oracle_download_terms'] = true
##default['java']['oracle']['jce']['enabled'] = true
#
## Hadoop
default['hadoop_install']['version']                 = "2.9.0"
default['hadoop_install']['hdfs']['user']             = "hdfs"
default['hadoop_install']['yarn']['user']             = "yarn"
default['hadoop_install']['mr']['user']             = "mr"
default['hadoop_install']['group']                    = "hadoop"
default['hadoop_install']['dir']                      = "/opt"

#default[['hadoop_install'].]['data_dir']                 = "/var/data/hadoop"
#default.apache_hadoop.base_dir                 = "#{node.apache_hadoop.dir}/hadoop"

default['hadoop_install']['base_dir'] = "#{node['hadoop_install']['dir']}/hadoop"
#default.apache_hadoop.home                     = "#{node.apache_hadoop.dir}/hadoop-#{node.apache_hadoop.version}"
default['hadoop_install']['home'] = "#{node['hadoop_install']['dir']}/hadoop-#{node['hadoop_install']['version']}"
default['hadoop_install']['var_dir'] = "/home/#{node['hadoop_install']['hdfs']['user']}/var"
default['hadoop_install']['data_dir'] = "#{node['hadoop_install']['var_dir']}/data"
default['hadoop_install']['logs_dir'] = "#{node['hadoop_install']['var_dir']}/logs"
default['hadoop_install']['tmp_dir']  = "#{node['hadoop_install']['var_dir']}/tmp"

default['hadoop_install']['conf_dir'] = "#{node['hadoop_install']['base_dir']}/etc/hadoop"
default['hadoop_install']['sbin_dir'] = "#{node['hadoop_install']['base_dir']}/sbin"
default['hadoop_install']['bin_dir']  = "#{node['hadoop_install']['base_dir']}/bin"

default['hadoop_install']['dn']['data_dir']     = "#{node['hadoop_install']['data_dir']}/hdfs/dn"
default['hadoop_install']['nn']['name_dir']     = "#{node['hadoop_install']['data_dir']}/hdfs/nn"
default['hadoop_install']['nm']['log_dir']      = "#{node['hadoop_install']['logs_dir']}/userlogs"

default['hadoop_install']['download_url']['primary']   = "https://archive.apache.org/dist/hadoop/core/hadoop-#{node['hadoop_install']['version']}/hadoop-#{node['hadoop_install']['version']}.tar.gz"
default['hadoop_install']['download_url']['secondary']   = "https://archive.apache.org/dist/hadoop/core/hadoop-#{node['hadoop_install']['version']}/hadoop-#{node['hadoop_install']['version']}.tar.gz"
#
## core-site.xml
#default['hadoop']['core_site']['hadoop.tmp.dir'] = '/hadoop'
## hdfs-site.xml
#default['hadoop']['hdfs_site']['dfs.datanode.max.transfer.threads'] = '4096'
## mapred-site.xml
#default['hadoop']['mapred_site']['mapreduce.framework.name'] = 'yarn'
## yarn-site.xml
#default['hadoop']['yarn_site']['yarn.log-aggregation-enable'] = 'true'
#default['hadoop']['yarn_site']['yarn.scheduler.minimum-allocation-mb'] = '512'
#default['hadoop']['yarn_site']['yarn.nodemanager.resourcemanager.connect.wait.secs'] = '-1'
#default['hadoop']['yarn_site']['yarn.nodemanager.vmem-check-enabled'] = 'false'
#default['hadoop']['yarn_site']['yarn.nodemanager.vmem-pmem-ratio'] = '5.1'
#default['hadoop']['yarn_site']['yarn.nodemanager.delete.debug-delay-sec'] = '86400'
#
## Memory for YARN
#unless node['hadoop']['yarn_site'].key?('yarn.nodemanager.resource.memory-mb')
#  mem = (node['memory']['total'].to_i / 1000)
#  pct = if node['hadoop'].key?('yarn') && node['hadoop']['yarn'].key?('memory_percent')
#          (node['hadoop']['yarn']['memory_percent'].to_f / 100)
#        else
#          0.50
#        end
#  default['hadoop']['yarn_site']['yarn.nodemanager.resource.memory-mb'] = (mem * pct).to_i
#end
#
## hadoop-metrics.properties
#default['hadoop']['hadoop_metrics']['dfs.class'] = 'org.apache.hadoop.metrics.spi.NullContextWithUpdateThread'
#default['hadoop']['hadoop_metrics']['dfs.period'] = '60'
#default['hadoop']['hadoop_metrics']['mapred.class'] = 'org.apache.hadoop.metrics.spi.NullContextWithUpdateThread'
#default['hadoop']['hadoop_metrics']['mapred.period'] = '60'
#default['hadoop']['hadoop_metrics']['rpc.class'] = 'org.apache.hadoop.metrics.spi.NullContextWithUpdateThread'
#default['hadoop']['hadoop_metrics']['rpc.period'] = '60'
#default['hadoop']['hadoop_metrics']['ugi.class'] = 'org.apache.hadoop.metrics.spi.NullContextWithUpdateThread'
#default['hadoop']['hadoop_metrics']['ugi.period'] = '60'
## hadoop-env.sh
## Enable JMX
#default['hadoop']['hadoop_env']['hadoop_jmx_base'] = jmx_base
#default['hadoop']['hadoop_env']['hadoop_namenode_opts'] = '$HADOOP_JMX_BASE -Dcom.sun.management.jmxremote.port=8004'
#default['hadoop']['hadoop_env']['hadoop_secondarynamenode_opts'] = '$HADOOP_JMX_BASE -Dcom.sun.management.jmxremote.port=8005'
#default['hadoop']['hadoop_env']['hadoop_datanode_opts'] = '$HADOOP_JMX_BASE -Dcom.sun.management.jmxremote.port=8006'
## yarn-env.sh
#default['hadoop']['yarn_env']['yarn_opts'] = jmx_base
#default['hadoop']['yarn_env']['yarn_resourcemanager_opts'] = '$YARN_RESOURCEMANAGER_OPTS -Dcom.sun.management.jmxremote.port=8008'
#default['hadoop']['yarn_env']['yarn_nodemanager_opts'] = '$YARN_NODEMANAGER_OPTS -Dcom.sun.management.jmxremote.port=8009'
#
## HBase
## hbase-site.xml configs
#default['hbase']['hbase_site']['hbase.cluster.distributed'] = 'true'
#default['hbase']['hbase_site']['hbase.defaults.for.version.skip'] = 'false'
#default['hbase']['hbase_site']['hbase.regionserver.handler.count'] = '100'
#
## hbase-env.sh
## Enable JMX
#default['hbase']['hbase_env']['hbase_log_dir'] = '/var/log/hbase'
#default['hbase']['hbase_env']['common_gc_opts'] = '-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=1 -XX:GCLogFileSize=512M'
#default['hbase']['hbase_env']['hbase_jmx_base'] = jmx_base
#default['hbase']['hbase_env']['hbase_master_opts'] = '$COMMON_GC_OPTS $HBASE_MASTER_OPTS $HBASE_MASTER_HEAP $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10101'
#default['hbase']['hbase_env']['server_gc_opts'] = '-Xloggc:$HBASE_LOG_DIR/gc-master.log'
#default['hbase']['hbase_env']['hbase_regionserver_opts'] = '$COMMON_GC_OPTS -Xloggc:$HBASE_LOG_DIR/gc-regionserver.log $HBASE_REGIONSERVER_OPTS $HBASE_REGIONSERVER_HEAP $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10102'
#
## ZooKeeper
## zoo.cfg
#default['zookeeper']['zoocfg']['autopurge.snapRetainCount'] = '7'
#default['zookeeper']['zoocfg']['autopurge.purgeInterval'] = '24'
