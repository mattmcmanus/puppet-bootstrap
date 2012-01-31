node basenode {
  include puppet
  include utils, security, hardening
  include postfix

  $root_email = "matt@ablegray.com"
  include rootmail

  include apt
  apt::conf{"99unattended-upgrade":
    ensure  => present,
    content => "APT::Periodic::Unattended-Upgrade \"1\";\n",
  }
  
  include munin::client, munin::host
  #munin::plugin {
  #  [ "apache_accesses", "apache_processes", "apache_volume" ]:
  #    ensure => present,
  #    config => "env.url http://127.0.0.1:80/server-status?auto"
  #}
  
  #           Important Variables
  # - - - - - - - - - - - - - - - - - - - - -
  # AWS keys for backups
  #$aws_access_key_id="xxx"
  #$aws_secret_access_key="xxx"
  #$passphrase='xxx'
  
  #           Important Files and Dirs
  # - - - - - - - - - - - - - - - - - - - - -
  file {
    "root/scripts":
      path => "/root/scripts/",
      ensure => directory;
  }
  
  #        Make sure the right people can 
  #        SSH into all servers with PWs
  # - - - - - - - - - - - - - - - - - - - - - 

  # Make sure the admin group is there before we create the user aggount
  group { 'admin':
    ensure => present
  }
  # Ensure that everyone in this has sudo access
  sudoers::group { admin:
    ensure => present,
    commands => "ALL",
  }

}
