# == Class: kibana
#
# Kibana is an open source analytics and visualization platform designed to work with Elasticsearch.
# You use Kibana to search, view, and interact with data stored in Elasticsearch indices.
# You can easily perform advanced data analysis and visualize your data in a variety of charts, tables, and maps.
#
#    Flexible analytics and visualization platform
#    Real-time summary and charting of streaming data
#    Intuitive interface for a variety of users
#    Instant sharing and embedding of dashboards
#
# === Parameters:
#
# $ensure::                        This is used to set the status of the package: present or absent or a version
#                                  Default: present
#
# $server_port::                   Kibana is served by a back end server. This setting specifies the port to use.
#                                  Default: 5601
#
# $server_host::                   This setting specifies the IP address of the back end server.
#                                  Default: "0.0.0.0"
#
# $server_base_path::              Enables you to specify a path to mount Kibana at if you are running behind a proxy.
#                                  This setting cannot end in a slash (/).
#                                  Default: ''
#
# $server_max_payload_bytes::      The maximum payload size in bytes for incoming server requests.
#                                  Default: 1048576
#
# $elasticsearch_url::             The URL of the Elasticsearch instance to use for all your queries.
#                                  Default: "http://localhost:9200"
#
# $elasticsearch_preserve_host::   When this setting's value is true Kibana uses the hostname specified in the server.host setting.
#                                  When the value of this setting is false, Kibana uses the hostname of the host that connects to
#                                  this Kibana instance.
#                                  Default: true
#
# $kibana_index::                  Kibana uses an index in Elasticsearch to store saved searches, visualizations and dashboards.
#                                  Kibana creates a new index if the index doesn't already exist.
#                                  Default: ".kibana"
#
# $kibana_default_app_id::         The default application to load.
#                                  Default: "discover"
#
# $elasticsearch_username:: and
# $elasticsearch_password::        If your Elasticsearch is protected with basic authentication, these settings provide the username
#                                  and password that the Kibana server uses to perform maintenance on the Kibana index at startup.
#                                  Your Kibana users still need to authenticate with Elasticsearch, which is proxied through the
#                                  Kibana server.
#                                  Default: undef
#
# $server_ssl_enable::             Enable ssl for kibana
#                                  Default: false
#
# $server_ssl_cert::               Paths to the PEM-format SSL certificate and SSL key files, respectively. These files enable SSL
#                                  for outgoing requests from the Kibana server to the browser.
#                                  Default: "${::settings::ssldir}/certs/${::clientcert}.pem"
#
# $server_ssl_key::
#                                  Default: "${::settings::ssldir}/private_keys/${::clientcert}.pem"
#
# $elasticsearch_ssl_enable::      Enable ssl for elasticsearch
#                                  Default: false
#
# $server_ssl_cert::               Optional settings that provide the paths to the PEM-format SSL certificate and key files.
#                                  These files validate that your Elasticsearch backend uses the same key files.
#                                  Default: "${::settings::ssldir}/certs/${::clientcert}.pem"
#
# $elasticsearch_ssl_key::
#                                  Default: "${::settings::ssldir}/certs/${::clientcert}.pem"
#
# $elasticsearch_ssl_ca::          Optional setting that enables you to specify a path to the PEM file for the certificate
#                                  authority for your Elasticsearch instance.
#                                  Default: "${::settings::ssldir}/certs/ca.pem"
#
# $elasticsearch_ssl_verify::      To disregard the validity of SSL certificates, change this setting's value to false.
#                                  Default: true
#
# $elasticsearch_ping_timeout::    Time in milliseconds to wait for Elasticsearch to respond to pings.
#                                  Default: the value of the elasticsearch.requestTimeout setting
#
# $elasticsearch_request_timeout:: Time in milliseconds to wait for responses from the back end or Elasticsearch. This value must be
#                                  a positive integer.
#                                  Default: 300000
#
# $elasticsearch_shard_timeout::   Time in milliseconds for Elasticsearch to wait for responses from shards. Set to 0 to disable.
#                                  Default: 0
#
# $elasticsearch_startup_timeout:: Time in milliseconds to wait for Elasticsearch at Kibana startup before retrying.
#                                  Default: 5000
#
# $pid_file::                      Specifies the path where Kibana creates the process ID file.
#                                  Default: "/var/run/kibana.pid"
#
# $logging_dest::                  Enables you specify a file where Kibana stores log output.
#                                  Default: "stdout"
#
# $logging_silent::                Set the value of this setting to true to suppress all logging output.
#                                  Default: false
#
# $logging_quiet::                 Set the value of this setting to true to suppress all logging output other than error messages.
#                                  Default: false
#
# $logging_verbose::               Set the value of this setting to true to log all events, including system usage information and
#                                  all requests.
#                                  Default: false
#
class kibana (
  $ensure                        = $kibana::params::ensure,
  $server_port                   = $kibana::params::server_port,
  $server_host                   = $kibana::params::server_host,
  $server_base_path              = $kibana::params::server_base_path,
  $server_max_payload_bytes      = $kibana::params::server_max_payload_bytes,
  $elasticsearch_url             = $kibana::params::elasticsearch_url,
  $elasticsearch_preserve_host   = $kibana::params::elasticsearch_preserve_host,
  $kibana_index                  = $kibana::params::kibana_index,
  $kibana_default_app_id         = $kibana::params::kibana_default_app_id,
  $elasticsearch_username        = $kibana::params::elasticsearch_username,
  $elasticsearch_password        = $kibana::params::elasticsearch_password,
  $server_ssl_enable             = $kibana::params::server_ssl_enable,
  $server_ssl_cert               = $kibana::params::server_ssl_cert,
  $server_ssl_key                = $kibana::params::server_ssl_key,
  $elasticsearch_ssl_enable      = $kibana::params::elasticsearch_ssl_enable,
  $elasticsearch_ssl_cert        = $kibana::params::elasticsearch_ssl_cert,
  $elasticsearch_ssl_key         = $kibana::params::elasticsearch_ssl_key,
  $elasticsearch_ssl_ca          = $kibana::params::elasticsearch_ssl_ca,
  $elasticsearch_ssl_verify      = $kibana::params::elasticsearch_ssl_verify,
  $elasticsearch_ping_timeout    = $kibana::params::elasticsearch_ping_timeout,
  $elasticsearch_request_timeout = $kibana::params::elasticsearch_request_timeout,
  $elasticsearch_shard_timeout   = $kibana::params::elasticsearch_shard_timeout,
  $elasticsearch_startup_timeout = $kibana::params::elasticsearch_startup_timeout,
  $pid_file                      = $kibana::params::pid_file,
  $logging_dest                  = $kibana::params::logging_dest,
  $logging_silent                = $kibana::params::logging_silent,
  $logging_quiet                 = $kibana::params::logging_quiet,
  $logging_verbose               = $kibana::params::logging_verbose,
) inherits kibana::params {
  validate_bool($elasticsearch_preserve_host, $server_ssl_enable)
  validate_bool($elasticsearch_ssl_enable, $elasticsearch_ssl_verify)
  validate_bool($logging_silent, $logging_quiet, $logging_verbose)

  validate_integer([
    $server_port,
    $elasticsearch_ping_timeout,
    $elasticsearch_request_timeout,
    $elasticsearch_shard_timeout,
    $elasticsearch_startup_timeout])

  if ($elasticsearch_username and !$elasticsearch_password) or (!$elasticsearch_username and $elasticsearch_password) {
    fail('Both $elasticsearch_username and $elasticsearch_password must be defined or undefined')
  }

  contain '::kibana::install'
  contain '::kibana::config'
  contain '::kibana::service'

  Class['kibana::install'] ->
  Class['kibana::config'] ~>
  Class['kibana::service']
}
