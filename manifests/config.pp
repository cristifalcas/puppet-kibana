# == Class: kibana::configure
#
# This class configures kibana.  It should not be directly called.
#
class kibana::config {
  user { $kibana::run_user:
    ensure => present,
    system => true,
  }

  file { '/opt/kibana/config':
    ensure  => directory,
    owner   => $kibana::run_user,
    group   => $kibana::run_user,
    recurse => true,
  }

  file { '/opt/kibana/config/kibana.yml':
    ensure  => file,
    content => template("${module_name}/kibana.yml"),
    owner   => $kibana::run_user,
    group   => $kibana::run_user,
    mode    => '0644',
  }

  file { '/etc/init.d/kibana':
    ensure  => file,
    content => template("${module_name}/kibana.sh"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
