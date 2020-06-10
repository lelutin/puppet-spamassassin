class { 'spamassassin':
  sa_update            => false,
  service_enabled      => true,
  spamd_max_children   => 3,
  spamd_listen_address => ['0.0.0.0'],
  spamd_allowed_ips    => ['127.0.0.1/32','192.168.0.0/24'],
}
