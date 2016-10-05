include epel

node 'master.scaling.puppetconf.com' {
  include clamps::master

  Pe_hocon_setting <| title == 'jruby-puppet.max-active-instances' |> {
    ensure => present,
    value  => 8,
  }
}

node /user\d*\.clamps\d\.scaling\.puppetconf\.com/ {
  include clamps
}

node /clamps\d\.scaling\.puppetconf\.com/ {
  class { 'clamps::agent':
    nonroot_users => 50,
  }
}
