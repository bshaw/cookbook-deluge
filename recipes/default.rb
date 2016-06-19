#
# Cookbook Name:: deluge
# Recipe:: default
#

# create directories
%w(
  node['deluge']['config_volume']
  node['deluge']['downloads_volume']
).each do |d|
  directory d do
    recursive true
    action :create
  end
end

# get the image from dockerhub
docker_image node['deluge']['docker_image']

# run the container
docker_container 'deluge' do
  repo node['deluge']['docker_image']
  tag 'latest'
  network_mode 'host'
  restart_policy 'always'
  host_name node['deluge']['host_name']
  domain_name node['deluge']['domain_name']
  volumes ['/etc/localtime:/etc/localtime:ro', "#{node['deluge']['config_volume']}:/config", "#{node['deluge']['downloads_volume']}:/downloads"]
end

# reqires my_firewall, which is part of the base role
firewall_rule 'deluge' do
  port node['deluge']['host_port']
  command :allow
end
