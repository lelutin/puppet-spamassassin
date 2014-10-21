class spamassassin::params {
  $configdir  = '/etc/mail/spamassassin'
  $razor_home = "${spamassassin::params::configdir}/.razor"
  $pyzor_home = "${spamassassin::params::configdir}/.pyzor"

  case $::osfamily {
      'Debian': {
          $spamd_options_file   = '/etc/default/spamassassin'
          $spamd_options_var    = 'OPTIONS'
          $spamd_defaults       = '-c -H'
          $sa_update_file       = $spamd_options_file
      }
      'Redhat': {
          $spamd_options_file   = '/etc/sysconfig/spamassassin'
          $spamd_options_var    = 'SPAMDOPTIONS'
          $spamd_defaults       = '-d -c -H'
          $sa_update_file       = '/etc/sysconfig/sa-update'
      }
      default: {
          fail("${::operatingsystem} is not supported by this module.")
      }
  }
}
