# House.local - php vm for web-doctors!

This awesome vm is powered by a bunch cool and free community tools. It serves you a vagrant-box with a multi-version php environment powered by phpbrew.

## Getting started
This vm is powered by vagrant, so you can use all vagrant-related commands to start, stop and maintain your vagrant-box.

1. `git clone https://github.com/roman-1983/vm_php.git` 
2. `vagrant up`
3. Put the following lines into your hosts-file: 
    
        192.168.56.101   house.local
        192.168.56.101   project.local

4. Fire up your browser to http://house.local
5. Connect via `vagrant ssh` to run console

## Connect via ssh to house.local
You can simply connect via `ssh vagrant@house.local`. The password is: `vagrant`
If you want to connect through ssh-key, just add your public key to the vagrant-box with
    
    ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@house.local

## Automatic registering of vagrant hostname in hosts-file
You could run `vagrant plugin install vagrant-hostsupdater` to install the host-updateplugin (https://github.com/cogitatio/vagrant-hostsupdater).

## Features
t.b.d.

## How to get the PHP versions?
Enter `phpbrew known` on the console. You will get the following output

    7.0: 7.0.2, 7.0.1, 7.0.0 ...
    5.6: 5.6.17, 5.6.16, 5.6.15, 5.6.14, 5.6.13, 5.6.12, 5.6.11, 5.6.10 ...
    5.5: 5.5.31, 5.5.30, 5.5.29, 5.5.28, 5.5.27, 5.5.26, 5.5.25, 5.5.24 ...
    5.4: 5.4.45, 5.4.44, 5.4.43, 5.4.42, 5.4.41, 5.4.40, 5.4.39, 5.4.38 ...
    5.3: 5.3.29, 5.3.28, 5.3.27, 5.3.26 ...

## How to add a specific PHP version?
Just adjust the `config.sh` in the root-directory of the vm. It will look like

    HOUSE_PHP_VERSIONS=(5.3.29)	
    
If your want to install PHP `5.4` and `5.5` it will look like:

    HOUSE_PHP_VERSIONS=(5.3.29 5.4.45 5.5.31)	
    
After that you have to run `vagrant provision`.

## How to change to a specific PHP version?
t.b.d.
