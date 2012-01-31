class php5 {
	package {   
    ['php5', 'php5-mysql', 'php5-suhosin', 'libapache2-mod-php5', 'php5-cli', 'php5-curl', 'php5-cgi', 'php5-gd']: ensure => present; 
    'libphp-phpmailer': ensure => latest;
    }
}