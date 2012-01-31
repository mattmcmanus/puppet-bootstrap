
# Based off of https://github.com/dcsobral/puppet-users/blob/master/manifests/definitions/useraccount.pp
# and
# http://projects.puppetlabs.com/projects/1/wiki/Authorized_Keys_Patterns
define users::account ( $ensure = present, $fullname, $uid = '', $groups = [], $shell = '/bin/bash', $password = '' ) {
	case $ensure {
    present: {
      $home_owner = $name
      $home_group = $name
    }
    default: {
      $home_owner = "root"
      $home_group = "root"
    }
  }

	group { $name:
    ensure => present
  }
  
  $home = "/home/${name}"
  
  user { $name:
    gid       => $name,
    comment   => $fullname,
    home      => $home,
    shell     => $shell,
    ensure    => $ensure,
    groups    => $groups,
    allowdupe => false,
    require   => Group[$name],
    managehome => true;
  }

  # Set password if available
  if $password != '' {
    User <| title == "$name" |> { password => $password }
  }

  file {
    $home:
      ensure  => directory,
      owner   => $home_owner,
      group   => $home_group,
      mode    => 750,
      require => User[$name];
    "$home/.ssh":
      ensure  => directory,
      owner   => $home_owner,
      group   => $home_group,
      mode    => 700,
      require => File[$home];
    "$home/.ssh/authorized_keys":
      ensure  => present,
      owner   => $home_owner,
      group   => $home_group,
      mode    => 644,
      require => File["$home/.ssh"],
      alias => "$name/keys";
    "$home/.ssh/authorized_keys2":
      ensure  => "$home/.ssh/authorized_keys",
      require => File["$home/.ssh/authorized_keys"],
  }

  # Create Keys
  $private_key = "$home/.ssh/id_rsa"
  $public_key = "$home/.ssh/id_rsa.pub"
  $authorized_keys = "$home/.ssh/authorized_keys"


  file { $public_key:
    checksum => md5,
    require  => [ User[$name], File[$home], File["$home/.ssh"] ],
  }

  exec { "Creating key pair for $name":
    command => "ssh-keygen -t rsa -C 'Provided by Puppet for $name' -N '' -f $private_key",
    creates => $private_key,
    require => [ User[$name], File[$home], File["$home/.ssh"] ],
    user    => $name,
    before  => Exec["Building $authorized_keys"],
  }

  exec { "Building $authorized_keys":
    command   => "cp $public_key $authorized_keys",
    creates   => $authorized_keys,
    subscribe => File[$public_key],
    require   => [ User[$name], File[$public_key], File[$home], File["$home/.ssh"] ],
  }
}

define users::authorized_keys ( $ensure = present, $key, $user = $username, $type = 'ssh-rsa') {
  ssh_authorized_key{ 
    $name:
      ensure  => $ensure,
      key     => $key,
      type    => $type,
      user    => $user,
      require => [User[$user], File["$user/keys"]]
  }
}
