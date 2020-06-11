# Provision a bolt controller and various target systems
# - Sets up host file, hostnames, and SSH keys on each target
# - Just add project directory

SSH_KEY_FILE ||= File.join( ENV['VAGRANT_HOME'] || File.join(ENV['HOME'], '.vagrant.d'), 'insecure_private_key')

Vagrant.configure('2') do |c|
  c.ssh.insert_key = false

  c.vm.box = "centos/7"

  c.vm.define 'target7' do |v|
    v.vm.box = "centos/7"
    v.vm.network 'private_network', ip: '10.10.101.107'
    v.vm.provision 'set up hostname', type: 'shell', inline: <<-INLINE.gsub(/^ {6}/,'')
      hostnamectl set-hostname target7
    INLINE

  end
  c.vm.define 'target6' do |v|
    v.vm.box = "centos/6"
    v.vm.network 'private_network', ip: '10.10.101.106'
    v.vm.provision 'set up hostname', type: 'shell', inline: <<-INLINE.gsub(/^ {6}/,'')
      echo 'HOSTNAME=target6' >> /etc/sysconfig/network
      hostname target6
      service network restart
    INLINE
  end
  c.vm.define 'target8' do |v|
    v.vm.box = "centos/8"
    v.vm.network 'private_network', ip: '10.10.101.108'
    v.vm.provision 'set up hostname', type: 'shell', inline: <<-INLINE.gsub(/^ {6}/,'')
      hostnamectl set-hostname target8
    INLINE
  end

  c.vm.define 'bolt', primary: true do |v|
    v.vm.network 'private_network', ip: '10.10.101.101'

    v.vm.provision 'install bolt', type: 'shell', inline: <<-INLINE.gsub(/^ {6}/,'')
      rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-7.noarch.rpm
      yum install -y puppet-bolt
    INLINE

    v.vm.provision 'configure bolt', type: 'shell', privileged: false, inline: <<-INLINE.gsub(/^ {6}/,'')
      mkdir -p  ~/.puppetlabs/bolt
      echo 'disabled: true' >> ~/.puppetlabs/bolt/analytics.yaml
      ssh-keygen -N '' -f $HOME/.ssh/id_rsa
      rm -f $HOME/.ssh/id_rsa.pub
    INLINE

    v.vm.provision "file", source: SSH_KEY_FILE, destination: '~/.ssh/id_rsa'

    v.vm.provision 'set up ssh', type: 'shell', inline: <<-INLINE.gsub(/^ {6}/,'')
      echo '10.10.101.101   bolt' >> /etc/hosts
      echo '10.10.101.107   target7' >> /etc/hosts
      echo '10.10.101.106   target6' >> /etc/hosts
      echo '10.10.101.108   target8' >> /etc/hosts
    INLINE

    v.vm.provision 'set up hostname', type: 'shell', inline: <<-INLINE.gsub(/^ {6}/,'')
      hostnamectl set-hostname bolt
    INLINE

    v.trigger.after :up do |trigger|
      trigger.only_on = 'bolt'
      trigger.info = 'All VMs are built; setting up SSH'
      trigger.run_remote = {
        privileged: false,
        inline: "ssh -tt -oStrictHostKeyChecking=no target7 'exit 0'; ssh -tt -oStrictHostKeyChecking=no target6 'exit 0'; ssh -tt -oStrictHostKeyChecking=no target8 'exit 0'; echo FINIS"
      }
    end
  end
end
# vim: set syntax=ruby ts=2 sw=2 et:
