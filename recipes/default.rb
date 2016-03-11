#
# Cookbook Name:: filebeat
# Recipe:: default
#

# install filebeat
if node['platform'] == 'windows'
  include_recipe 'filebeat::install_windows'
else
  include_recipe 'filebeat::install_package'
end

# configure filebeat
include_recipe 'filebeat::config'
