class guacamole::repo (
  $ensure      = present,
  $source_name = 'guacamole',
  $include_src = false,
) {
  case $::osfamily {
    'Debian': {
      $key      = '106BB296'
      $location = 'http://ppa.launchpad.net/guacamole/stable/ubuntu'
      class { 'guacamole::repo::debian': }
    }
    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily Debian and Ubuntu")
    }
  }
}
