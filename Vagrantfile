Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  #config.vm.network "private_network", ip: "10.0.0.10"
  config.vm.network "forwarded_port", guest: 80, host: 50000
  config.vm.provision :shell, path: "provision.sh"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50", "--cpus", "1"]
    vb.memory = 512
  end
end
