#
# Cookbook Name:: filebeat
# Recipe:: package
#


case node['platform_family']
when 'debian'
  # apt repository configuration
  apt_repository 'beats' do
    uri node['filebeat']['apt']['uri']
    components node['filebeat']['apt']['components']
    key node['filebeat']['apt']['key']
    action node['filebeat']['apt']['action']
  end
when 'rhel'
  # yum repository configuration
  yum_repository 'beats' do
    description node['filebeat']['yum']['description']
    baseurl node['filebeat']['yum']['baseurl']
    gpgcheck node['filebeat']['yum']['gpgcheck']
    gpgkey node['filebeat']['yum']['gpgkey']
    enabled node['filebeat']['yum']['enabled']
    metadata_expire node['filebeat']['yum']['metadata_expire']
    action node['filebeat']['yum']['action']
  end
end

package 'filebeat' do
  version node['platform_family'] == 'rhel' ? node['filebeat']['version'] + '-1' : node['filebeat']['version']
end
