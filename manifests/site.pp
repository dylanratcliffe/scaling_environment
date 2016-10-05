include epel

node /clamps\d\.scaling\.puppetconf\.com/ {
  class { 'clamps::agent':
    nonroot_users => 10,
  }
}

node 'master.scaling.puppetconf.com' {
  include clamps::master
}

node /user\d*\.clamps\d\.scaling\.puppetconf\.com/ {
  include clamps
}
