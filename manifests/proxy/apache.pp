#
# === Parameters:
#
# $servername::             TBD
#
# $ssl_port::               TBD
#
# $ssl_cert::               TBD
#
# $ssl_key::                TBD
#
# $es_root_path::           TBD
#
# $custom_fragment::        TBD
#
class kibana::proxy::apache (
  $servername      = $::fqdn,
  $ssl_port        = 443,
  $ssl_cert        = $kibana::server_ssl_cert,
  $ssl_key         = $kibana::server_ssl_key,
  $es_root_path    = '/_elastic',
  $custom_fragment = '',
) {
  include ::apache
  include ::apache::mod::proxy
  include ::apache::mod::proxy_html

  $proxy = 'kibana'

  apache::vhost { $proxy:
    servername          => $servername,
    port                => $ssl_port,
    priority            => 90,
    docroot             => '/var/www/',
    access_log_file     => 'kibana_access.log',
    error_log_file      => 'kibana_error.log',
    proxy_preserve_host => true,
    proxy_pass          => [
      {
        'path' => $es_root_path,
        'url'  => "${kibana::elasticsearch_url}/"
      }
      ,
      {
        'path' => '/_plugin/',
        'url'  => "${kibana::elasticsearch_url}/_plugin/"
      }
      ,
      {
        'path' => '/',
        'url'  => "https://${kibana::server_host}:${kibana::server_port}/"
      }
      ,
    ],
    ssl_proxyengine     => true,
    ssl                 => true,
    ssl_cert            => $ssl_cert,
    ssl_key             => $ssl_key,
    custom_fragment     => $custom_fragment,
  }
}
