# == Class: spamassassin::install
#
# Install packages for spamassassin and related software.
#
# This class should not be used directly. Use the spamassassin class and its
# parameters instead.
#
class spamassassin::install {
  if $spamassassin::dkim_enabled {
    case $facts['os']['family'] {
      'Debian' : {
        package { 'dkim':
          ensure => installed,
          name   => 'libmail-dkim-perl',
        }
      }
      'RedHat' : {
        package { 'dkim':
          ensure => installed,
          name   => 'perl-Mail-DKIM',
        }
      }
      default: {
        fail("${facts['os']['name']} is not supported")
      }
    }
  }

  package { 'spamassassin':
    ensure => installed,
    name   => $spamassassin::package_name
  }

  if $spamassassin::pyzor_enabled {
    package { 'pyzor':
      ensure  => installed,
      require => Package['spamassassin'],
    }
  }

  if $spamassassin::razor_enabled {
    case $facts['os']['family'] {
      'Debian': {
        $razor_package = 'razor'
      }
      'RedHat': {
        $razor_package = 'perl-Razor-Agent'
      }
      default: {
        fail("${facts['os']['name']} is not supported")
      }
    }

    package { 'razor':
      ensure  => installed,
      name    => $razor_package,
      require => Package['spamassassin'],
    }
  }
}
