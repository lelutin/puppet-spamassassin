# @summary Setup spamassassin service.
#
# @api private
#
# @note This class should not be used directly. Use the spamassassin class and
#   its parameters instead.
#
class spamassassin::service {
  service { 'spamassassin':
    ensure  => $spamassassin::service_enabled,
    name    => $spamassassin::service_name,
    enable  => $spamassassin::service_enabled,
    pattern => 'spamd',
    require => Package['spamassassin'],
  }
}
