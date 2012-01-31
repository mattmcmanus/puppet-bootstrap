class ufw::defaults {
  include ufw
  
  ufw::allow { "allow-ssh-from-all":
    port => 'ssh',
  }
  ufw::limit { 22: }
  
  
  ufw::allow {
    "allow-dns-over-udp":
    port => 53,
    proto => "udp";
  }

}