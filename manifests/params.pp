# Class: amavisd::params
#
#   The amavisd configuration settings.
#
# Parameters:
#   [*additional_osfamily*] - hash with values for unsuppoerted/unusual ::osfamily
#                             systems (default: empty hash)
#
# Requires:
#   stdlib (module)
#
# Sample Usage:
#
#   class { 'amavisd::params':
#     additional_osfamily => {
#       'Solaris' => {
#         'package_name'    => 'CSWamavsid',
#         'service_name'    => 'cswamavisd',
#         'user_configfile' => '/etc/csw/amavis/conf.d/50-user'
#       }
#     }
#   }
#
class amavisd::params (
  $additional_osfamily = {}
) {
  validate_hash($additional_osfamily)

  case $::osfamily {
    'Debian': {
      $package_name = 'amavisd-new'
      $service_name = 'amavis'
      $user_configfile = '/etc/amavis/conf.d/50-user'
    }

    default: {
      if $additional_osfamily[$::osfamily] {
        $package_name = $additional_osfamily[$::osfamily]['package_name']
        $service_name = $additional_osfamily[$::osfamily]['service_name']
        $user_configfile = $additional_osfamily[$::osfamily]['user_configfile']
      } else {
        fail("Unsupported osfamily: ${::osfamily}")
      }
    }
  }

  # If no root_group was set by the os specific section the default
  # value will be 'root'.
  if !$root_group {
    $root_group = 'root'
  }
}
