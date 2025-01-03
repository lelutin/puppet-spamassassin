# @summary Configure spamassassin and related software.
#
# @api private
#
# @note This class should not be used directly. Use the spamassassin class and
#   its parameters instead.
#
class spamassassin::config {
  if $spamassassin::run_execs_as_user {
    Exec {
      path => ['/bin', '/usr/bin'],
      user => $spamassassin::run_execs_as_user,
      # The default cwd is unusable as non-root, and this breaks Razor's Perl
      # interpreter with errors like this:
      # Can't locate Razor2/Client/Agent.pm: ... Permission denied at /usr/bin/razor-admin line 15
      cwd  => '/',
    }
  } else {
    Exec {
      path => ['/bin', '/usr/bin'],
    }
  }

  # Install and setup pyzor
  if $spamassassin::pyzor_enabled {
    exec { 'pyzor_discover':
      command => "/usr/bin/pyzor --homedir '${spamassassin::pyzor_home}' discover",
      unless  => "test -d ${spamassassin::pyzor_home}",
    }
  }

  # Install and setup razor
  if $spamassassin::razor_enabled {
    $razor_home_owner = $spamassassin::run_execs_as_user ? {
      undef   => 'root',
      default => $spamassassin::run_execs_as_user,
    }

    file { $spamassassin::razor_home:
      ensure  => directory,
      owner   => $razor_home_owner,
      recurse => true,
    } -> exec { 'razor_register':
      command => "/usr/bin/razor-admin -home=${spamassassin::razor_home} -register",
      unless  => "test -h ${spamassassin::razor_home}/identity",
    } -> exec { 'razor_create':
      command => "/usr/bin/razor-admin -home=${spamassassin::razor_home} -create",
      creates => "${spamassassin::razor_home}/razor-agent.conf",
    } -> exec { 'razor_discover':
      command     => "/usr/bin/razor-admin -home=${spamassassin::razor_home} -discover",
      refreshonly => true,
    }
  }

  $local_cf_context = {
    required_score                     => $spamassassin::required_score,
    score_tests                        => $spamassassin::score_tests,
    rewrite_header_subject             => $spamassassin::rewrite_header_subject,
    rewrite_header_from                => $spamassassin::rewrite_header_from,
    rewrite_header_to                  => $spamassassin::rewrite_header_to,
    add_header_spam                    => $spamassassin::add_header_spam,
    add_header_ham                     => $spamassassin::add_header_ham,
    add_header_all                     => $spamassassin::add_header_all,
    remove_header_spam                 => $spamassassin::remove_header_spam,
    remove_header_ham                  => $spamassassin::remove_header_ham,
    remove_header_all                  => $spamassassin::remove_header_all,
    report_safe                        => $spamassassin::report_safe,
    clear_trusted_networks             => $spamassassin::clear_trusted_networks,
    trusted_networks                   => $spamassassin::trusted_networks,
    clear_internal_networks            => $spamassassin::clear_internal_networks,
    internal_networks                  => $spamassassin::internal_networks,
    skip_rbl_checks                    => bool2num($spamassassin::skip_rbl_checks),
    dns_available                      => $spamassassin::dns_available,
    uridnsbl_skip_domain               => $spamassassin::uridnsbl_skip_domain,
    uridnsbl                           => $spamassassin::uridnsbl,
    urirhsbl                           => $spamassassin::urirhsbl,
    urirhssub                          => $spamassassin::urirhssub,
    whitelist_from                     => $spamassassin::whitelist_from,
    whitelist_from_rcvd                => $spamassassin::whitelist_from_rcvd,
    whitelist_to                       => $spamassassin::whitelist_to,
    blacklist_from                     => $spamassassin::blacklist_from,
    blacklist_to                       => $spamassassin::blacklist_to,
    bayes_enabled                      => $spamassassin::bayes_enabled,
    bayes_use_hapaxes                  => bool2num($spamassassin::bayes_use_hapaxes),
    bayes_auto_expire                  => bool2num($spamassassin::bayes_auto_expire),
    bayes_auto_learn                   => bool2num($spamassassin::bayes_auto_learn),
    bayes_auto_learn_threshold_nonspam => $spamassassin::bayes_auto_learn_threshold_nonspam,
    bayes_auto_learn_threshold_spam    => $spamassassin::bayes_auto_learn_threshold_spam,
    bayes_ignore_header                => $spamassassin::bayes_ignore_header,
    bayes_sql_enabled                  => $spamassassin::bayes_sql_enabled,
    bayes_store_module                 => $spamassassin::bayes_store_module,
    bayes_sql_dsn                      => $spamassassin::bayes_sql_dsn,
    bayes_sql_username                 => $spamassassin::bayes_sql_username,
    bayes_sql_password                 => $spamassassin::bayes_sql_password,
    bayes_sql_override_username        => $spamassassin::bayes_sql_override_username,
    bayes_path                         => $spamassassin::bayes_path,
    bayes_file_mode                    => $spamassassin::bayes_file_mode,
    awl_enabled                        => $spamassassin::awl_enabled,
    awl_sql_enabled                    => $spamassassin::awl_sql_enabled,
    awl_dsn                            => $spamassassin::awl_dsn,
    awl_sql_username                   => $spamassassin::awl_sql_username,
    awl_sql_password                   => $spamassassin::awl_sql_password,
    awl_sql_override_username          => $spamassassin::awl_sql_override_username,
    auto_whitelist_path                => $spamassassin::auto_whitelist_path,
    auto_whitelist_file_mode           => $spamassassin::auto_whitelist_file_mode,
    textcat_enabled                    => $spamassassin::textcat_enabled,
    ok_languages                       => $spamassassin::ok_languages,
    ok_locales                         => $spamassassin::ok_locales,
    normalize_charset                  => bool2num($spamassassin::normalize_charset),
    dcc_enabled                        => $spamassassin::dcc_enabled,
    dcc_timeout                        => $spamassassin::dcc_timeout,
    dcc_body_max                       => $spamassassin::dcc_body_max,
    dcc_fuz1_max                       => $spamassassin::dcc_fuz1_max,
    dcc_fuz2_max                       => $spamassassin::dcc_fuz2_max,
    pyzor_enabled                      => $spamassassin::pyzor_enabled,
    pyzor_timeout                      => $spamassassin::pyzor_timeout,
    pyzor_max                          => $spamassassin::pyzor_max,
    pyzor_path                         => $spamassassin::pyzor_path,
    pyzor_home                         => $spamassassin::pyzor_home,
    pyzor_options                      => $spamassassin::pyzor_options,
    razor_enabled                      => $spamassassin::razor_enabled,
    razor_timeout                      => $spamassassin::razor_timeout,
    razor_home                         => $spamassassin::razor_home,
    spamcop_enabled                    => $spamassassin::spamcop_enabled,
    spamcop_from_address               => $spamassassin::spamcop_from_address,
    spamcop_to_address                 => $spamassassin::spamcop_to_address,
    spamcop_max_report_size            => $spamassassin::spamcop_max_report_size,
    shortcircuit_enabled               => $spamassassin::shortcircuit_enabled,
    shortcircuit_user_in_whitelist     => $spamassassin::shortcircuit_user_in_whitelist,
    shortcircuit_user_in_def_whitelist => $spamassassin::shortcircuit_user_in_def_whitelist,
    shortcircuit_user_in_all_spam_to   => $spamassassin::shortcircuit_user_in_all_spam_to,
    shortcircuit_subject_in_whitelist  => $spamassassin::shortcircuit_subject_in_whitelist,
    shortcircuit_user_in_blacklist     => $spamassassin::shortcircuit_user_in_blacklist,
    shortcircuit_user_in_blacklist_to  => $spamassassin::shortcircuit_user_in_blacklist_to,
    shortcircuit_subject_in_blacklist  => $spamassassin::shortcircuit_subject_in_blacklist,
    shortcircuit_all_trusted           => $spamassassin::shortcircuit_all_trusted,
    dkim_enabled                       => $spamassassin::dkim_enabled,
    dkim_timeout                       => $spamassassin::dkim_timeout,
    custom_rules                       => $spamassassin::custom_rules,
    custom_config                      => $spamassassin::custom_config,
  }
  file { "${spamassassin::configdir}/local.cf":
    ensure  => file,
    content => epp('spamassassin/local_cf.epp',$local_cf_context),
  }

  file { "${spamassassin::configdir}/init.pre":
    ensure => file,
    source => 'puppet:///modules/spamassassin/init.pre',
  }

  $v310_context = {
    dcc_enabled     => $spamassassin::dcc_enabled,
    pyzor_enabled   => $spamassassin::pyzor_enabled,
    razor_enabled   => $spamassassin::razor_enabled,
    spamcop_enabled => $spamassassin::spamcop_enabled,
    awl_enabled     => $spamassassin::awl_enabled,
    textcat_enabled => $spamassassin::textcat_enabled,
  }
  file { "${spamassassin::configdir}/v310.pre":
    ensure  => file,
    content => epp('spamassassin/v310_pre.epp',$v310_context),
  }

  $v312_context = {
    dkim_enabled => $spamassassin::dkim_enabled,
  }
  file { "${spamassassin::configdir}/v312.pre":
    ensure  => file,
    content => epp('spamassassin/v312_pre.epp', $v312_context),
  }

  $v320_context = {
    shortcircuit_enabled => $spamassassin::shortcircuit_enabled,
    rules2xsbody_enabled => $spamassassin::rules2xsbody_enabled,
  }
  file { "${spamassassin::configdir}/v320.pre":
    ensure  => file,
    content => epp('spamassassin/v320_pre.epp', $v320_context),
  }

  if $spamassassin::spamd_sql_config {
    $sql_cf_context = {
      user_scores_dsn              => $spamassassin::user_scores_dsn,
      user_scores_sql_username     => $spamassassin::user_scores_sql_username,
      user_scores_sql_password     => $spamassassin::user_scores_sql_password,
      user_scores_sql_custom_query => $spamassassin::user_scores_sql_custom_query,
    }
    file { "${spamassassin::configdir}/sql.cf":
      ensure  => file,
      content => epp('spamassassin/sql.cf.epp', $sql_cf_context),
    }
  }

  # Enable or explicitly disable sa-update cron.
  case $facts['os']['family'] {
    'Debian': {
      $cron = $spamassassin::sa_update ? {
        true    => 1,
        default => 0,
      }
      file_line { 'sa_update':
        path    => $spamassassin::sa_update_file,
        line    => "CRON=${cron}",
        match   => '^CRON=[0-1]$',
        require => Package['spamassassin'],
      }
    }
    'Redhat': {
      $saupdate = bool2str($spamassassin::sa_update, 'yes', 'no')
      file_line { 'sa_update':
        path    => $spamassassin::sa_update_file,
        line    => "SAUPDATE=${saupdate}",
        match   => '^SAUPDATE=',
        require => Package['spamassassin'],
      }
    }
    default: {}
  }

  if $facts['os']['family'] == 'Debian' {
    # We enable the service regardless of our service_enabled parameter. Trying to
    # stop or start the spamassassin init script without the enabled will fail.
    file_line { 'spamd_service' :
      path  => $spamassassin::spamd_options_file,
      line  => 'ENABLED=1',
      match => '^ENABLED',
    }
  }

  if $spamassassin::service_enabled {
    $extra_options_context = {
      spamd_username       => $spamassassin::spamd_username,
      spamd_groupname      => $spamassassin::spamd_groupname,
      spamd_max_children   => $spamassassin::spamd_max_children,
      spamd_min_children   => $spamassassin::spamd_min_children,
      spamd_listen_address => $spamassassin::spamd_listen_address,
      spamd_allowed_ips    => $spamassassin::spamd_allowed_ips,
      spamd_nouserconfig   => $spamassassin::spamd_nouserconfig,
      spamd_allowtell      => $spamassassin::spamd_allowtell,
      spamd_sql_config     => $spamassassin::spamd_sql_config,
      spamd_syslog_facility   => $spamassassin::spamd_syslog_facility,
    }
    $extra_options = epp(
      'spamassassin/service_extra_options.epp',
      $extra_options_context
    )

    file_line { 'spamd_options' :
      path  => $spamassassin::spamd_options_file,
      line  => "${spamassassin::spamd_options_var}=\"${spamassassin::spamd_defaults} ${extra_options}\"",
      match => "^${spamassassin::spamd_options_var}=",
    }
  }
}
