Spamassassin puppet module
====================

Installs and configures spamassassin and a few of it's plugins.

## Description

Spamassassin has a huge array of configuration directives, this module tries to give the user access to as many of them as possible. There are a lot of class
parameters and most of them have a brief description of it's function in the header of the class file. For more information see: http://spamassassin.apache.org/full/3.3.x/doc/Mail_SpamAssassin_Conf.html

If you want to use razor and/or pyzor see limitations below and note that the module will run a few setup commands for the plugins.

## Usage

Minimal usage for spamd

class { 'spamassassin':
  sa_update       => true,
  service_enabled => true,
}

Use with amavis

class { 'spamassassin':
  sa-update         => true,
  run_execs_as_user => 'amavis',
  service_enabled   => false,
  bayes_path		=> '/var/lib/amavis/bayes'
  razor_home        => '/var/lib/amavis/.razor',
  pyzor_home        => '/var/lib/amavis/.pyzor',
}

The tests folder has some more examples.

## Limitations

* This module has been tested on Debian Wheezy and Centos 6.4.
* On Redhat systems, if you enable razor and/or pyzor, the packages need to come from  EPEL, which is not managed by this module. See https://forge.puppetlabs.com/stahnma/epel.