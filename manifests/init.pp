# == Class: kibana
#
class kibana (
  $ensure                      = $kibana::params::ensure,
  $host                        = $kibana::params::host,
  $port                        = $kibana::params::port,
  $elasticsearch_url           = $kibana::params::elasticsearch_url,
  $elasticsearch_preserve_host = $kibana::params::elasticsearch_preserve_host,
  $kibana_index                = $kibana::params::kibana_index,
  $request_timeout             = $kibana::params::request_timeout,
  $shard_timeout               = $kibana::params::shard_timeout,
  $verify_ssl                  = $kibana::params::verify_ssl,
  $ca                          = $kibana::params::ca,
  $ssl_key_file                = $kibana::params::ssl_key_file,
  $ssl_cert_file               = $kibana::params::ssl_cert_file,
  $pid_file                    = $kibana::params::pid_file,
  $log_file                    = $kibana::params::log_file,
  $default_app_id              = $kibana::params::default_app_id,
  $run_user                    = $kibana::params::run_user,
  #
  ) inherits kibana::params {
  contain kibana::install
  contain kibana::config
  contain kibana::service

  Class['kibana::install'] ->
  Class['kibana::config'] ~>
  Class['kibana::service']
}
