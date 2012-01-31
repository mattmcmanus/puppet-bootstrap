class utils{
  package { [ "curl", "lsof", "lynx", "nc", "screen", "strace", "tcpdump", "telnet", "wget", "git-core", "sar", "dstat", "htop", "iotop", "slurm", "multitail" ]: ensure => present }
  
  service {
    "sysstat":
      name => "sysstat",
      ensure => running,
      hasrestart => true
  }
  
}
