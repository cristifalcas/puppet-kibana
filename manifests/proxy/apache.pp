class kibana::proxy::apache (
  $servername = $::fqdn,
  $ssl_port   = 443,
  $ssl_cert   = $kibana::ssl_cert_file,
  $ssl_key    = $kibana::ssl_key_file,
  $ssl_ca     = $kibana::ca,
  $auth_user  = undef,
  $auth_pass  = undef,
) {
  include ::apache
  include ::apache::mod::proxy
  include ::apache::mod::proxy_html
  $proxy = 'kibana'

  package { 'mod_proxy_html': ensure => present }

  if $auth_user and $auth_pass {
    include ::apache::mod::auth_basic
    $auth_basic = 'Basic'
    $auth_basic_user_file = "${::apache::httpd_dir}/kibana.htpasswd"

    htpasswd { $auth_user:
      cryptpasswd => ht_sha1($auth_pass),
      target      => $auth_basic_user_file,
    }
  } else {
    $auth_basic = 'None'
    $auth_basic_user_file = undef
  }

  apache::vhost { $proxy:
    servername          => $servername,
    port                => $ssl_port,
    priority            => 90,
    docroot             => '/var/www/',
    access_log_file     => 'kibana_access.log',
    error_log_file      => 'kibana_error.log',
    proxy_preserve_host => true,
    proxy_pass          => [{
        'path' => '/',
        'url'  => "https://${kibana::host}:${kibana::port}"
      }
      ],
    # Have no idea what this does.
    # Taken from here: http://mmbash.de/blog/kibana-beta-behind-apache-proxy/
    rewrites            => [{
        rewrite_cond => ['%{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f'],
        rewrite_rule => [".* https://${kibana::host}:${kibana::port}%{REQUEST_URI} [P,QSA]"],
      }
      ],
    ssl_proxyengine     => true,
    ssl                 => true,
    ssl_cert            => $ssl_cert,
    ssl_key             => $ssl_key,
    ssl_ca              => $ssl_ca,
    custom_fragment     => "
  <Proxy *>
    Order Allow,Deny
    Allow from all
    AuthType ${auth_basic}
    AuthName \"Authenticated proxy\"
    AuthUserFile ${auth_basic_user_file}
    Require valid-user
  </Proxy>"
  }
}
