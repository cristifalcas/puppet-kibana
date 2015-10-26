# kibana
[![Build Status](https://travis-ci.org/cristifalcas/puppet-kibana.png?branch=master)](https://travis-ci.org/cristifalcas/puppet-kibana)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Development - Guide for contributing to the module](#development)

## Overview

Kibana is an open source analytics and visualization platform designed to work with Elasticsearch.
You use Kibana to search, view, and interact with data stored in Elasticsearch indices.
You can easily perform advanced data analysis and visualize your data in a variety of charts, tables, and maps.

## Usage

      # in order for this configuration to work you will need to allow users kibana
      # and apache acccess to puppet certificates
	  class { 'kibana':
	    ca            => "${::settings::ssldir}/certs/ca.pem",
	    ssl_cert_file => "${::settings::ssldir}/certs/${::clientcert}.pem",
	    ssl_key_file  => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
	  }

	  class { 'kibana::proxy::apache':
	    ssl_port => 8443,
	    ssl_ca   => "${::settings::ssldir}/certs/ca.pem",
	    ssl_cert => "${::settings::ssldir}/certs/${::clientcert}.pem",
	    ssl_key  => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
	  }

### Connecting to elasticsearch directly:

	https://kibana_hostname:8443/_elastic/


### Using kopf plugin behind the proxy:

	  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
	    module_dir => 'kopf',
	    instances  => $instance_name,
	  } ->
	  file { '/usr/share/elasticsearch/plugins/kopf/_site/kopf_external_settings.json':
	    content => '{
	    "elasticsearch_root_path": "/_elastic/",
	    "with_credentials": false,
	    "theme": "dark",
	    "refresh_rate": 5000
	    }'
	  }

#### Connecting to plugins:

	https://kibana_hostname/_plugin/kopf


### Using a plain file to authenticate:

	  htpasswd { 'user_name':
	    cryptpasswd => ht_sha1('password'),
	    target      => "${::apache::conf_dir}/kibana.htpasswd",
	  } ->
	  file { "${::apache::conf_dir}/kibana.htpasswd":
	    owner => 'apache',
	  }

	  class { 'kibana::proxy::apache':
	    ssl_port => 8443,
	    ssl_ca   => "${::settings::ssldir}/certs/ca.pem",
	    ssl_cert => "${::settings::ssldir}/certs/${::clientcert}.pem",
	    ssl_key  => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
	    custom_fragment => "
	    <Proxy *>
            Order Allow,Deny
            Allow from all
            AuthName 'we need your user and password'
            AuthType basic
            AuthBasicProvider file
            AuthUserFile ${::apache::conf_dir}/kibana.htpasswd
            Require valid-user
	    </Proxy>"
	  }


### Using ldap to authenticate:

	  include apache::mod::authnz_ldap
	  class { 'kibana::proxy::apache':
	    ssl_port => 8443,
	    ssl_ca   => "${::settings::ssldir}/certs/ca.pem",
	    ssl_cert => "${::settings::ssldir}/certs/${::clientcert}.pem",
	    ssl_key  => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
	    custom_fragment => "
	    <Proxy *>
		    Order Allow,Deny
		    Allow from all
		    AuthName 'we need your user and password'
		    AuthType Basic
		    AuthBasicProvider ldap
		    AuthUserFile /dev/null
		    AuthLDAPUrl ldap://${ldap_server}:389/${ldap_search_base}?sAMAccountName
		    AuthLDAPBindDN ${ldap_search_name}
		    AuthLDAPBindPassword ${ldap_search_pass}
		    Require ldap-group CN=GROUP1,OU=Groups,${ldap_search_base}
		    Require ldap-group CN=GROUP2,OU=Groups,${ldap_search_base}
	    </Proxy>"
	  }


## Development

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes
