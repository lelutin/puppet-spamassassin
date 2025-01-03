# @summary This module installs and configures spamassassin and a few of its
#   plugins.
#
# For examples, see tests folder.
#
# @author Scott Barr <gsbarr@gmail.com>
#
# @see https://spamassassin.apache.org/full/4.0.x/doc/
#
#
# @param sa_update
#   Enable the sa-update cron job.
# @param run_execs_as_user
#   If you enabled razor and/or pyzor and would like the razor-admin or pyzor
#   discover commands to be run as a different user specify the username in this
#   directive. Example: `amavis`
# @param package_name
#   The package name to use. Default is distribution-specific
#
# @param service_enabled
#   Will enable service at boot and ensure a running service.
# @param service_name
#   The service name to use for the spamassassin service. Default is
#   distribution-specific
# @param notify_service_name
#   If specified then this service will be notified instead of "spamd" when
#   config is update. Only has an effect if service_enabled is false.
# @param spamd_max_children
#   The maximum number of children to spawn. Spamd will spawn that number of
#   children, then sleep in the background until a child dies, wherein it will
#   go and spawn a new child.
# @param spamd_min_children
#   The minimum number of children that will be kept running. The minimum
#   possible value is 1, the default value is 1 in spamd, and undef here. If you have lots of
#   free RAM, you may want to increase this.
# @param spamd_listen_address
#   List of IP addresses spamd will listen to (defaults to "localhost", which
#   will listen both on IPv4 and IPv6 locally). Use 0.0.0.0 to listen on all
#   interfaces. You can also use a valid hostname which will make spamd listen
#   on the first address that name resolves to. To listen only to an IPv6
#   address, make sure to encase the address within square brackets (i.e.
#   "[fe80::fc54:ff:fe8f:4b36]")
# @param spamd_allowed_ips
#   Specify a list of authorized hosts or networks which can connect to this
#   spamd instance. Values can be single IP addresses or CIDR format networks.
#   Hostnames are not supported, only IP addresses. Similarly to
#   `spamd_listen_address`, to specify IPs or CIDR notation for IPV6, make sure
#   to encase the address or network part in square brackets)
# @param spamd_username
#   spamd runs as this user
# @param spamd_groupname
#   spamd runs in this group
# @param spamd_nouserconfig
#   Turn off (on) reading of per-user configuration files (user_prefs) from the
#   user's home directory. The default behaviour is to read per-user
#   configuration from the user's home directory (`--user-config`/`-c`).
#   Note that by default `spamd_defaults` activates `--create-prefs` so you may
#   want to revise that parameter if you set this option.
# @param spamd_allowtell
#   Allow learning and forgetting (to a local Bayes database), reporting and
#   revoking (to a remote database) by spamd. The client issues a TELL command
#   to tell what type of message is being processed and whether local
#   (learn/forget) or remote (report/revoke) databases should be updated.
# @param spamd_sql_config
#   Turn on SQL lookups even when per-user config files have been disabled with
#   `-x` this is useful for spamd hosts which dont have users home directories
#   but do want to load user preferences from an SQL database.
# @param spamd_syslog_facility
#   Turn this on to deposit logs for SpamAssassin and define the log location.
#   e.g. `/var/log/spamd.log`
# @param configdir
#   Absolute path to the directory containing spamassassin's configuration files.
# @param spamd_options_file
#   Absolute path to the file containing global options to spamd.
# @param spamd_options_var
#   Name of the shell variable used for storing spamd options in
#   `spamd_options_file`.
# @param spamd_defaults
#   String of spamd option flags set in `spamd_options_file`. If you change some
#   parameters you may need to revise those deamon flags.
# @param sa_update_file
#   Absolute path to file that contains shell variables for sa-update.
#
# @param required_score
#   Set the score required before a mail is considered spam. Can be an integer
#   or a floating-point number.
# @param score_tests
#   Assign scores (the number of points for a hit) to a given test. Scores can
#   be positive or negative real numbers or integers.
#
# @param whitelist_from
#   Used to whitelist sender addresses which send mail that is often tagged
#   (incorrectly) as spam. This would be written to the global `local.cf` file
# @param whitelist_from_rcvd
#   Used to whitelist the combination of a sender address and rDNS name/IP. This
#   would be written to the global `local.cf` file
# @param whitelist_to
#   If the given address appears as a recipient in the message headers
#   (Resent-To, To, Cc, obvious envelope recipient, etc.) the mail will be
#   whitelisted.
# @param blacklist_from
#   Used to specify addresses which send mail that is often tagged (incorrectly)
#   as non-spam, but which the user doesn't want.
# @param blacklist_to
#   If the given address appears as a recipient in the message headers
#   (Resent-To, To, Cc, obvious envelope recipient, etc.) the mail will be
#   blacklisted.
#
# @param rewrite_header_subject
#   By default, suspected spam messages will not have the Subject, From or To
#   lines tagged to indicate spam. By setting this option, the header will be
#   tagged with the value of the parameter to indicate that a message is spam.
# @param rewrite_header_from
#   See `rewrite_header_subject`.
# @param rewrite_header_to
#   See `rewrite_header_subject`.
# @param report_safe
#   See: https://spamassassin.apache.org/full/4.0.x/doc/Mail_SpamAssassin_Conf.html#report_safe-0-1-2-default:-1
# @param add_header_spam
#   Customise headers to be added to spam emails. Each array item should
#   contain: `header_name` string.
# @param add_header_ham
#   See `add_header_spam`.
# @param add_header_all
#   See `add_header_spam`.
# @param remove_header_spam
#   Remove headers from spam emails. Each array item should be a `header_name`
#   to remove.
# @param remove_header_ham
#   See `remove_header_spam`.
# @param remove_header_all
#   See `remove_header_spam`.
#
# @param clear_trusted_networks
#   Empty the list of trusted networks.
# @param trusted_networks
#   What networks or hosts are 'trusted' in your setup. Trusted in this case
#   means that relay hosts on these networks are considered to not be
#   potentially operated by spammers, open relays, or open proxies.
# @param clear_internal_networks
#   Empty the list of internal networks.
# @param internal_networks
#   Internal means that relay hosts on these networks are considered to be MXes
#   for your domain(s), or internal relays.
# @param skip_rbl_checks
#   If false SpamAssassin will run RBL checks.
# @param dns_available
#   If set to 'test', SpamAssassin will query some default hosts on the internet
#   to attempt to check if DNS is working or not.
#
# @param uridnsbl_skip_domain
#   List of domains for which URIDNSBL tests should be skipped. This can be used
#   to reduce the volume of URIBDNSBL checks, for example by disabling checks
#   for known domains that get sent to very often.
# @param uridnsbl
#   Specify a lookup. Each entry's key is the name of the rule to be used. The
#   value should be an array with two items. The first item is the dnsbl zone to
#   lookup IPs in, and the second item is the type of lookup to perform (TXT or
#   A). Note that you must also define a body-eval rule calling check_uridnsbl()
#   to use this.
# @param urirhsbl
#   Specify a RHSBL-style domain lookup. Each entry's key is the name of the
#   rule to be used. The value should be an array with two items. The first item
#   is the dnsbl zone to lookup IPs in, and the second item is the type of
#   lookup to perform (TXT or A).
# @param urirhssub
#   Specify a RHSBL-style domain lookup with a sub-test. Each entry's key is the
#   name of the rule to be used. The value should be an array with three items.
#   The first item is the dnsbl zone to lookup IPs in. The second item is the
#   type of lookup to perform (TXT or A). Finally, the third item is the
#   sub-test to run against the returned data.
#
# @param bayes_enabled
#   Whether to use the naive-Bayesian-style classifier built into SpamAssassin.
# @param bayes_use_hapaxes
#   Should the Bayesian classifier use hapaxes (words/tokens that occur only
#   once) when classifying? This produces significantly better hit-rates, but
#   increases database size by about a factor of 8 to 10.
# @param bayes_auto_learn
#   Whether SpamAssassin should automatically feed high-scoring mails into its
#   learning systems.
# @param bayes_ignore_header
#   List of email header names that spamd should ignore.
#   See https://spamassassin.apache.org/full/4.0.x/doc/Mail_SpamAssassin_Conf.html#bayes_ignore_header-header_name
# @param bayes_auto_expire
#   If enabled, the Bayes system will try to automatically expire old tokens
#   from the database.
# @param bayes_sql_enabled
#   If true will write the SQL-related directives to `local.cf`.
# @param bayes_sql_dsn
#   This parameter gives the connect string used to connect to the SQL based
#   Bayes storage. By default will use the mysql driver and a database called
#   spamassassin. Please note the module does not manage any database settings
#   or the creation of the schema.
# @param bayes_sql_username
#   The sql username used for the dsn provided above.
# @param bayes_sql_password
#   The sql password used for the dsn provided above.
# @param bayes_sql_override_username
#   If this options is set the BayesStore::SQL module will override the set
#   username with the value given. This could be useful for implementing global
#   or group bayes databases.
# @param bayes_store_module
#   This parameter configures the module that spamassassin will use when
#   connecting to the Bayes SQL database. The default will work for most
#   database types, but selecting the module for a DBMS may result provide
#   performance improvements or additional features. Certain modules may require
#   the additional perl modules that are not installed by this Puppet module.
# @param bayes_path
#   This is the directory and filename for Bayes databases. Please note this
#   parameter is not used if `bayes_sql_enabled` is true.
# @param bayes_file_mode
#   The permissions that spamassassin will set to the bayes file that it may
#   create.
# @param bayes_auto_learn_threshold_nonspam
#   Score at which SA learns the message as ham.
# @param bayes_auto_learn_threshold_spam
#   Score at which SA learns the message as spam.
#
# @param user_scores_dsn
#   The perl DBI DSN string used to specify the SQL server holding user config.
#   Example: 'DBI:mysql:dbname:hostname
# @param user_scores_sql_username
#   The SQL username to connect to the above server.
# @param user_scores_sql_password
#   The SQL password for the above user.
# @param user_scores_sql_custom_query
#   Custom SQL query to use for spamd user_prefs.
#
# @param dcc_enabled
#   Enable/disable the DCC plugin.
# @param dcc_timeout
#   How many seconds you wait for DCC to complete, before scanning continues
#   without the DCC results. If left undef, spamd uses its default value of 5
# @param dcc_body_max
#   This option sets how often a message's body/fuz1/fuz2 checksum must have
#   been reported to the DCC server before SpamAssassin will consider the DCC
#   check as matched. As nearly all DCC clients are auto-reporting these
#   checksums, you should set this to a relatively high value, e.g. 999999 (this
#   is DCC's MANY count). If left undef, spamd uses its default value of 999999
# @param dcc_fuz1_max
#   See `dcc_body_max`. If left undef, spamd uses its default value of 999999
# @param dcc_fuz2_max
#   See `dcc_body_max`. If left undef, spamd uses its default value of 999999
#
# @param pyzor_enabled
#   Enable/disable the Pyzor plugin.
# @param pyzor_timeout
#   How many seconds you wait for Pyzor to complete, before scanning continues
#   without the Pyzor results. If left undef, spamd uses its default of 5
# @param pyzor_max
#   This option sets how often a message's body checksum must have been reported
#   to the Pyzor server before SpamAssassin will consider the Pyzor check as
#   matched. Note that this option has been renamed to `pyzor_count_min` in
#   spamassassin 4.0.x. If left undefined, spamd will use its default of 5.
# @param pyzor_options
#   Specify additional options to the pyzor command. Please note that only
#   characters in the range `[0-9A-Za-z ,._/-]` are allowed for security reasons.
#   Please note that the module will automatically add the homedir options as
#   part of the configuration.
# @param pyzor_path
#   This option tells SpamAssassin specifically where to find the pyzor client
#   instead of relying on SpamAssassin to find it in the current PATH.
# @param pyzor_home
#   Define the homedir for pyzor. Default is to use the [global config dir]/.pyzor
#
# @param razor_enabled
#   Enable/disable the Razor2 plugin.
# @param razor_timeout
#   How many seconds you wait for Razor to complete before you go on without the
#   results. If left undefined, spamd will use its default of 5
# @param razor_home
#   Define the homedir for razor. Please note that if you set a custom path the
#   module will automatically use the directory in which you store your razor
#   config as the home directory for the module. Default is to use the [global
#   config dir]/.razor
#
# @param spamcop_enabled
#   Enable/disable the Pyzor plugin.
# @param spamcop_from_address
#   This address is used during manual reports to SpamCop as the From: address.
#   You can use your normal email address. If this is not set, a guess will be
#   used as the From: address in SpamCop reports.
# @param spamcop_to_address
#   Your customized SpamCop report submission address. You need to obtain this
#   address by registering at http://www.spamcop.net/. If this is not set,
#   SpamCop reports will go to a generic reporting address for SpamAssassin
#   users and your reports will probably have less weight in the SpamCop system.
# @param spamcop_max_report_size
#   Messages larger than this size (in kilobytes) will be truncated in report
#   messages sent to SpamCop. The default setting is the maximum size that
#   SpamCop will accept at the time of release. If left undefined, spamd uses
#   its default of 50
#
# @param awl_enabled
#   Enable/disable the Auto-Whitelist plugin.
# @param awl_sql_enabled
#   If true will set auto_whitelist_factory to use sql and will write the sql
#   dsn, and other directives, to local.cf.
# @param awl_dsn
#   This parameter gives the connect string used to connect to the SQL based
#   storage. By default will use the mysql driver and a database called
#   spamassassin. Please note the module does not manage any database settings
#   or the creation of the schema.
# @param awl_sql_username
#   The sql username used for the dsn provided above.
# @param awl_sql_password
#   The sql password used for the dsn provided above.
# @param awl_sql_override_username
#   Used by the SQLBasedAddrList storage implementation. If this option is set
#   the SQLBasedAddrList module will override the set username with the value
#   given. This can be useful for implementing global or group based
#   auto-whitelist databases.
# @param auto_whitelist_path
#   This is the automatic-welcomelist directory and filename. By default, each
#   user has their own welcomelist database in their ~/.spamassassin directory
#   with mode 0700. For system-wide SpamAssassin use, you may want to share this
#   across all users, although that is not recommended. If left undefined, spamd
#   will use its default value of `~/.spamassassin/auto-whitelist`. Note that
#   the option was renamed to `auto_welcomelist_path` in spamassassin 4.0.x
# @param auto_whitelist_file_mode
#   The file mode bits used for the automatic-whitelist directory or file. Make
#   sure you specify this using the 'x' mode bits set, as it may also be used to
#   create directories. However, if a file is created, the resulting file will
#   not have any execute bits set (the umask is set to 0111). If left undefined,
#   spamd will use its default of `0700`. Note that this option was renamed to
#   `auto_welcomelist_file_mode` in spamassassin 4.0.x
#
# @param textcat_enabled
#   Enable/disable the TextCat plugin.
# @param ok_languages
#   List of languages which are considered okay for incoming mail. If unset,
#   defaults to accepting all languages.
# @param ok_locales
#   List of charsets that are permitted. If unset, defaults to accepting all
#   locales.
# @param normalize_charset
#   Enable/disable scanning non-UTF8 or non-ASCII parts to guess charset.
#
# @param shortcircuit_enabled
#   Enable/disable the Shortcircuit plugin.
# @param shortcircuit_user_in_whitelist
#   Values: ham, spam, on or off.
# @param shortcircuit_user_in_def_whitelist
#   Values: ham, spam, on or off.
# @param shortcircuit_user_in_all_spam_to
#   Values: ham, spam, on or off.
# @param shortcircuit_subject_in_whitelist
#   Values: ham, spam, on or off.
# @param shortcircuit_user_in_blacklist
#   Values: ham, spam, on or off.
# @param shortcircuit_user_in_blacklist_to
#   Values: ham, spam, on or off.
# @param shortcircuit_subject_in_blacklist
#   Values: ham, spam, on or off.
# @param shortcircuit_all_trusted
#   Values: ham, spam, on or off.
#
# @param dkim_enabled
#   Enable/disable the DKIM plugin.
# @param dkim_timeout
#   How many seconds to wait for a DKIM query to complete, before scanning
#   continues without the DKIM result. If left undefined, spamd will use its
#   default value of 3.5
#
# @param rules2xsbody_enabled
#   Enable the Rule2XSBody plugin. Compile ruleset to native code with
#   sa-compile. Requires re2c and gcc packages (not managed in this module)
#
# @param custom_rules
#   Define custom rules. This is a hash of hashes. The key for the outer hash is
#   the spamassassin rule name, the inner hash for each entry should contain the
#   rule definition, e.g:
#
#     spamassassin::custom_rules:
#       INVOICE_SPAM:
#         body: '/Invoice.*from.*You have received an invoice from .* To start with it, print out or download a JS copy of your invoice/'
#         score: 6
#         describe: 'spam reported claiming "You have received an invoice"'
# @param custom_config
#   Add custom lines to the config file. Useful for configuring modules that
#   aren't otherwise handled by this Puppet module. This is an array of strings,
#   e.g:
#
#     spamassassin::custom_config:
#       - hashcash_accept *@example.com
#       - hashcash_accept *@example.net
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
