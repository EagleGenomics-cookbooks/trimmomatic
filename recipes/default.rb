#
# Cookbook:: trimmomatic
# Recipe:: default
#
# Copyright:: 2019, Eagle Genomics Ltd, All Rights Reserved.
##########################################################

include_recipe 'apt' if node['platform_family'] == 'debian'
include_recipe 'java'

##########################################################

package ['unzip'] do
  action :install
end

##########################################################

trimmomatic_install_dir = node['trimmomatic']['install_dir']
trimmomatic_base = 'Trimmomatic-' + node['trimmomatic']['version']
trimmomatic_download_file = trimmomatic_base + '.zip'
trimmomatic_jar_file = 'trimmomatic-' + node['trimmomatic']['version'] + '.jar'
trimmomatic_download_url = 'http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/' + trimmomatic_download_file
temp_file_location = File.join(Chef::Config[:file_cache_path], trimmomatic_download_file)

remote_file temp_file_location do
  source trimmomatic_download_url
  action :create_if_missing
end

execute "unzip #{temp_file_location} -d #{trimmomatic_install_dir}" do
  not_if { ::File.exist?(File.join(trimmomatic_install_dir, trimmomatic_base, 'LICENSE')) }
end

magic_shell_environment 'TRIMMOMATIC_JAR_PATH' do
  value File.join(trimmomatic_install_dir, trimmomatic_base, trimmomatic_jar_file)
end

magic_shell_environment 'TRIMMOMATIC_VERSION' do
  value node['trimmomatic']['version']
end
