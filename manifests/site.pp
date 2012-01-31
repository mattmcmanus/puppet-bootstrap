import "nodes/*.pp"
import "classes/*.pp"

import "modules.pp"

filebucket { main: server => puppet }

$platform = "$operatingsystem-$lsbdistcodename-$architecture"

# global defaults
File { backup => main }
# Default file parameters
File {
    ignore => [ '.svn', '.git', 'CVS' ],
    owner  => "root",
    group  => "root",
    mode   => "644",
}

# default exec parameters
Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
}

# by default when we talk about a package we want to install it.
Package {
    ensure => installed,
}


Package {
  provider => $operatingsystem ? {
    debian => aptitude,
    ubuntu => aptitude
  }
}


#          Munin Config
# - - - - - - - - - - - - - - - - -
$munin_cidr_allow = '50.57.117.79'
$munin_allow = '^50\.57\.117\.79$'
