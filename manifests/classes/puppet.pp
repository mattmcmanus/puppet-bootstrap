class puppet {

    package {
      "puppet": ensure => present;
    } # package

    file {
      "/etc/puppet/puppet.conf":
        content  => template("puppet.conf.erb"),
        mode     => "644",
        checksum => md5,
        require  => Package["puppet"];
      "/var/lib/puppet/.ssh":
        ensure   => directory,
        mode     => "700",
        group    => "puppet",
        owner    => "puppet";
    } # file
    
    cron { "run-puppet-config":
      command => 'puppet apply /etc/puppet/manifests/site.pp',
      user => 'root',
      minute => 30,
      hour => 2
    }
} # class puppet
