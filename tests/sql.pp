class { 'spamassassin':
  bayes_sql_enabled           => true,
  bayes_sql_dsn               => 'DBI:mysql:spamassassin:localhost:3306',
  bayes_sql_username          => 'sqluser',
  bayes_sql_password          => 'somesecret',
  bayes_sql_override_username => 'amavis',
}