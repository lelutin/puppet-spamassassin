# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'debian-9-amd64'

  config.vm.define :test do |test|
    # TODO: test vagrant-librarian-puppet
    test.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'tests'
      puppet.manifest_file = 'init.pp'
      puppet.options = ['--modulepath', '/tmp/vagrant-puppet/modules']
    end
  end
end
