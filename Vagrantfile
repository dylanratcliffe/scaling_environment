require 'vagrant-openstack-provider'

Vagrant.configure("2") do |config|
  config.vm.box = "openstack"

  # Make sure the private key from the key pair is provided
  config.ssh.private_key_path = "~/.ssh/openstack.pem"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.hostmanager.enabled      = true
  config.hostmanager.manage_host  = true
  config.hostmanager.manage_guest = true

  config.vm.provider :openstack do |os|
    os.openstack_auth_url = "#{ENV['OS_AUTH_URL']}/tokens"
    os.username           = "#{ENV['OS_USERNAME']}"
    os.password           = "#{ENV['OS_PASSWORD']}"
    os.tenant_name        = "#{ENV['OS_TENANT_NAME']}"
    os.flavor             = 'g1.large'
    os.floating_ip_pool   = 'ext-net-pdx1-opdx1'
    os.security_groups    = ['sg0']
    os.keypair_name       = 'laptop'
    os.sync_method        = 'none'
    #os.networks           = ['no_internet']
  end

  config.vm.define "master.scaling.puppetconf.com" do |agent|
    agent.vm.provider :openstack do |os|
      os.image  = 'centos_7_x86_64'
      os.flavor = 'g1.xlarge'
    end
    agent.ssh.username = 'centos'
  end

  config.vm.define "clamps1.scaling.puppetconf.com" do |agent|
    agent.vm.provider :openstack do |os|
      os.image  = 'centos_7_x86_64'
    end
    agent.ssh.username = 'centos'
  end

end
