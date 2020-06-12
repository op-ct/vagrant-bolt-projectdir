class bolt_controller
{
  file { '/etc/puppetlabs/bolt':
    ensure => 'directory',
    mode => '0755',
    owner => 'root',
    group => 'root',
  }


  file { '/etc/puppetlabs/bolt/bolt.yaml':
    source => "puppet:///modules/${module_name}/etc/puppetlabs/bolt/bolt.yaml",
    mode => '0644',
    owner => 'root',
    group => 'root',
  }
}
