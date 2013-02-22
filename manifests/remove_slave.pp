class jenkins::remove_slave {
  package { 'jenkins-slave': ensure => absent }

  file { '/var/lib/jenkins':
    ensure => absent,
    force  => true
  }

  file { '/etc/jenkins':
    ensure => absent,
    force  => true
  }
}
