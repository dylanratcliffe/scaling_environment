require 'vagrant-openstack-provider'

Vagrant.configure("2") do |config|
  config.vm.box = "openstack"

  config.pe_build.version = '2016.2.1'
  config.pe_build.download_root = "https://s3.amazonaws.com/pe-builds/released/2016.2.1/puppet-enterprise-2016.2.1-el-7-x86_64.tar.gz"
  config.pe_build.shared_installer = false

  # Make sure the private key from the key pair is provided
  config.ssh.private_key_path = "~/.ssh/openstack.pem"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  # config.hostmanager.enabled      = true
  # config.hostmanager.manage_host  = true
  # config.hostmanager.manage_guest = true

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

    agent.vm.provision :pe_bootstrap do |p|
      p.role          = :master
      p.answer_extras = [
        '"puppet_enterprise::profile::master::code_manager_auto_configure": true',
        '"puppet_enterprise::profile::master::r10k_remote:" "https://github.com/dylanratcliffe/scaling_environment.git"'
      ]
    end
  end

  config.vm.define "clamps1.scaling.puppetconf.com" do |agent|
    agent.vm.provider :openstack do |os|
      os.image  = 'centos_7_x86_64'
    end
    agent.ssh.username = 'centos'
    agent.vm.provision :pe_bootstrap
  end

end
