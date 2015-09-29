# == Class: kibana::service
#
class kibana::service {
  service { 'kibana':
    ensure => running,
    enable => true,
  }
}
