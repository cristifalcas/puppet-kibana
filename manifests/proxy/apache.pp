class kibana::proxy::apache (
  $servername      = $::fqdn,
  $ssl_port        = 443,
  $ssl_cert        = $kibana::ssl_cert_file,
  $ssl_key         = $kibana::ssl_key_file,
  $ssl_ca          = $kibana::ca,
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
        'url'  => "https://${kibana::host}:${kibana::port}/"
      }
      ,
      ],
    ssl_proxyengine     => true,
    ssl                 => true,
    ssl_cert            => $ssl_cert,
    ssl_key             => $ssl_key,
    ssl_ca              => $ssl_ca,
    custom_fragment     => $custom_fragment,
  }
}
