# == Class: spamassassin::params
#
# Default parameter values for class spamassassin
#
# TODO: This should be replaced by data-in-module with hiera 5
#
class spamassassin::params {
  $configdir  = '/etc/mail/spamassassin'
  $razor_home = "${spamassassin::params::configdir}/.razor"
  $pyzor_home = "${spamassassin::params::configdir}/.pyzor"

  case $facts['os']['family'] {
    'Debian': {
      if versioncmp($facts['os']['release']['major'], '12') >= 0 {
        $service_name = 'spamd'
        $package_name = 'spamd'
      } else {
        $service_name = 'spamassassin'
        $package_name = 'spamassassin'
      }
      $spamd_options_file   = '/etc/default/spamassassin'
      $spamd_options_var    = 'OPTIONS'
      $spamd_defaults       = '-c -H'
      $sa_update_file       = $spamd_options_file
    }
    'Redhat': {
      $service_name = 'spamassassin'
      $package_name = 'spamassassin'
      $spamd_options_file   = '/etc/sysconfig/spamassassin'
      $spamd_options_var    = 'SPAMDOPTIONS'
      case $facts['os']['release']['major'] {
        '6', '7', '8': {
          $spamd_defaults   = '-d -c -H'
        }
        default: {
          $spamd_defaults   = '-c -H'
        }
      }
      $sa_update_file       = '/etc/sysconfig/sa-update'
    }
    default: {
      fail("${facts['os']['name']} is not supported by this module.")
    }
  }
}
