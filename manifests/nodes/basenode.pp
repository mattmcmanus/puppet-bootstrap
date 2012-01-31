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
  munin::plugin {
    [ "apache_accesses", "apache_processes", "apache_volume" ]:
      ensure => present,
      config => "env.url http://127.0.0.1:80/server-status?auto"
  }
  
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
  # Give matt easy access to the root account
  ssh_authorized_key{ "mcmanusm-mbp":
    ensure  => present,
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQD1qbjMQob2PuJRMKZ6j4DuoPFRpiBvXX5PqKxr4I4IGxIzQhaszeejYSMWCuuacyFzAAgmvci3S37jHN20Ebt7p6EYvr0AHbkOfZb/mgQ6BWEXFhH2gnT9ChK4M/nFlB5CP0w0GopocW4tEeeZIWJtNmCDIGcj7I+cpWSVdAMxqQubXhPIaKElnAAXQ6+o9UnrDMLpI6Qdx/pK1clkqMitThAPvahcAk3GmFR1Q8zdlfZU55bepAgxF8AuW/k2mcj2glRCnq31v/H/xMAXu3iwShIPgZZ2vbi4SQ6MG2Xk2o/hPuxgwImRxZIvRvUiuxLpFr+ib8uOQIAneSpaeh3T',
    type    => 'ssh-rsa',
    user    => 'root',
  }
  # Make sure the admin group is there before we create the user aggount
  group { 'admin':
    ensure => present
  }
  # Ensure that everyone in this has sudo access
  sudoers::group { admin:
    ensure => present,
    commands => "ALL",
  }
  
  # Definte the name in this var so you can set the new username as well as shortcut the authkeys
  $username = "harvestusa"
  # Create the main user account
  users::account{ $username:
    password => "h@rv3stUSAAAA",
    fullname => "Global Information Services",
    groups => ['admin']
  }
  # Give public key access to the appropriate accounts
  users::authorized_keys { 
    "harvestusa-mcmanusm-mbp": user => $username, key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQD1qbjMQob2PuJRMKZ6j4DuoPFRpiBvXX5PqKxr4I4IGxIzQhaszeejYSMWCuuacyFzAAgmvci3S37jHN20Ebt7p6EYvr0AHbkOfZb/mgQ6BWEXFhH2gnT9ChK4M/nFlB5CP0w0GopocW4tEeeZIWJtNmCDIGcj7I+cpWSVdAMxqQubXhPIaKElnAAXQ6+o9UnrDMLpI6Qdx/pK1clkqMitThAPvahcAk3GmFR1Q8zdlfZU55bepAgxF8AuW/k2mcj2glRCnq31v/H/xMAXu3iwShIPgZZ2vbi4SQ6MG2Xk2o/hPuxgwImRxZIvRvUiuxLpFr+ib8uOQIAneSpaeh3T';
  }

}
