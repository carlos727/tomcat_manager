# Cookbook Name:: tomcat_manager
# Recipe:: default
# Create user to connect with tomcat manager
# Copyright (c) 2016 The Authors, All Rights Reserved.

#
# Variables
#
tomcat_folder = TomcatService.get_folder
manager_available = false
username = node["tomcat_manager"]["user"]
password = node["tomcat_manager"]["pwd"]


#
# Edit configuration files of Tomcat
#
template "#{tomcat_folder}\\conf\\tomcat-users.xml" do
  source 'tomcat-users.erb'
  action :nothing
  not_if { manager_available }
end

template "#{tomcat_folder}\\webapps\\manager\\WEB-INF\\web.xml" do
  source 'web.erb'
  action :nothing
  not_if { manager_available }
end

template "#{tomcat_folder}\\conf\\server.xml" do
  source 'server.erb'
  action :nothing
  not_if { manager_available }
end

#
# Restart Tomcat
#
windows_service 'Tomcat7' do
  action :restart
  timeout 180
  action :nothing
  not_if { manager_available }
end

#
# Verify login to Tomcat Manager
#
ruby_block 'Test Tomcat Manager Configuration' do
  block do
    manager_available = TomcatManager.is_reachable?('http://localhost:8080/manager/text/list', username, password)
    if manager_available
      Chef::Log.info 'Tomcat Manager is configured'
    else
      Chef::Log.info 'Tomcat Manager will be configured'
    end
  end
  notifies :create, "template[#{tomcat_folder}\\conf\\tomcat-users.xml]", :immediately
  notifies :create, "template[#{tomcat_folder}\\webapps\\manager\\WEB-INF\\web.xml]", :immediately
  notifies :create, "template[#{tomcat_folder}\\conf\\server.xml]", :immediately
  notifies :restart, 'windows_service[Tomcat7]', :immediately
end
