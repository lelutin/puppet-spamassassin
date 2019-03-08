# Spamassassin

![Build Status](https://img.shields.io/bitbucket/pipelines/wyrie/puppet-spamassassin.svg)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with spamassassin](#setup)
    * [What spamassassin affects](#what-spamassassin-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with spamassassin](#beginning-with-spamassassin)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs, configures and manages spamassassin either as a service (through spamd) or for use with applications like amavisd.

## Module Description

Spamassassin has a huge array of configuration directives, this module tries to give the user access to as many of them as possible. There are a lot of class
parameters and most of them have a brief description of it's function in the header of the class file. For more information see: http://spamassassin.apache.org/full/3.3.x/doc/Mail_SpamAssassin_Conf.html

## Setup

### What spamassassin affects

* spamassassin package.
* spamassassin configuration files: local.cf, v310.cf, v312.cf, v320.cf and sql.cf (optional).
* spamassassin service (optional).
* optional packages: razor, pyzor and dkim.

### Setup Requirements

On Redhat systems, if you enable razor and/or pyzor, the packages need to come from  EPEL, which is not managed by this module. See https://forge.puppetlabs.com/stahnma/epel.

The installation of the DCC plugin, if enabled, needs to be handled elsewhere.
	
### Beginning with spamassassin	

Minimal usage for spamd

```
class { 'spamassassin':
  sa_update       => true,
  service_enabled => true,
}
```
Use with amavis

```
class { 'spamassassin':
  sa_update         => true,
  run_execs_as_user => 'amavis',
  service_enabled   => false,
  bayes_path        => '/var/lib/amavis/bayes'
  razor_home        => '/var/lib/amavis/.razor',
  pyzor_home        => '/var/lib/amavis/.pyzor',
}
```

## Usage

### Override the default score values.

```puppet
class { 'spamassassin':
  score_tests => {
    'BAYES_00'           => '-1.9',
    'HTML_IMAGE_ONLY_28' => '1.40',
  },
}
```

### Whitelist or blacklist some addresses

```puppet
class { 'spamassassin':
  whitelist_from      => ['*@abccorp.com', '*@abc.com'],
  whitelist_from_rcvd => ['*@abccorp.com mail.abccorp.com'],
  whitelist_to        => ['bob@gmail.com','sarah@yahoo.co.uk'],
  blacklist_from      => ['*@msn.com','*@hotmail.com'],
  blacklist_to        => ['frank@spammer.com', 'rita@example.com'],
}
```

### SQL based options

```puppet
class { 'spamassassin':
  bayes_sql_enabled            => true,
  bayes_sql_dsn                => 'DBI:mysql:spamassassin:localhost:3306',
  bayes_sql_username           => 'sqluser',
  bayes_sql_password           => 'somesecret',
  bayes_sql_override_username  => 'amavis',
  user_scores_dsn              => 'DBI:mysql:spamassassin:localhost:3306',
  user_scores_sql_username     => 'sqluser',
  user_scores_sql_password     => 'somesecret',
  awl_enabled                  => true,
  awl_sql_enabled              => true,
  awl_dsn                      => 'DBI:mysql:spamassassin',
  awl_sql_username             => 'sqluser',
  awl_sql_password             => 'somesecret',
}
```

### Misc options

```puppet
class { 'spamassassin':
  rewrite_header_subject             => '***SPAM***',
  report_safe                        => 2,
  trusted_networks                   => ['192.168.0.0/24'],
  skip_rbl_checks                    => false,
  dns_available                      => 'test',
  bayes_ignore_header                => ['X-Spam-Flag','X-Spam-Status'],
  spamcop_enabled                    => true,
  spamcop_from_address               => 'me@mydomain.com',
  spamcop_max_report_size            => 100,
  awl_enabled                        => true,
  shortcircuit_enabled               => true,
  shortcircuit_user_in_whitelist     => 'on',
  shortcircuit_user_in_def_whitelist => 'on',
  shortcircuit_user_in_blacklist     => 'on',
  dkim_timeout                       => 10,
  razor_timeout                      => 10,
  pyzor_timeout                      => 10,
}
```

## Reference

### Classes

#### Public Classes

* spamassassin: Main class, includes all other classes.

#### Private Classes

* spamassassin::params: Default values.

### Parameters

The following parameters are available in the spamassassin module:

#### `sa_update`
Boolean. Enable the sa-update cron job.
Default: false

#### `run_execs_as_user`
If you enabled razor and/or pyzor and would
like the razor-admin or pyzor discover commands
to be run as a different user specify the username
in this directive. Example: amavis. Default: undef

#### `service_enable`
Boolean. Will enable service at boot
and ensure a running service.

#### `spamd_max_children`
This option specifies the maximum number of children to spawn.
Spamd will spawn that number of children, then sleep in the background
until a child dies, wherein it will go and spawn a new child.

#### `spamd_min_children`
The minimum number of children that will be kept running
The minimum value is 1, the default value is 1 in spamd, and undef here.
If you have lots of free RAM, you may want to increase this.

#### `spamd_listen_address`
Tells spamd to listen on the specified IP address (defaults to 127.0.0.1).
Use 0.0.0.0to listen on all interfaces. You can also use a  valid hostname
which will make spamd listen on the first address that name resolves to.

#### `spamd_allowed_ips`
Specify a list of authorized hosts or networks which can connect to this
spamd instance. Single IP addresses, CIDR format networks, or ranges of
IP addresses by listing 3 or less octets with a trailing dot. Hostnames
are not supported, only IP addresses.  This option can be specified
multiple times, or can take a list of addresses separated by commas.

#### `spamd_username`
spamd runs as this user

#### `spamd_groupname`
spamd runs in this group

#### `spamd_nouserconfig`
Turn off (on) reading of per-user configuration files (user_prefs) from
the user's home directory. The default behaviour is to read per-user
configuration from the user's home directory (--user-config).

#### `spamd_allowtell`
Allow learning and forgetting (to a local Bayes database), reporting and
revoking (to a remote database) by spamd. The client issues a TELL command
to tell what type of message is being processed and whether local (learn/forget)
or remote (report/revoke) databases should be updated.

#### `spamd_sql_config`
Turn on SQL lookups even when per-user config files have been disabled with -x
this is useful for spamd hosts which don’t have user’s home directories
but do want to load user preferences from an SQL database.

#### `required_score`
Set the score required before a mail is considered spam. n.nn can be an
integer or a real number.

#### `score_tests`
Assign scores (the number of points for a hit) to a given test.
Scores can be positive or negative real numbers or integers.

#### `whitelist_from`
Used to whitelist sender addresses which send mail that is often
tagged (incorrectly) as spam. This would be written to the global
local.cf file

#### `whitelist_from_rcvd`
Used to whitelist the combination of a sender address and rDNS name/IP.
This would be written to the global local.cf file

#### `whitelist_to`
If the given address appears as a recipient in the message headers
(Resent-To, To, Cc, obvious envelope recipient, etc.) the mail will
be whitelisted.

#### `blacklist_from`
Used to specify addresses which send mail that is often
tagged (incorrectly) as non-spam, but which the user doesn't want.

#### `blacklist_to`
If the given address appears as a recipient in the message headers
(Resent-To, To, Cc, obvious envelope recipient, etc.) the mail will
be blacklisted.

#### `rewrite_header_subject`
By default, suspected spam messages will not have the Subject, From
or To lines tagged to indicate spam. By setting this option, the header
will be tagged with the value of the parameter to indicate that a message
is spam.

#### `rewrite_header_from`
See rewrite_header_subject.

#### `rewrite_header_to`
See rewrite_header_subject.

#### `report_safe`
Values: 0,1 or 2.
See: http://spamassassin.apache.org/full/3.3.x/doc/Mail_SpamAssassin_Conf.html#report_safe
Default: 0

#### `clear_trusted_networks`
Boolean. Empty the list of trusted networks. Default: false

#### `trusted_networks`
What networks or hosts are 'trusted' in your setup. Trusted in this case means
that relay hosts on these networks are considered to not be potentially operated
by spammers, open relays, or open proxies.

#### `clear_internal_networks`
Boolean. Empty the list of internal networks. Default: false

#### `internal_networks`
Internal means that relay hosts on these networks are considered
to be MXes for your domain(s), or internal relays.

#### `skip_rbl_checks`
Boolean. If false SpamAssassin will run RBL checks. Default: true

#### `dns_available`
If set to 'test', SpamAssassin will query some default hosts on the
internet to attempt to check if DNS is working or not. Default: yes

#### `bayes_enabled`
Boolean. Whether to use the naive-Bayesian-style classifier built
into SpamAssassin. Default: true

#### `bayes_use_hapaxes`
Boolean. Should the Bayesian classifier use hapaxes (words/tokens that occur
only once) when classifying? This produces significantly better hit-rates,
but increases database size by about a factor of 8 to 10. Default: true

#### `bayes_auto_learn`
Boolean. Whether SpamAssassin should automatically feed high-scoring mails
into its learning systems. Default: true

#### `bayes_ignore_header`
See http://spamassassin.apache.org/full/3.3.x/doc/Mail_SpamAssassin_Conf.html#bayes_ignore_header

#### `bayes_auto_expire`
Boolean. If enabled, the Bayes system will try to automatically expire old
tokens from the database. Default: true

#### `bayes_sql_enabled`
Boolean. If true will set bayes_store_module to use sql and will write the
sql dsn, and other directives, to local.cf. Default: false

#### `bayes_sql_dsn`
This parameter gives the connect string used to connect to the SQL based
Bayes storage. By default will use the mysql driver and a database called
spamassassin. Please note the module does not manage any database settings
or the creation of the schema.

#### `bayes_sql_username`
The sql username used for the dsn provided above.

#### `bayes_sql_password`
The sql password used for the dsn provided above.

#### `bayes_sql_override_username`
If this options is set the BayesStore::SQL module will override the set
username with the value given. This could be useful for implementing global
or group bayes databases.

#### `bayes_path`
This is the directory and filename for Bayes databases. Please note this
parameter is not used if bayes_sql_enabled is true.

#### `user_scores_dsn`
The perl DBI DSN string used to specify the SQL server holding user config
example: 'DBI:mysql:dbname:hostname

#### `user_scores_sql_username`
The SQL username to connect to the above server

#### `user_scores_sql_password`
The SQL password for the above user

#### `user_scores_sql_custom_query`
Custom SQL query to use for spamd user_prefs.

#### `dcc_enabled`
Boolean. Enable/disable the DCC plugin. Default: false

#### `dcc_timeout`
How many seconds you wait for DCC to complete,
before scanning continues without the DCC results. Default: 8

#### `dcc_body_max`
This option sets how often a message's body/fuz1/fuz2 checksum
must have been reported to the DCC server before SpamAssassin
will consider the DCC check as matched. As nearly all DCC clients
are auto-reporting these checksums, you should set this to a relatively
high value, e.g. 999999 (this is DCC's MANY count). Default: 999999

#### `dcc_fuz1_max`
See dcc_body_max. Default: 999999

#### `dcc_fuz2_max`
See dcc_body_max. Default: 999999

#### `pyzor_enabled`
Boolean. Enable/disable the Pyzor plugin. Default: true

#### `pyzor_timeout`
How many seconds you wait for Pyzor to complete, before scanning continues
without the Pyzor results. Default: 3.5

#### `pyzor_max`
This option sets how often a message's body checksum must have been reported
to the Pyzor server before SpamAssassin will consider the Pyzor check as matched.
Default: 5

#### `pyzor_options`
Specify additional options to the pyzor command. Please note that only characters
in the range [0-9A-Za-z ,._/-] are allowed for security reasons. Please note that
the module will automatically add the homedir options as part of the configuration.

#### `pyzor_path`
This option tells SpamAssassin specifically where to find the pyzor client instead
of relying on SpamAssassin to find it in the current PATH.

#### `pyzor_home`
Define the homedir for pyzor. Default is to use the [global config dir]/.pyzor

#### `razor_enabled`
Boolean. Enable/disable the Pyzor plugin. Default: true

#### `razor_timeout`
How many seconds you wait for Razor to complete before you go on without the results.
Default: 5

#### `razor_home`
Define the homedir for razor. Please note that if you set a custom path the module will
automatically use the directory in which you store your razor config as the home
directory for the module. Default is to use the [global config dir]/.razor

#### `spamcop_enabled`
Boolean. Enable/disable the Pyzor plugin. Default: false

#### `spamcop_from_address`
This address is used during manual reports to SpamCop as the From: address. You
can use your normal email address. If this is not set, a guess will be used as
the From: address in SpamCop reports.

#### `spamcop_to_address`
Your customized SpamCop report submission address. You need to obtain this address
by registering at http://www.spamcop.net/. If this is not set, SpamCop reports will
go to a generic reporting address for SpamAssassin users and your reports will probably
have less weight in the SpamCop system.

#### `spamcop_max_report_size`
Messages larger than this size (in kilobytes) will be truncated in report messages sent
to SpamCop. The default setting is the maximum size that SpamCop will accept at the time
of release. Default: 50

#### `awl_enabled`
Boolean. Enable/disable the Auto-Whitelist plugin. Default: false

#### `awl_sql_enabled`
Boolean. If true will set auto_whitelist_factory to use sql and will write the
sql dsn, and other directives, to local.cf. Default: false

#### `awl_dsn`
This parameter gives the connect string used to connect to the SQL based
storage. By default will use the mysql driver and a database called
spamassassin. Please note the module does not manage any database
settings or the creation of the schema.

#### `awl_sql_username`
The sql username used for the dsn provided above.

#### `awl_sql_password`
The sql password used for the dsn provided above.

#### `awl_sql_override_username`
Used by the SQLBasedAddrList storage implementation.  If this option is
set the SQLBasedAddrList module will override the set username with the
value given. This can be useful for implementing global or group based
auto-whitelist databases.

#### `auto_whitelist_path`
This is the automatic-whitelist directory and filename.
Default: ~/.spamassassin/auto-whitelist

#### `auto_whitelist_file_mode`
The file mode bits used for the automatic-whitelist directory or file.
Default: 0600

#### `shortcircuit_enabled`
Boolean. Enable/disable the Shortcircuit plugin. Default: false

#### `shortcircuit_user_in_whitelist`
Values: ham, spam, on or off.

#### `shortcircuit_user_in_def_whitelist`
Values: ham, spam, on or off.

#### `shortcircuit_user_in_all_spam_to`
Values: ham, spam, on or off.

#### `shortcircuit_subject_in_whitelist`
Values: ham, spam, on or off.

#### `shortcircuit_user_in_blacklist`
Values: ham, spam, on or off.

#### `shortcircuit_user_in_blacklist_to`
Values: ham, spam, on or off.

#### `shortcircuit_subject_in_blacklist`
Values: ham, spam, on or off.

#### `shortcircuit_all_trusted`
Values: ham, spam, on or off.

#### `dkim_enabled`
Boolean. Enable/disable the DKIM plugin. Default: true

#### `dkim_timeout`
How many seconds to wait for a DKIM query to complete,
before scanning continues without the DKIM result.
Default: 5

#### `rules2xsbody_enabled`
Boolean.  Enable the Rule2XSBody plugin.
Compile ruleset to native code with sa-compile.
Requires re2c and gcc packages (not managed in this module)

## Limitations

This module has been built on and tested against Puppet 3.3.2 and higher.

The module has been tested on:

* CentOS 6
* Debian 7

## Development

1. [Fork](http://help.github.com/forking/) puppet-spamassassin
2. Create a topic branch against the develop branch `git checkout develop; git checkout -b my_branch`
3. Make sure you have added tests for your changes. Tests are written with [rspec-puppet](http://rspec-puppet.com/).
4. Run all the tests to assure nothing else was accidentally broken. To run all tests: rake spec
5. Push to your branch `git push origin my_branch`
6. Create a [Pull Request](http://help.github.com/pull-requests/) from your branch against the develop branch.

#### Contributors

The list of contributors can be found in two places:

 * Upstream: [https://bitbucket.org/wyrie/puppet-spamassassin/commits/all](https://bitbucket.org/wyrie/puppet-spamassassin/commits/all)
 * Here: [https://github.com/lelutin/puppet-spamassassin/graphs/contributors](https://github.com/lelutin/puppet-spamassassin/graphs/contributors)
