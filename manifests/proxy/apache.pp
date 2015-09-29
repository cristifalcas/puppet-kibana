class kibana::proxy::apache (
  $servername = $::fqdn,
  $ssl_port   = 443,
  $ssl_cert   = $kibana::ssl_cert_file,
  $ssl_key    = $kibana::ssl_key_file,
  $ssl_ca     = $kibana::ca,
  $auth_user  = undef,
  $auth_pass  = undef,) {
  include ::apache
  include ::apache::mod::proxy
  include ::apache::mod::proxy_html
  $proxy = 'kibana'

  package { 'mod_proxy_html': ensure => present }

  apache::vhost { $proxy:
    servername          => $servername,
    port                => $ssl_port,
    priority            => 90,
    docroot             => '/var/www/',
    access_log_file     => 'kibana_access.log',
    error_log_file      => 'kibana_error.log',
    proxy_preserve_host => true,
    proxy_pass          => [{
        'path'   => "/${::proxy}",
        'url'    => "https://${kibana::host}:${kibana::port}",
        'params' => {
          'max'   => 20,
          'ttl'   => 120,
          'retry' => 300
        }
      }
      ],
    # have no idea what this dose. Taken from here: http://mmbash.de/blog/kibana-beta-behind-apache-proxy/
    rewrites            => [{
        rewrite_cond => ['%{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f'],
        rewrite_rule => ['.* https://127.0.0.1:5601%{REQUEST_URI} [P,QSA]'],
      }
      ,],
    ssl_proxyengine     => true,
    ssl                 => true,
    ssl_cert            => $ssl_cert,
    ssl_key             => $ssl_key,
    ssl_ca              => $ssl_ca,
    custom_fragment     => '
  ProxyHTMLEnable On
  ProxyHTMLURLMap http://localhost:5601/ /
  ProxyHTMLExtended On',
  }
}
