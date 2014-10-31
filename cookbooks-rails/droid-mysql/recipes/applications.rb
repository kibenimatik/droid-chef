user_name = node[:deploy_user][:database_username]
root_password = node[:deploy_user][:database_root_password]

mysql_user user_name do
  password node[:deploy_user][:database_password]
end

node['applications'].each do |app|
  if app[:database] == 'mysql'
    execute "create database for: #{app[:name]}." do
      user node[:deploy_user][:username]
      command "mysql -uroot -p#{root_password} -e \"CREATE DATABASE IF NOT EXISTS #{app[:name]}\""
    end
    mysql_user app[:app_user] do
      password app[:app_password] || app[:name] + '_PASSWORD'
    end
  end
end

# node["applications"].each do |app|
#  database = app[:database] || node[:deploy_user][:database] || 'mysql'
#
# if database == 'mysql'
#    execute "create database for: #{app[:name]}." do
#      user node[:deploy_user][:username]
#      command "mysql -uroot -p#{root_password} -e \"CREATE DATABASE IF NOT EXISTS #{app[:name]}\""
#    end
#  end
# end
