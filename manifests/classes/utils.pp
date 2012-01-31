class utils{
  package { [ "build-essential", "curl", "lsof", "lynx", "nc", "tmux", "strace", "tcpdump", "telnet", "wget", "git-core", "sar", "dstat", "htop", "iotop", "slurm", "multitail" ]: ensure => installed }
  
  service {
    "sysstat":
      name => "sysstat",
      ensure => running,
      hasrestart => true
  }
  
}
