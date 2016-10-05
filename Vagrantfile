require 'vagrant-openstack-provider'
require 'pry'

Vagrant.configure("2") do |config|
  config.vm.box = "openstack"

  config.pe_build.version = '2016.2.1'
  config.pe_build.download_root = "https://s3.amazonaws.com/pe-builds/released/2016.2.1"
  config.pe_build.shared_installer = false

  # Make sure the private key from the key pair is provided
  config.ssh.private_key_path = "~/.ssh/openstack.pem"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.hostmanager.enabled      = true
  config.hostmanager.manage_host  = false
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

    agent.vm.provision "shell", # Set the hostname correctly
      inline: "hostnamectl set-hostname master.scaling.puppetconf.com"

    agent.vm.provision "shell", # Add loopback for hostname because slice freaks out otherwise
      inline: "sed -i '1 i\\127.0.0.1 master.scaling.puppetconf.com' /etc/hosts"
    agent.vm.provision :pe_bootstrap do |p|
      p.role          = :master
      p.answer_extras = [
        '"puppet_enterprise::puppet_master_host": "master.scaling.puppetconf.com"',
        '"puppet_enterprise::profile::master::code_manager_auto_configure": true',
        '"puppet_enterprise::profile::master::r10k_remote": "https://github.com/dylanratcliffe/scaling_environment.git"'
      ]
    end

    # Add a provisioner to do a manual code deploy
    agent.vm.provision "shell",
      path: 'scripts/manual_code_deploy.sh'
  end

  (1..3).each do |num|
    config.vm.define "clamps#{num}.scaling.puppetconf.com" do |agent|
      agent.vm.provider :openstack do |os|
        os.image  = 'centos_7_x86_64'
      end
      agent.ssh.username = 'centos'
      agent.vm.provision "shell", # Set the hostname correctly
        inline: "hostnamectl set-hostname clamps#{num}.scaling.puppetconf.com"
      agent.vm.provision :pe_agent do |a|
        a.master_vm = "master.scaling.puppetconf.com"
      end
    end
  end

end
