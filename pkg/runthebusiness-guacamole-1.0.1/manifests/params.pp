# Class: guacamole::params
#
# Params for guacamole
#
# Parameters:
#
# Sample Usage:
#
class guacamole::params {
	$execlaunchpaths = ["/usr/bin", "/usr/sbin", "/bin", "/sbin", "/etc"]
	$executefrom = "/tmp/"
	
	case $::operatingsystem {
    'centos', 'redhat', 'fedora': {
      #TODO: needs filling in
    }
    'ubuntu', 'debian': {
      $owner='root'
      $group='root'
      $mode='775'
      $downloadto='/usr/src/'
      $filename = 'guacamole-0.6.4-debian-6.0-amd64.tar.gz'
      $destinationfile = "guacamole-0.6.4-debian-6.0-amd64/"
      $creates = "${downloadto}${destinationfile}"
      $downloadfrom = 'http://downloads.sourceforge.net/project/guacamole/current/binary/debian-6.0-amd64/guacamole-0.6.4-debian-6.0-amd64.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fguacamole%2Ffiles%2Fcurrent%2Fbinary%2Fdebian-6.0-amd64%2F&ts=1353722117&use_mirror=iweb'
      $vdir = '/etc/apache2/sites-enabled/'
    }
    default: {
      #TODO: needs filling in
    }
  }
}
