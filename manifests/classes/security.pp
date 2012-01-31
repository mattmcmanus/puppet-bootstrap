class security {
  # Tools to augment security
  # - Denyhosts periodically scans /var/log/auth.log for repeated failures to access the system via SSH. It then adds these offenders to /etc/hosts.deny.
  # - Chkrootkit scans the system for evidence that a rootkit has been installed.
  package {   
    ['denyhosts', 'chkrootkit', 'logwatch']: ensure => present;
  }
  
  service { "denyhosts":
    ensure   => running,
    require  => Package['denyhosts']
  }
}