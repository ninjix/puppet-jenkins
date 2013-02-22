define jenkins::slave (
  $server   = 'localhost',
  $protocol = 'http') {
  apt::addppa { 'hudson-ubuntu/testing': dist => 'precise' }
  $jenkins_url = "${protocol}://${server}"

  package { 'jenkins-slave': ensure => installed }

  service { 'jenkins-slave':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['jenkins-slave'],
    subscribe => [
      File['/etc/default/jenkins-slave']];
  }

  # We need this right now because we are using
  # self-signed certificates :(
  file { '/usr/share/jenkins/bin/download-slave.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///jenkins/download-slave.sh'
  }

  file { '/etc/default/jenkins-slave':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('jenkins/default_jenkins-slave.erb')
  }

}
