# == Class: s3cmd
#
# Manage and configure s3cmd from http://s3tools.org/
#
# === Parameters
#
# [*$ensure*]
#   Remove or install the s3tools package. Possible values
#   present or absent
#
# === Examples
#
#  include s3cmd
#
# === Author
#
# Dejan Golja <dejan@golja.org>
#

class s3cmd(
  $ensure = $s3cmd::params::ensure,
  $manage_repo = $s3cmd::params::ensure,
  $source_repo = $s3cmd::params::source_repo,
) inherits s3cmd::params {

  validate_bool($manage_repo)

  if !($ensure in ['present', 'absent']) {
    fail('ensure must be either present or absent')
  }
  if $manage_repo != false {
    if $source_repo == 'epel' {
      include ::yum::repo::s3cmd
    } else {
      if $::osfamily == 'RedHat' or $::operatingsystem == 'Amazon' {
        yumrepo { 's3tools':
          descr    => $s3cmd::params::description,
          baseurl  => $s3cmd::params::baseurl,
          gpgkey   => $s3cmd::params::gpgkey,
          gpgcheck => 1,
          enabled  => 1,
          } -> Package['s3cmd']
      }
    }
    package {'s3cmd':
      ensure => $ensure,
      name   => $s3cmd::params::package_name,
    }
  }
}
