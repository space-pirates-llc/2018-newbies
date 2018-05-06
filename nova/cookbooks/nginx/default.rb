package 'nginx' do
  action :install
end

service 'nginx' do
  action %i[enable start]
end

remote_file '/etc/nginx/nginx.conf' do
  mode '644'
  notifies :restart, "service[nginx]"
end

remote_file "/etc/nginx/sites-enabled/default" do
  mode '644'
  notifies :restart, "service[nginx]"
end
