# == Class: spamassassin
#
# This module installs and configures spamassassin
# and a few of it's plugins.
#
# === Parameters
#
# [*sa_update*]
# Boolean. Enable the sa-update cron job.
# Default: false
#
# [*run_execs_as_user*]
# If you enabled razor and/or pyzor and would
# like the razor-admin or pyzor discover commands
# to be run as a different user specify the username
# in this directive. Example: amavis. Default: undef
#
# [*service_enable*]
# Boolean. Will enable service at boot
# and ensure a running service.
#
# [*spamd_max_children*]
# This option specifies the maximum number of children to spawn.
# Spamd will spawn that number of children, then sleep in the background
# until a child dies, wherein it will go and spawn a new child.
#
# [*spamd_min_children*]
# The minimum number of children that will be kept running
# The minimum value is 1, the default value is 1 in spamd, and undef here.
# If you have lots of free RAM, you may want to increase this.
#
# [*spamd_listen_address*]
# Tells spamd to listen on the specified IP address (defaults to 127.0.0.1).
# Use 0.0.0.0to listen on all interfaces. You can also use a  valid hostname
# which will make spamd listen on the first address that name resolves to.
#
# [*spamd_allowed_ips*]
# Specify a list of authorized hosts or networks which can connect to this
# spamd instance. Single IP addresses, CIDR format networks, or ranges of
# IP addresses by listing 3 or less octets with a trailing dot. Hostnames
# are not supported, only IP addresses.  This option can be specified
# multiple times, or can take a list of addresses separated by commas.
#
# [*spamd_username*]
# spamd runs as this user
#
# [*spamd_groupname*]
# spamd runs in this group
#
# [*spamd_nouserconfig*]
# Turn off (on) reading of per-user configuration files (user_prefs) from
# the user's home directory. The default behaviour is to read per-user
# configuration from the user's home directory (--user-config).
#
# [*spamd_allowtell*]
# Allow learning and forgetting (to a local Bayes database), reporting and
# revoking (to a remote database) by spamd. The client issues a TELL command
# to tell what type of message is being processed and whether local (learn/forget)
# or remote (report/revoke) databases should be updated.
#
# [*spamd_sql_config*]
# Turn on SQL lookups even when per-user config files have been disabled with -x
# this is useful for spamd hosts which don’t have user’s home directories
# but do want to load user preferences from an SQL database.
#
# [*required_score*]
# Set the score required before a mail is considered spam. n.nn can be an
# integer or a real number.
#
# [*score_tests*]
# Assign scores (the number of points for a hit) to a given test.
# Scores can be positive or negative real numbers or integers.
#
# [*whitelist_from*]
# Used to whitelist sender addresses which send mail that is often
# tagged (incorrectly) as spam. This would be written to the global
# local.cf file
#
# [*whitelist_to*]
# If the given address appears as a recipient in the message headers
# (Resent-To, To, Cc, obvious envelope recipient, etc.) the mail will
# be whitelisted.
#
# [*blacklist_from*]
# Used to specify addresses which send mail that is often
# tagged (incorrectly) as non-spam, but which the user doesn't want.
#
# [*blacklist_to*]
# If the given address appears as a recipient in the message headers
# (Resent-To, To, Cc, obvious envelope recipient, etc.) the mail will
# be blacklisted.
#
# [*rewrite_header_subject*]
# By default, suspected spam messages will not have the Subject, From
# or To lines tagged to indicate spam. By setting this option, the header
# will be tagged with the value of the parameter to indicate that a message
# is spam.
#
# [*rewrite_header_from*]
# See rewrite_header_subject.
#
# [*rewrite_header_to*]
# See rewrite_header_subject.
#
# [*report_safe*]
# Values: 0,1 or 2.
# See: http://spamassassin.apache.org/full/3.3.x/doc/Mail_SpamAssassin_Conf.html#report_safe
# Default: 0
#
# [*clear_trusted_networks*]
# Boolean. Empty the list of trusted networks. Default: false
#
# [*trusted_networks*]
# What networks or hosts are 'trusted' in your setup. Trusted in this case means
# that relay hosts on these networks are considered to not be potentially operated
# by spammers, open relays, or open proxies.
#
# [*clear_internal_networks*]
# Boolean. Empty the list of internal networks. Default: false
#
# [*internal_networks*]
# Internal means that relay hosts on these networks are considered
# to be MXes for your domain(s), or internal relays.
#
# [*skip_rbl_checks*]
# Boolean. If false SpamAssassin will run RBL checks. Default: true
#
# [*dns_available*]
# If set to 'test', SpamAssassin will query some default hosts on the
# internet to attempt to check if DNS is working or not. Default: yes
#
# [*bayes_enabled*]
# Boolean. Whether to use the naive-Bayesian-style classifier built
# into SpamAssassin. Default: true
#
# [*bayes_use_hapaxes*]
# Boolean. Should the Bayesian classifier use hapaxes (words/tokens that occur
# only once) when classifying? This produces significantly better hit-rates,
# but increases database size by about a factor of 8 to 10. Default: true
#
# [*bayes_auto_learn*]
# Boolean. Whether SpamAssassin should automatically feed high-scoring mails
# into its learning systems. Default: true
#
# [*bayes_ignore_header*]
# See http://spamassassin.apache.org/full/3.3.x/doc/Mail_SpamAssassin_Conf.html#bayes_ignore_header
#
# [*bayes_auto_expire*]
# Boolean. If enabled, the Bayes system will try to automatically expire old
# tokens from the database. Default: true
#
# [*bayes_sql_enabled*]
# Boolean. If true will set bayes_store_module to use sql and will write the
# sql dsn, and other directives, to local.cf. Default: false
#
# [*bayes_sql_dsn*]
# This parameter gives the connect string used to connect to the SQL based
# Bayes storage. By default will use the mysql driver and a database called
# spamassassin. Please note the module does not manage any database settings
# or the creation of the schema.
#
# [*bayes_sql_username*]
# The sql username used for the dsn provided above.
#
# [*bayes_sql_password*]
# The sql password used for the dsn provided above.
#
# [*bayes_sql_override_username*]
# If this options is set the BayesStore::SQL module will override the set
# username with the value given. This could be useful for implementing global
# or group bayes databases.
#
# [*bayes_path*]
# This is the directory and filename for Bayes databases. Please note this
# parameter is not used if bayes_sql_enabled is true.
#
# [*user_scores_dsn*]
# The perl DBI DSN string used to specify the SQL server holding user config
# example: 'DBI:mysql:dbname:hostname
#
# [*user_scores_sql_username*]
# The SQL username to connect to the above server
#
# [*user_scores_sql_password*]
# The SQL password for the above user
#
# [*user_scores_sql_custom_query*]
# Custom SQL query to use for spamd user_prefs.
#
# [*dcc_enabled*]
# Boolean. Enable/disable the DCC plugin. Default: false
#
# [*dcc_timeout*]
# How many seconds you wait for DCC to complete,
# before scanning continues without the DCC results. Default: 8
#
# [*dcc_body_max*]
# This option sets how often a message's body/fuz1/fuz2 checksum
# must have been reported to the DCC server before SpamAssassin
# will consider the DCC check as matched. As nearly all DCC clients
# are auto-reporting these checksums, you should set this to a relatively
# high value, e.g. 999999 (this is DCC's MANY count). Default: 999999
#
# [*dcc_fuz1_max*]
# See dcc_body_max. Default: 999999
#
# [*dcc_fuz2_max*]
# See dcc_body_max. Default: 999999
#
# [*pyzor_enabled*]
# Boolean. Enable/disable the Pyzor plugin. Default: true
#
# [*pyzor_timeout*]
# How many seconds you wait for Pyzor to complete, before scanning continues
# without the Pyzor results. Default: 3.5
#
# [*pyzor_max*]
# This option sets how often a message's body checksum must have been reported
# to the Pyzor server before SpamAssassin will consider the Pyzor check as matched.
# Default: 5
#
# [*pyzor_options*]
# Specify additional options to the pyzor command. Please note that only characters
# in the range [0-9A-Za-z ,._/-] are allowed for security reasons. Please note that
# the module will automatically add the homedir options as part of the configuration.
#
# [*pyzor_path*]
# This option tells SpamAssassin specifically where to find the pyzor client instead
# of relying on SpamAssassin to find it in the current PATH.
#
# [*pyzor_home*]
# Define the homedir for pyzor. Default is to use the [global config dir]/.pyzor
#
# [*razor_enabled*]
# Boolean. Enable/disable the Pyzor plugin. Default: true
#
# [*razor_timeout*]
# How many seconds you wait for Razor to complete before you go on without the results.
# Default: 5
#
# [*razor_home*]
# Define the homedir for razor. Please note that if you set a custom path the module will
# automatically use the directory in which you store your razor config as the home
# directory for the module. Default is to use the [global config dir]/.razor
#
# [*spamcop_enabled*]
# Boolean. Enable/disable the Pyzor plugin. Default: false
#
# [*spamcop_from_address*]
# This address is used during manual reports to SpamCop as the From: address. You
# can use your normal email address. If this is not set, a guess will be used as
# the From: address in SpamCop reports.
#
# [*spamcop_to_address*]
# Your customized SpamCop report submission address. You need to obtain this address
# by registering at http://www.spamcop.net/. If this is not set, SpamCop reports will
# go to a generic reporting address for SpamAssassin users and your reports will probably
# have less weight in the SpamCop system.
#
# [*spamcop_max_report_size*]
# Messages larger than this size (in kilobytes) will be truncated in report messages sent
# to SpamCop. The default setting is the maximum size that SpamCop will accept at the time
# of release. Default: 50
#
# [*awl_enabled*]
# Boolean. Enable/disable the Auto-Whitelist plugin. Default: false
#
# [*awl_sql_enabled*]
# Boolean. If true will set auto_whitelist_factory to use sql and will write the
# sql dsn, and other directives, to local.cf. Default: false
#
# [*awl_dsn*]
# This parameter gives the connect string used to connect to the SQL based
# storage. By default will use the mysql driver and a database called
# spamassassin. Please note the module does not manage any database
# settings or the creation of the schema.
#
# [*awl_sql_username*]
# The sql username used for the dsn provided above.
#
# [*awl_sql_password*]
# The sql password used for the dsn provided above.
#
# [*awl_sql_override_username*]
# Used by the SQLBasedAddrList storage implementation.  If this option is
# set the SQLBasedAddrList module will override the set username with the
# value given. This can be useful for implementing global or group based
# auto-whitelist databases.
#
# [*auto_whitelist_path*]
# This is the automatic-whitelist directory and filename.
# Default: ~/.spamassassin/auto-whitelist
#
# [*auto_whitelist_file_mode*]
# The file mode bits used for the automatic-whitelist directory or file.
# Default: 0600
#
# [*shortcircuit_enabled*]
# Boolean. Enable/disable the Shortcircuit plugin. Default: false
#
# [*shortcircuit_user_in_whitelist*]
# Values: ham, spam, on or off.
#
# [*shortcircuit_user_in_def_whitelist*]
# Values: ham, spam, on or off.
#
# [*shortcircuit_user_in_all_spam_to*]
# Values: ham, spam, on or off.
#
# [*shortcircuit_subject_in_whitelist*]
# Values: ham, spam, on or off.
#
# [*shortcircuit_user_in_blacklist*]
# Values: ham, spam, on or off.
#
# [*shortcircuit_user_in_blacklist_to*]
# Values: ham, spam, on or off.
#
# [*shortcircuit_subject_in_blacklist*]
# Values: ham, spam, on or off.
#
# [*shortcircuit_all_trusted*]
# Values: ham, spam, on or off.
#
# [*dkim_enabled*]
# Boolean. Enable/disable the DKIM plugin. Default: true
#
# [*dkim_timeout*]
# How many seconds to wait for a DKIM query to complete,
# before scanning continues without the DKIM result.
# Default: 5
#
# [*rules2xsbody_enabled*]
# Boolean.  Enable the Rule2XSBody plugin.
# Compile ruleset to native code with sa-compile.
# Requires re2c and gcc packages (not managed in this module)
#
#
# === Examples
#
#  See tests folder.
#
# === Authors
#
# Scott Barr <gsbarr@gmail.com>
#
class spamassassin(
  $sa_update                          = false,
  $run_execs_as_user                  = undef,
  # Spamd settings
  $service_enabled                    = false,
  $spamd_max_children                 = 5,
  $spamd_min_children                 = undef,
  $spamd_listen_address               = '127.0.0.1',
  $spamd_allowed_ips                  = '127.0.0.1/32',
  $spamd_username                     = undef,
  $spamd_groupname                    = undef,
  $spamd_nouserconfig                 = false,
  $spamd_allowtell                    = false,
  $spamd_sql_config                   = false,
  # Scoring options
  $required_score                     = 5,
  $score_tests                        = {},
  # Whitelist and blacklist options
  $whitelist_from                     = [],
  $whitelist_to                       = [],
  $blacklist_from                     = [],
  $blacklist_to                       = [],
  # Message tagging options
  $rewrite_header_subject             = undef,
  $rewrite_header_from                = undef,
  $rewrite_header_to                  = undef,
  $report_safe                        = 0,
  # Network test options
  $clear_trusted_networks             = false,
  $trusted_networks                   = [],
  $clear_internal_networks            = false,
  $internal_networks                  = [],
  $skip_rbl_checks                    = true,
  $dns_available                      = 'yes',
  # Learning options
  $bayes_enabled                      = true,
  $bayes_use_hapaxes                  = true,
  $bayes_auto_learn                   = true,
  $bayes_ignore_header                = [],
  $bayes_auto_expire                  = true,
  $bayes_sql_enabled                  = false,
  $bayes_sql_dsn                      = 'DBI:mysql:spamassassin',
  $bayes_sql_username                 = 'root',
  $bayes_sql_password                 = undef,
  $bayes_sql_override_username        = undef,
  $bayes_path                         = undef,
  # SQL based user preferences
  $user_scores_dsn                    = undef,
  $user_scores_sql_username           = undef,
  $user_scores_sql_password           = undef,
  $user_scores_sql_custom_query       = undef,
  # DCC plugin
  $dcc_enabled                        = false,
  $dcc_timeout                        = undef,
  $dcc_body_max                       = undef,
  $dcc_fuz1_max                       = undef,
  $dcc_fuz2_max                       = undef,
  # Pyzor plugin
  $pyzor_enabled                      = true,
  $pyzor_timeout                      = undef,
  $pyzor_max                          = undef,
  $pyzor_options                      = undef,
  $pyzor_path                         = undef,
  $pyzor_home                         = undef,
  # Razor plugin
  $razor_enabled                      = true,
  $razor_timeout                      = undef,
  $razor_home                         = undef,
  # Spamcop plugin
  $spamcop_enabled                    = false,
  $spamcop_from_address               = undef,
  $spamcop_to_address                 = undef,
  $spamcop_max_report_size            = undef,
  # Auto-whitelist plugin
  $awl_enabled                        = false,
  $awl_sql_enabled                    = false,
  $awl_dsn                            = 'DBI:mysql:spamassassin',
  $awl_sql_username                   = 'root',
  $awl_sql_password                   = undef,
  $awl_sql_override_username          = undef,
  $auto_whitelist_path                = undef,
  $auto_whitelist_file_mode           = undef,
  # Shortcircuit plugin
  $shortcircuit_enabled               = false,
  $shortcircuit_user_in_whitelist     = undef,
  $shortcircuit_user_in_def_whitelist = undef,
  $shortcircuit_user_in_all_spam_to   = undef,
  $shortcircuit_subject_in_whitelist  = undef,
  $shortcircuit_user_in_blacklist     = undef,
  $shortcircuit_user_in_blacklist_to  = undef,
  $shortcircuit_subject_in_blacklist  = undef,
  $shortcircuit_all_trusted           = undef,
  # DKIM plugin
  $dkim_enabled                       = true,
  $dkim_timeout                       = undef,
  # Rule2XSBody plugin
  $rules2xsbody_enabled               = false,
) {
  include spamassassin::params

  validate_bool($service_enabled)
  validate_bool($spamd_nouserconfig)
  validate_bool($spamd_allowtell)
  validate_bool($spamd_sql_config)
  validate_bool($clear_trusted_networks)
  validate_bool($clear_internal_networks)
  validate_bool($bayes_enabled)
  validate_bool($bayes_use_hapaxes)
  validate_bool($bayes_auto_learn)
  validate_bool($bayes_auto_expire)
  validate_bool($bayes_sql_enabled)
  validate_bool($skip_rbl_checks)
  validate_bool($dcc_enabled)
  validate_bool($pyzor_enabled)
  validate_bool($razor_enabled)
  validate_bool($spamcop_enabled)
  validate_bool($awl_enabled)
  validate_bool($awl_sql_enabled)
  validate_bool($shortcircuit_enabled)
  validate_bool($dkim_enabled)

  validate_hash($score_tests)

  validate_array($whitelist_from)
  validate_array($whitelist_to)
  validate_array($blacklist_from)
  validate_array($blacklist_to)
  validate_array($trusted_networks)
  validate_array($internal_networks)
  validate_array($bayes_ignore_header)

  validate_re("${spamd_max_children}", '^[1-9]([0-9]*)?$',
  'spamd_max_children parameter should be a number')

  if $spamd_min_children {
    validate_re("${spamd_min_children}", '^[1-9]([0-9]*)?$',
  'spamd_min_children parameter should be a number')
  }

  validate_re("${required_score}", '^[0-9]([0-9]*)?(\.[0-9]{1,2})?$',
  'required_score parameter should be an integer or real number.')

  validate_re($dns_available, '^(test|yes|no)$',
  'dns_available parameter must have a value of: test, yes or no')

  if $spamd_sql_config {
    validate_string($user_scores_dsn)
    validate_string($user_scores_sql_username)
    validate_string($user_scores_sql_password)
    validate_string($user_scores_sql_custom_query)
  }

  $final_skip_rbl_checks   = bool2num($skip_rbl_checks)
  $final_bayes_use_hapaxes = bool2num($bayes_use_hapaxes)
  $final_bayes_auto_learn  = bool2num($bayes_auto_learn)
  $final_bayes_auto_expire = bool2num($bayes_auto_expire)

  $final_razor_home = $razor_home ? {
    undef   => "${spamassassin::params::configdir}/.razor",
    default => $razor_home
  }
  validate_absolute_path($final_razor_home)

  $final_pyzor_home = $pyzor_home ? {
    undef   => "${spamassassin::params::configdir}/.pyzor",
    default => $pyzor_home,
  }
  validate_absolute_path($final_pyzor_home)

  case $::osfamily {
    'Debian' : {
      if $dkim_enabled {
        package { 'libmail-dkim-perl':
          ensure => installed,
        }
      }
      $razor_package = 'razor'
    }
    'RedHat' : {
      if $dkim_enabled {
        package { 'perl-Mail-DKIM':
          ensure => installed,
        }
      }
      $razor_package = 'perl-Razor-Agent'
    }
    default: {
        fail("${::operatingsystem} is not supported")
    }
  }

  package { 'spamassassin':
    ensure => installed,
  }

  if $run_execs_as_user {
    Exec {
      path => ['/bin', '/usr/bin'],
      user => $run_execs_as_user,
    }
  } else {
    Exec {
      path => ['/bin', '/usr/bin'],
    }
  }

  # Install and setup pyzor
  if $pyzor_enabled {
    package { 'pyzor':
      ensure   => installed,
      require  => Package['spamassassin'],
    }
    exec { 'pyzor_discover':
      command   => "/usr/bin/pyzor --homedir '${final_pyzor_home}' discover",
      unless    => "test -d ${final_pyzor_home}",
      require   => Package['pyzor'],
    }
  }

  # Install and setup razor
  if $razor_enabled {
    $razor_home_owner = $run_execs_as_user ? {
      undef   => 'root',
      default => $run_execs_as_user,
    }

    package { $razor_package:
      ensure   => installed,
      alias    => 'razor',
      require  => Package['spamassassin'],
    } ->
    file { $final_razor_home:
      ensure  => directory,
      owner   => $razor_home_owner,
      recurse => true,
    } ->
    exec { 'razor_register':
      command => "/usr/bin/razor-admin -home=${final_razor_home} -register",
      unless  => "test -h ${final_razor_home}/identity",
    } ->
    exec { 'razor_create':
      command   => "/usr/bin/razor-admin -home=${final_razor_home} -create",
      creates   => "${final_razor_home}/razor-agent.conf",
    } ->
    exec { 'razor_discover':
      command     => "/usr/bin/razor-admin -home=${final_razor_home} -discover",
      refreshonly => true,
    }
  }

  file {
    "${spamassassin::params::configdir}/local.cf":
      ensure  => present,
      content => template('spamassassin/local_cf.erb'),
      notify  => Service['spamassassin'],
      require => Package['spamassassin'];
    "${spamassassin::params::configdir}/v310.pre":
      ensure  => present,
      content => template('spamassassin/v310_pre.erb'),
      notify  => Service['spamassassin'],
      require => Package['spamassassin'];
    "${spamassassin::params::configdir}/v312.pre":
      ensure  => present,
      content => template('spamassassin/v312_pre.erb'),
      notify  => Service['spamassassin'],
      require => Package['spamassassin'];
    "${spamassassin::params::configdir}/v320.pre":
      ensure  => present,
      content => template('spamassassin/v320_pre.erb'),
      notify  => Service['spamassassin'],
      require => Package['spamassassin'];
  }

  if $spamd_sql_config {
    file { "${spamassassin::params::configdir}/sql.cf":
      ensure  => present,
      content => template('spamassassin/sql.cf.erb'),
      require => Package['spamassassin'],
    }
  }

  # Enable or explicitly disable sa-update cron.
  case $::osfamily {
      "Debian": {
          $cron = $sa_update ? {
            true    => 1,
            default => 0,
          }
          file_line { 'sa_update':
            path    => $spamassassin::params::sa_update_file,
            line    => "CRON=${cron}",
            match   => "^CRON=[0-1]$",
            require => Package['spamassassin']
          }
      }
      "Redhat": {
          $saupdate = $sa_update ? {
            true    => 'yes',
            default => 'no',
          }
          file_line { 'sa-update':
            path    => $spamassassin::params::sa_update_file,
            line    => "SAUPDATE=${saupdate}",
            match   => "^#?SAUPDATE=",
            require => Package['spamassassin']
          }
      }
  }

  if $::osfamily == 'Debian' {
    # We enable the service regardless of our service_enabled parameter. Trying to
    # stop or start the spamassassin init script without the enabled will fail.
    file_line { 'spamd_service' :
      path    => $spamassassin::params::spamd_options_file,
      line    => "ENABLED=1",
      match   => '^ENABLED',
      notify  => Service['spamassassin'],
      require => Package['spamassassin'],
    }
  }

  if $service_enabled {
    $extra_options = inline_template("<% if @spamd_username -%>-u <%= @spamd_username -%><% end -%> <% if @spamd_groupname -%>-g <%= @spamd_groupname -%><% end -%> -m <%= @spamd_max_children %><% if @spamd_min_children -%> --min-children=<%=@spamd_min_children -%><% end -%> -i <%= @spamd_listen_address %> -A <%= @spamd_allowed_ips %><% if @spamd_nouserconfig -%> --nouser-config<% end -%><% if @spamd_allowtell -%> --allow-tell<% end -%><% if @spamd_sql_config -%> -q<% end -%>")

    file_line { 'spamd_options' :
      path    => $spamassassin::params::spamd_options_file,
      line    => "${spamassassin::params::spamd_options_var}=\"${spamassassin::params::spamd_defaults} ${extra_options}\"",
      match   => "^${spamassassin::params::spamd_options_var}=",
      notify  => Service['spamassassin'],
      require => Package['spamassassin']
    }
  }

  service { 'spamassassin':
      ensure    => $service_enabled,
      enable    => $service_enabled,
      pattern   => 'spamd',
      require   => Package['spamassassin'],
  }
}
