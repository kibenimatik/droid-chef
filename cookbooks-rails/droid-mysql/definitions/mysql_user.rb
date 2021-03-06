# Definition mysql_user for cookbook droid-mysql


define :mysql_user do
  root_password = node[:deploy_user][:database_root_password]
  mysql_cmd = "mysql -uroot -p#{root_password} mysql -e"

  access_from = node[:deploy_user][:database_access_from] || []
  access_from += ['localhost', node['mysql']['bind_address']]


  Chef::Log.debug("params[:name] -> #{params[:name]} ")  #Debug Fadeev

  access_from.each do |host|
    exists = ["#{mysql_cmd} \"SELECT user,host FROM mysql.user  WHERE user='#{params[:name]}';\""]
    exists.push "| grep #{params[:name]} | grep #{host}"
    exists = exists.join ' '

    execute "creating mysql user #{params[:name]}" do
      user "root"
      command "#{mysql_cmd} \"CREATE USER '#{params[:name]}'@'#{host}' IDENTIFIED BY '#{params[:password]}';\""
      not_if exists, user: "root"
    end

    execute "altering mysql user #{params[:name]}" do
      user "root"
      command "#{mysql_cmd} \"SET PASSWORD FOR '#{params[:name]}'@'#{host}' = PASSWORD('#{params[:password]}');\""
    end

    # Change privileges mysql user, node[:deploy_user][:username] = ALL PRIVILEGES, node[:app][:app_user] = PRIVILEGES ONLY APP DB
    execute "grant priveligies for mysql user #{params[:name]}" do
      user "root"
      
      if params[:name] == node[:deploy_user][:username]
        command "#{mysql_cmd} \"GRANT ALL PRIVILEGES ON *.* TO #{params[:name]}@#{host} WITH GRANT OPTION; FLUSH PRIVILEGES;\""
      else
        command "#{mysql_cmd} \"GRANT ALL PRIVILEGES ON #{params[:name]}.* TO #{params[:name]}@#{host}; FLUSH PRIVILEGES;\""
      end
    end
  end
end

