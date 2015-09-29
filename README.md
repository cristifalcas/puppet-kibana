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

	  class { 'kibana':
	    ca            => '/etc/pki/puppet_certs/kibana/ca_cert.pem',
	    ssl_cert_file => '/etc/pki/puppet_certs/kibana/public_cert.pem',
	    ssl_key_file  => '/etc/pki/puppet_certs/kibana/private_cert.pem',
	  }


## Development

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes
