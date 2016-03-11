#
# Cookbook Name:: filebeat
# Recipe:: config
#


directory node['filebeat']['prospectors_dir'] do
  recursive true
  action :create
end

file node['filebeat']['conf_file'] do
  content JSON.parse(node['filebeat']['config'].to_json).to_yaml.lines.to_a[1..-1].join
  notifies :restart, 'service[filebeat]' if node['filebeat']['notify_restart'] && !node['filebeat']['disable_service']
end

prospectors = node['filebeat']['prospectors']

prospectors.each do |prospector, configuration|
  file "prospector-#{prospector}" do
    path ::File.join(node['filebeat']['prospectors_dir'], "prospector-#{prospector}.yml")
    content JSON.parse(configuration.to_json).to_yaml.lines.to_a[1..-1].join
    notifies :restart, 'service[filebeat]' if node['filebeat']['notify_restart'] && !node['filebeat']['disable_service']
  end
end

powershell 'install filebeat as service' do
  code "#{node['filebeat']['windows']['base_dir']}/filebeat-#{node['filebeat']['version']}-windows/install-service-filebeat.ps1"
  only_if { node['platform'] == 'windows' }
end

ruby_block 'delay filebeat service start' do
  block do
  end
  notifies :start, 'service[filebeat]'
  not_if { node['filebeat']['disable_service'] }
end

service_action = node['filebeat']['disable_service'] ? [:disable, :stop] : [:enable, :nothing]

service 'filebeat' do
  supports :status => true, :restart => true
  action service_action
end
