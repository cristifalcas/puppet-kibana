# == Class: kibana::install
#
# This class installs kibana.  It should not be directly called.
class kibana::install {
  package { 'kibana': ensure => $kibana::ensure, }
}
