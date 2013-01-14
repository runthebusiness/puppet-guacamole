# guacamole
#
# This class installs and configures guacamole
#
# Parameters:
# - $username: username for user-mapping.xml (Default: 'admin')
# - $password: password for user-mapping.xml (Default: 'password')
# - $hostname: hostname for user-mapping.xml (Default: 'localhost')
# - $port: port for user-mapping.xml (Default: '5901')
# - $proxypath: creates a proxy vhost file (Default: undef)


define guacamole(
  $username='admin',
  $password='changeme',
  $hostname='localhost',
  $port='5901',
  $proxypath=undef,
) {
  
  include guacamole::params
  
  #install dependencies
  package{"${name}_dependencies":
    name=>[
      'tomcat6',
      'libvncserver0',
      #'tightvncserver',
      #'libcairo2 ',
      'libpng12-0',
      #'libfreerdp1',
     ],
    ensure=>'present'
  }
  
 
  
  case $::operatingsystem {
    'centos', 'redhat', 'fedora': {
      #TODO: needs filling in
    }
    'ubuntu', 'debian': {
		  
		  # Download the .deb files
		  fetchfile{"${name}_fetchguacamole":
		    downloadurl=>$guacamole::params::downloadfrom,
		    downloadfile=>$guacamole::params::filename,
		    downloadto=>$guacamole::params::downloadto,
		    desintationpath=>$guacamole::params::downloadto,
		    destinationfile=>$guacamole::params::destinationfile,
		    owner=>$guacamole::params::owner,
		    group=>$guacamole::params::group,
		    mode=>$guacamole::params::mode,
		    require=>[
		      Package["${name}_dependencies"]
		    ]
		  }
		  
		  # Install the files downloaded
			package{"${name}_installguacamole":
			  ensure=>'present',
			  provider=>'dpkg',
			  source=>[
			   "${guacamole::params::creates}guacamole_0.6.2-1_all.deb",
			   "${guacamole::params::creates}guacamole-tomcat_0.6.2-1_all.deb",
			   "${guacamole::params::creates}guacd_0.6.2-1_amd64.deb",
			   "${guacamole::params::creates}libguac3_0.6.3-1_amd64.deb",
			   "${guacamole::params::creates}libguac-client-vnc0_0.6.1-1_amd64.deb",
			   "${guacamole::params::creates}libguac-dev_0.6.3-1_amd64.deb",
			  ],
			  require=>Fetchfile["${name}_fetchguacamole"]
			}
    }
    default: {
      #TODO: needs filling in
    }
  }
  
	# Create the simlinks
	file{"${name}_guacamolelinkwar":
	  ensure=>'link',
	  path=>'/var/lib/tomcat6/webapps/guacamole.war',
	  target=>'/var/lib/guacamole/guacamole.war',
	  owner=>$guacamole::params::owner,
	  group=>$guacamole::params::group,
	  mode=>$guacamole::params::mode,
	  require=>package["${name}_installguacamole"]
	}
	
	file{"${name}_guacamolelinproperties":
	  ensure=>'link',
	  path=>'/var/lib/tomcat6/common/classes/guacamole.properties',
	  target=>'/etc/guacamole/guacamole.properties',
	  owner=>$guacamole::params::owner,
	  group=>$guacamole::params::group,
	  mode=>$guacamole::params::mode,
	  require=>package["${name}_installguacamole"]
	}
	
	# configure the user-mappings.xml file
	file{"${name}_guacamoleusermappings":
	  ensure=>'file',
	  path=>'/etc/guacamole/user-mapping.xml',
	  content=>template('guacamole/user-mapping.erb'),
	  owner=>$guacamole::params::owner,
	  group=>$guacamole::params::group,
	  mode=>$guacamole::params::mode,
	  require=>package["${name}_installguacamole"]
	}
	
	# Make proxy:
	if $proxypath != undef{
	  file { "${guacamole::params::vdir}/000-quacamoleproxy.conf":
      ensure  => 'present',
      content => template('guacamole/proxy.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
	}
}
