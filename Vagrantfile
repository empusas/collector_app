# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
 # The most common configuration options are documented and commented below.
 # For a complete reference, please see the online documentation at
 # https://docs.vagrantup.com.

 # Every Vagrant development environment requires a box. You can search for
 # boxes at https://vagrantcloud.com/search.
 config.vm.box = "ubuntu/focal64"
 config.vm.box_version = "20211015.0.0"

 config.vm.provision "disable apt daily service",
   type: "shell",
   preserve_order: true,
   inline: "systemctl disable apt-daily.service"

 config.vm.provision "disable apt daily timer",
   type: "shell",
   preserve_order: true,
   inline: "systemctl disable apt-daily.timer"

 config.vm.provision "create .bash_aliases",
   type: "shell",
   preserve_order: true,
   inline: "touch /home/vagrant/.bash_aliases"

 config.vm.provision "shell", preserve_order: true, inline: <<-SHELL
   if ! grep -q PYTHON_ALIAS_ADDED /home/vagrant/.bash_aliases; then
     echo "# PYTHON_ALIAS_ADDED" >> /home/vagrant/.bash_aliases
     echo "alias python='python3'" >> /home/vagrant/.bash_aliases
   fi
   SHELL

 config.vm.provision "apt update",
   type: "shell",
   preserve_order: true,
   inline: "sudo apt-get update"

 config.vm.provision "apt install packages",
   type: "shell",
   preserve_order: true,
   inline: "sudo apt-get install -y zip software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release"

 config.vm.provision "add Docker’s official GPG key",
   type: "shell",
   preserve_order: true,
   inline: "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"

 config.vm.provision "add Docker’s Repository",
   type: "shell",
   preserve_order: true,
   inline: "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'"

 config.vm.provision "install Docker",
   type: "shell",
   preserve_order: true,
   inline: "sudo apt install -y docker-ce=5:20.10.9~3-0~ubuntu-focal docker-ce-cli=5:20.10.9~3-0~ubuntu-focal containerd.io"

 config.vm.provision "get docker-compose",
   type: "shell",
   preserve_order: true,
   inline: "sudo curl -L 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose"

 config.vm.provision "make docker-compose executable",
   type: "shell",
   preserve_order: true,
   inline: "sudo chmod +x /usr/local/bin/docker-compose"

 config.vm.synced_folder "./collector_vm", "/home/vagrant/collector_vm/", disabled: false, preserve_order: true

 config.vm.provision "shell", preserve_order: true, inline: <<-SHELL
   cd collector_vm
   docker-compose build
   SHELL

end
