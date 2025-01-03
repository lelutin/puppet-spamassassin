# Spamassassin

## Overview

This module installs, configures and manages spamassassin either as a service
(through spamd) or for use with applications like amavisd.

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
   * [What spamassassin affects](#what-spamassassin-affects)
   * [Setup Requirements](#setup-requirements)
   * [Beginning with spamassassin](#beginning-with-spamassassin)
4. [Usage](#usage)
   * [Override the default score values](#override-the-default-score-values)
   * [Whitelist or blacklist some addresses](#whitelist-or-blacklist-some-addresses)
   * [SQL based options](#sql-based-options)
   * [Logging for SpamAssassin](#logging-for-spamassassin)
   * [Misc options](#misc-options)
   * [Syslog facility](#syslog-facility)
   * [Custom spamassassin rules](#custom-spamassassin-rules)
   * [Arbitrary additional configurations](#arbitrary-additional-configurations)
5. [Limitations](#limitations)
6. [Development](#development)
   * [Contributors](#contributors)

## Module Description

Spamassassin has a huge array of configuration directives, this module tries to
give the user access to as many of them as possible. There are a lot of class
parameters and most of them have a brief description of it's function in the
header of the class file. For more information see:
<https://spamassassin.apache.org/full/4.0.x/doc/Mail_SpamAssassin_Conf.html>

## Setup

### What spamassassin affects

* spamassassin package.
* spamassassin configuration files: local.cf, v310.cf, v312.cf, v320.cf and
  sql.cf (optional).
* spamassassin service (optional).
* optional packages: razor, pyzor and dkim.

### Setup Requirements

On Redhat systems, if you enable razor and/or pyzor, the packages need to come
from  EPEL, which is not managed by this module. See
<https://forge.puppetlabs.com/stahnma/epel>.

The installation of the DCC plugin, if enabled, needs to be handled elsewhere.

### Beginning with spamassassin

Minimal usage for spamd

```puppet
class { 'spamassassin':
  sa_update       => true,
  service_enabled => true,
}
```

Use with amavis

```puppet
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

### Override the default score values

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

### Logging for SpamAssassin

```puppet
class { 'spamassassin':
  spamd_syslog_facility             => '/var/log/spamd.log',
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

### Syslog facility

```puppet
class { 'spamassassin':
  # [...]
  # multiple examples of values (but at most one should be specified)
  spamd_syslog_facility => 'mail' # use syslog, facility mail
  spamd_syslog_facility => './mail' # log to file ./mail
  spamd_syslog_facility => 'stderr 2>/dev/null' # log to stderr, throw messages away
  spamd_syslog_facility => 'null' # the same as above
  spamd_syslog_facility => 'file' # log to file ./spamd.log
  spamd_syslog_facility => '/var/log/spamd.log' # log to file /var/log/spamd.log
}
```

See the details of the -s option in spamd documentation for more information.

### Custom spamassassin rules

To define custom rules, use the `custom_rules` parameter. For example, via
hiera:

```yaml
spamassassin::custom_rules:
  INVOICE_SPAM:
    body: '/Invoice.*from.*You have received an invoice from .* To start with it, print out or download a JS copy of your invoice/'
    score: 6
    describe: 'spam reported claiming "You have received an invoice"'
```

### Arbitrary additional configurations

spamassassin has a ton of configuration options. If this module is not providing
what you're looking for, you can add additional arbitrary lines at the end of
the `local.cf` configuration file with the `custom_config` parameter. For
example, via hiera:

```yaml
spamassassin::custom_config:
  - hashcash_accept *@example.com
  - hashcash_accept *@example.net
```

## Limitations

This module is tested against Puppet 7.0 and higher.

The module has been tested on:

* CentOS 7 and 8
  * CentOS 8 is EOL. This module still keeps compatibility to this release
    until version 7 is also EOL since supporting version 8 should come at no
    additional maintenance cost.
* Debian 10, 11 and
* Ubuntu 20.04, 22.04 and 24.04

## Development

1. [Fork](http://help.github.com/forking/) puppet-spamassassin
2. Create a topic branch against the develop branch
   `git checkout develop; git checkout -b my_branch`
3. Make sure you have added tests for your changes. Tests are written with
   [rspec-puppet](http://rspec-puppet.com/).
4. Run all the tests to assure nothing else was accidentally broken. To run all
   tests: `rake spec`
5. Push to your branch `git push origin my_branch`
6. Create a [Pull Request](http://help.github.com/pull-requests/) from your
   branch against the develop branch.

### Contributors

The list of contributors can be found in two places:

* Upstream: [https://bitbucket.org/wyrie/puppet-spamassassin/commits/all](https://bitbucket.org/wyrie/puppet-spamassassin/commits/all)
* Here: [https://github.com/lelutin/puppet-spamassassin/graphs/contributors](https://github.com/lelutin/puppet-spamassassin/graphs/contributors)
