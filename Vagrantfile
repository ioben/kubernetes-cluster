# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    config.vm.box = "bento/centos-7.2"

    config.vm.define 'master', primary: true do |node|
        node.vm.hostname = 'master'
        node.vm.network "private_network", ip: "10.0.20.10"
        # node.vm.network "public_network"

        # node.vm.synced_folder "../data", "/vagrant_data"

        # node.vm.provider "virtualbox" {|vb| vb.memory = "1024"}

        node.vm.provision 'shell', path: 'build/shared.sh'
        node.vm.provision 'shell', path: 'build/master.sh'
    end

    2.times.each do |index|
        config.vm.define "minion#{index + 1}" do |node|
            node.vm.hostname = "minion#{index + 1}"
            node.vm.network "private_network", ip: "10.0.20.1#{index + 1}"
            # node.vm.network "public_network"

            # node.vm.synced_folder "../data", "/vagrant_data"

            # node.vm.provider "virtualbox" {|vb| vb.memory = "1024"}

            node.vm.provision 'shell', path: 'build/shared.sh'
            node.vm.provision 'shell', path: 'build/minion.sh'
        end
    end
end
