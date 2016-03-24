class kibana::proxy::nginx (
  $servername = $::fqdn,
  $ssl_port   = 443,
  $ssl_cert   = $kibana::server_ssl_cert,
  $ssl_key    = $kibana::server_ssl_key,
  $auth_user  = undef,
  $auth_pass  = undef,
) {
  include ::nginx
  $proxy = 'kibana'

  if $auth_user and $auth_pass {
    $auth_basic = 'Restricted'
    $auth_basic_user_file = "${::nginx::config::conf_dir}/kibana.htpasswd"

    htpasswd { $auth_user:
      cryptpasswd => ht_sha1($auth_pass),
      target      => $auth_basic_user_file,
    }
  } else {
    $auth_basic = 'off'
    $auth_basic_user_file = undef
  }

  nginx::resource::vhost { $::fqdn:
    listen_port          => $ssl_port,
    www_root             => '/usr/share/nginx/html',
    use_default_location => false,
    access_log           => '/var/log/nginx/kibana.access.log',
    error_log            => '/var/log/nginx/kibana.error.log info',
    ssl                  => true,
    ssl_cert             => $ssl_cert,
    ssl_key              => $ssl_key,
    vhost_cfg_append     => {
      'client_max_body_size'      => 0,
      'chunked_transfer_encoding' => 'on',
    },
  }

  nginx::resource::location { "/${proxy}":
    vhost                => $::fqdn,
    ssl_only             => true,
    proxy                => "http://${proxy}",
    auth_basic           => $auth_basic,
    auth_basic_user_file => $auth_basic_user_file,
  }

  nginx::resource::upstream { $proxy: members => ["localhost:${kibana::server_port}",], }
}
