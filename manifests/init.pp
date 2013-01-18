# Class: amavisd
#
# manages the installation of the amavisd server as well as the service and the user configfile
# Parameters:
#   [*user_config*]     - configuration for amavis (will be wrapped into the user_configfile)
#                         (default: +undef+ which means an almost empty user file will be created)
#   [*package_ensure*]  - ensure package (default: +present+)
#   [*service_ensure*]  - ensure service (default: +running+)
#   [*package_name*]    - name of package
#   [*service_name*]    - name of service
#   [*user_configfile*] - location/name of the configfile
#   [*root_group*]      - group of root user
#
class amavisd (
  $user_config     = undef,
  $package_ensure  = hiera('package_ensure', 'present'),
  $service_ensure  = hiera('service_ensure', 'running'),
  $package_name    = hiera('package_name', $amavisd::params::package_name),
  $service_name    = hiera('service_name', $amavisd::params::service_name),
  $user_configfile = hiera('user_configfile', $amavisd::params::user_configfile),
  $root_group      = hiera('root_group', $amavisd::params::root_group)
) inherits amavisd::params {

  package { 'amavisd':
    ensure => $package_ensure,
    name   => $package_name,
  }

  service { 'amavis':
    ensure => $service_ensure,
    name   => $service_name,
  }

  file { $user_configfile:
    ensure  => file,
    content => template('amavisd/user.erb'),
    owner   => 'root',
    group   => $root_group,
    mode    => '0644',
  }

  Package['amavisd'] -> Service['amavis']
  Package['amavisd'] -> File[$user_configfile]
  File[$user_configfile] ~> Service['amavis']
}
