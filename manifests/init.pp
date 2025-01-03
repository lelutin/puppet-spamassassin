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
# [*package_name*]
# String. The package name to use.
# Default: Distribution specific
#
# [*service_enabled*]
# Boolean. Will enable service at boot
# and ensure a running service.
#
# [*service_name*]
# String. The service name to use for the spamassassin service.
# Default: Distribution specific
#
# [*notify_service_name*]
# String. If specified then this service will be notified instead of "spamd"
# when config is update. Only has an effect if service_enabled is false.
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
# List of IP addresses spamd will listen to (defaults to "localhost",
# which will listen both on IPv4 and IPv6 locally). Use 0.0.0.0 to listen on
# all interfaces. You can also use a valid hostname which will make spamd
# listen on the first address that name resolves to. To listen only to an IPv6
# address, make sure to encase the address within square brackets (i.e.
# "[fe80::fc54:ff:fe8f:4b36]")
#
# [*spamd_allowed_ips*]
# Specify a list of authorized hosts or networks which can connect to this
# spamd instance. Values can be single IP addresses or CIDR format networks.
# Hostnames are not supported, only IP addresses. Similarly to
# spamd_listen_address, to specify IPs or CIDR notation for IPV6, make sure to
# encase the address or network part in square brackets)
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
# Note that by default `spamd_defaults` activates `--create-prefs` so you may
# want to revise that parameter if you set this option.
#
# [*spamd_allowtell*]
# Allow learning and forgetting (to a local Bayes database), reporting and
# revoking (to a remote database) by spamd. The client issues a TELL command
# to tell what type of message is being processed and whether local (learn/forget)
# or remote (report/revoke) databases should be updated.
#
# [*spamd_sql_config*]
# Turn on SQL lookups even when per-user config files have been disabled with -x
# this is useful for spamd hosts which dont have users home directories
# but do want to load user preferences from an SQL database.
#
# [*spamd_syslog_facility*]
# Turn this on to deposit logs for SpamAssassin and define the log location.
# e.g. /var/log/spamd.log
#
# [*configdir*]
# Absolute path to the directory containing spamassassin's configuration files.
#
# [*spamd_options_file*]
# Absolute path to the file containing global options to spamd.
#
# [*spamd_options_var*]
# Name of the shell variable used for storing spamd options in
# spamd_options_file.
#
# [*spamd_defaults*]
# String of spamd option flags set in spamd_options_file.
#
# [*sa_update_file*]
# Absolute path to file that contains shell variables for sa-update.
#
# [*required_score*]
# Set the score required before a mail is considered spam. n.nn can be an
# integer or a real number.
#
# [*score_tests*]
# Assign scores (the number of points for a hit) to a given test.
# Scores can be positive or negative real numbers or integers.
#
# [*custom_rules*]
# Define custom rules. This is a hash of hashes. The key for the outer hash is the
# spamassassin rule name, the inner hash for each entry should contain the rule definition, e.g:
#
# spamassassin::custom_rules:
#   INVOICE_SPAM:
#     body: '/Invoice.*from.*You have received an invoice from .* To start with it, print out or download a JS copy of your invoice/'
#     score: 6
#     describe: 'spam reported claiming "You have received an invoice"'
#
# [*custom_config*]
# Add custom lines to the config file. Useful for configuring modules that aren't otherwise
# handled by this Puppet module. This is an array of strings, e.g:
#
# spamassassin::custom_config:
#   - hashcash_accept *@example.com
#   - hashcash_accept *@example.net
#
# [*whitelist_from*]
# Used to whitelist sender addresses which send mail that is often
# tagged (incorrectly) as spam. This would be written to the global
# local.cf file
#
# [*whitelist_from_rcvd*]
# Used to whitelist the combination of a sender address and rDNS name/IP.
# This would be written to the global local.cf file
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
# [*add_header_spam*]
# Customise headers to be added to spam emails. Each array item should contain: header_name string.
#
# [*add_header_ham*]
# See add_header_spam.
#
# [*add_header_all*]
# See add_header_spam.
#
# [*remove_header_spam*]
# Remove headers from spam emails. Each array item should be a header_name to remove.
#
# [*remove_header_ham*]
# See remove_header_spam.
#
# [*remove_header_all*]
# See remove_header_spam.
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
# [*uridnsbl_skip_domain*]
# List of domains for which URIDNSBL tests should be skipped. This can be used
# to reduce the volume of URIBDNSBL checks, for example by disabling checks for
# known domains that get sent to very often.
#
# [*uridnsbl*]
# Specify a lookup. Each entry's key is the name of the rule to be used. The
# value should be an array with two items. The first item is the dnsbl zone to
# lookup IPs in, and the second item is the type of lookup to perform (TXT or
# A). Note that you must also define a body-eval rule calling check_uridnsbl()
# to use this.
#
# [*urirhsbl*]
# Specify a RHSBL-style domain lookup. Each entry's key is the name of the rule
# to be used. The value should be an array with two items. The first item is
# the dnsbl zone to lookup IPs in, and the second item is the type of lookup to
# perform (TXT or A).
#
# [*urirhssub*]
# Specify a RHSBL-style domain lookup with a sub-test. Each entry's key is the
# name of the rule to be used. The value should be an array with three items.
# The first item is the dnsbl zone to lookup IPs in. The second item is the
# type of lookup to perform (TXT or A). Finally, the third item is the sub-test
# to run against the returned data.
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
# Boolean. If true will write the SQL-related directives to local.cf.
# Default: false
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
# [*bayes_store_module*]
# This parameter configures the module that spamassassin will use when
# connecting to the Bayes SQL database. The default will work for most
# database types, but selecting the module for a DBMS may result provide
# performance improvements or additional features. Certain modules may
# require the additional perl modules that are not installed by this Puppet
# module.
#
# [*bayes_path*]
# This is the directory and filename for Bayes databases. Please note this
# parameter is not used if bayes_sql_enabled is true.
#
# [*bayes_file_mode*]
# The permissions that spamassassin will set to the bayes file that it may
# create.
#
# [*bayes_auto_learn_threshold_nonspam*]
# Score at which SA learns the message as ham.
#
# [*bayes_auto_learn_threshold_spam*]
# Score at which SA learns the message as spam.
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
# [*textcat_enabled*]
# Boolean. Enable/disable the TextCat plugin. Default: false
#
# [*ok_languages*]
# List of languages which are considered okay for incoming mail. If unset,
# defaults to accepting all languages.
# Default: ['all']
#
# [*ok_locales*]
# List of charsets that are permitted. If unset, defaults to accepting all
# locales.
# Default: ['all']
#
# [*normalize_charset*]
# Boolean. Enable/disable scanning non-UTF8 or non-ASCII parts to guess charset.
# Default: false
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
class spamassassin (
  Boolean          $sa_update         = false,
  Optional[String] $run_execs_as_user = undef,
  String           $package_name      = $spamassassin::params::package_name,
  # Spamd settings
  Boolean              $service_enabled      = false,
  String               $service_name         = $spamassassin::params::service_name,
  Optional[String]     $notify_service_name  = undef,
  Integer[1]           $spamd_max_children   = 5,
  Optional[Integer[1]] $spamd_min_children   = undef,
  Array[Stdlib::Host]  $spamd_listen_address = ['localhost'],
  Array[String]        $spamd_allowed_ips    = ['127.0.0.1/32','[::1]/8'],
  Optional[String]     $spamd_username       = undef,
  Optional[String]     $spamd_groupname      = undef,
  Boolean              $spamd_nouserconfig   = false,
  Boolean              $spamd_allowtell      = false,
  Boolean              $spamd_sql_config     = false,
  Optional[String]     $spamd_syslog_facility   = undef,
  Stdlib::Absolutepath $configdir          = $spamassassin::params::configdir,
  Stdlib::Absolutepath $spamd_options_file = $spamassassin::params::spamd_options_file,
  String               $spamd_options_var  = $spamassassin::params::spamd_options_var,
  String               $spamd_defaults     = $spamassassin::params::spamd_defaults,
  Stdlib::Absolutepath $sa_update_file     = $spamassassin::params::sa_update_file,
  # Scoring options, see Mail::SpamAssassin::Conf(3)
  Numeric              $required_score     = 5,
  Hash                 $score_tests        = {},
  # Whitelist and blacklist options, see Mail::SpamAssassin::Conf(3)
  Array $whitelist_from      = [],
  Array $whitelist_from_rcvd = [],
  Array $whitelist_to        = [],
  Array $blacklist_from      = [],
  Array $blacklist_to        = [],
  # Message tagging options, see Mail::SpamAssassin::Conf(3)
  Optional[String] $rewrite_header_subject = undef,
  Optional[String] $rewrite_header_from    = undef,
  Optional[String] $rewrite_header_to      = undef,
  Integer[0,2]     $report_safe            = 0,
  Array            $add_header_spam        = [],
  Array            $add_header_ham         = [],
  Array            $add_header_all         = [],
  Array            $remove_header_spam     = [],
  Array            $remove_header_ham      = [],
  Array            $remove_header_all      = [],
  # Network test options, see Mail::SpamAssassin::Conf(3)
  Boolean                    $clear_trusted_networks  = false,
  Array                      $trusted_networks        = [],
  Boolean                    $clear_internal_networks = false,
  Array                      $internal_networks       = [],
  Boolean                    $skip_rbl_checks         = true,
  Pattern[/^(test|yes|no)$/] $dns_available           = 'yes',
  # URIBL options, see Mail::SpamAssassin::Plugin::URIDNSBL(3)
  Array[String]                   $uridnsbl_skip_domain = [],
  Hash[String, Array[String,2,2]] $uridnsbl             = {},
  Hash[String, Array[String,2,2]] $urirhsbl             = {},
  Hash[String, Array[String,3,3]] $urirhssub            = {},
  # Learning options, see Mail::SpamAssassin::Conf(3)
  Boolean                        $bayes_enabled                      = true,
  Boolean                        $bayes_use_hapaxes                  = true,
  Boolean                        $bayes_auto_learn                   = true,
  Array                          $bayes_ignore_header                = [],
  Boolean                        $bayes_auto_expire                  = true,
  Boolean                        $bayes_sql_enabled                  = false,
  String                         $bayes_sql_dsn                      = 'DBI:mysql:spamassassin',
  String                         $bayes_sql_username                 = 'root',
  Optional[String]               $bayes_sql_password                 = undef,
  Optional[String]               $bayes_sql_override_username        = undef,
  String                         $bayes_store_module                 = 'Mail::SpamAssassin::BayesStore::SQL',
  Optional[Stdlib::Absolutepath] $bayes_path                         = undef,
  Optional[String]               $bayes_file_mode                    = undef,
  Optional[Float]                $bayes_auto_learn_threshold_nonspam = undef,
  Optional[Float]                $bayes_auto_learn_threshold_spam    = undef,
  # SQL based user preferences, see Mail::SpamAssassin::Conf(3)
  Optional[String] $user_scores_dsn              = undef,
  Optional[String] $user_scores_sql_username     = undef,
  Optional[String] $user_scores_sql_password     = undef,
  Optional[String] $user_scores_sql_custom_query = undef,
  # DCC plugin, see Mail::SpamAssassin::Plugin::DCC(3)
  Boolean $dcc_enabled            = false,
  Optional[Integer] $dcc_timeout  = undef,
  Optional[Integer] $dcc_body_max = undef,
  Optional[Integer] $dcc_fuz1_max = undef,
  Optional[Integer] $dcc_fuz2_max = undef,
  # Pyzor plugin, see Mail::SpamAssassin::Plugin::Pyzor(3)
  Boolean                                   $pyzor_enabled = true,
  # TODO: add a pattern to pyzor_timeout to allow strings with an int/float
  #   value with an suffix of s, m, h, d, w
  Optional[Numeric]                         $pyzor_timeout = undef,
  Optional[Integer]                         $pyzor_max     = undef,
  Optional[Pattern[/[0-9A-Za-z ,._\/-]\+/]] $pyzor_options = undef,
  Optional[Stdlib::Absolutepath]            $pyzor_path    = undef,
  Stdlib::Absolutepath                      $pyzor_home    = $spamassassin::params::pyzor_home,
  # Razor plugin, see Mail::SpamAssassin::Plugin::Razor2(3)
  Boolean              $razor_enabled = true,
  Optional[Integer]    $razor_timeout = undef,
  Stdlib::Absolutepath $razor_home    = $spamassassin::params::razor_home,
  # Spamcop plugin, see Mail::SpamAssassin::Plugin::SpamCop(3)
  Boolean           $spamcop_enabled         = false,
  Optional[String]  $spamcop_from_address    = undef,
  Optional[String]  $spamcop_to_address      = undef,
  Optional[Integer] $spamcop_max_report_size = undef,
  # Auto-whitelist plugin, see Mail::SpamAssassin::AutoWhitelist(3)
  Boolean          $awl_enabled               = false,
  Boolean          $awl_sql_enabled           = false,
  String           $awl_dsn                   = 'DBI:mysql:spamassassin',
  String           $awl_sql_username          = 'root',
  Optional[String] $awl_sql_password          = undef,
  Optional[String] $awl_sql_override_username = undef,
  Optional[String] $auto_whitelist_path       = undef,
  Optional[String] $auto_whitelist_file_mode  = undef,
  # Language guessing plugin, see Mail::SpamAssassin::Plugin::TextCat(3)
  Boolean       $textcat_enabled   = false,
  Array[String] $ok_languages      = ['all'],
  Array[String] $ok_locales        = ['all'],
  Boolean       $normalize_charset = false,
  # Shortcircuit plugin, see Mail::SpamAssassin::Plugin::Shortcircuit(3)
  Boolean                       $shortcircuit_enabled               = false,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_user_in_whitelist     = undef,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_user_in_def_whitelist = undef,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_user_in_all_spam_to   = undef,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_subject_in_whitelist  = undef,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_user_in_blacklist     = undef,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_user_in_blacklist_to  = undef,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_subject_in_blacklist  = undef,
  Optional[Enum['ham','spam','on','off']] $shortcircuit_all_trusted           = undef,
  # DKIM plugin, see Mail::SpamAssassin::Plugin::DKIM(3)
  Boolean           $dkim_enabled = true,
  Optional[Integer] $dkim_timeout = undef,
  # Rule2XSBody plugin
  Boolean $rules2xsbody_enabled = false,
  # custom rules
  Hash $custom_rules = {},
  Array[String] $custom_config                                                = [],
) inherits spamassassin::params {
  if $spamd_sql_config and (
    $user_scores_dsn !~ String
    or $user_scores_sql_username !~ String
    or $user_scores_sql_password !~ String
  ) {
    fail('spamd_sql_config is enabled but one or more of $user_scores_* not set')
  }

  contain spamassassin::install
  contain spamassassin::config
  contain spamassassin::service

  Class['spamassassin::install']
  -> Class['spamassassin::config']
  ~> Class['spamassassin::service']
}
