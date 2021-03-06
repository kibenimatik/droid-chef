# DROID ATTRIBUTES FOR BACKUPS

version = node[:deploy_user][:ruby_version]

default[:backup][:cron_hour]   = '0,12'
default[:backup][:mailto]      = 'sample@example.com'
default[:backup][:base_dir]    = '/opt/backup'
default[:backup][:gem_bin_dir] = "sudo -i env RBENV_VERSION=#{version} /usr/local/rbenv/shims"
