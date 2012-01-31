import "nodes/*.pp"
import "classes/*.pp"

import "modules.pp"

filebucket { main: server => puppet }

# global defaults
File { backup => main }
Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }

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
