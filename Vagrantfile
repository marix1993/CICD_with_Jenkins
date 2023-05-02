Vagrant.configure("2") do |config|

  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/bionic64"
    # it allows us to connect to port 80, our web browser
    app.vm.network "private_network", ip: "192.168.10.100" 
    # provision the vm
    app.vm.provision "shell", path: "script.sh"
    # syncing the app folder
    app.vm.synced_folder "app", "/home/vagrant/app"

  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/bionic64"
    db.vm.network "private_network", ip: "192.168.10.150"
    db.vm.provision "shell", path: "C:/Users/Mateusz/Documents/tech221/virtualisation/environment/db_script/scriptdb.sh"
  end

end