Vagrant.configure('2') do |c|
  c.ssh.insert_key = false

  c.vm.box = "centos/7"
  c.vm.define 'target' do |v|
    v.vm.network 'private_network', ip: '10.10.101.102'
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

    ssh_key_file = File.join( ENV['VAGRANT_HOME'] || File.join(ENV['HOME'], '.vagrant.d'), 'insecure_private_key')
    v.vm.provision "file", source: ssh_key_file, destination: '~/.ssh/id_rsa'

    v.vm.provision 'set up ssh', type: 'shell', inline: <<-INLINE.gsub(/^ {6}/,'')
      echo '10.10.101.101   bolt' >> /etc/hosts
      echo '10.10.101.102   target' >> /etc/hosts
    INLINE

    v.trigger.after :up do |trigger|
      trigger.only_on = 'bolt'
      trigger.info = 'All VMs are built; setting up SSH'
      trigger.run_remote = {
        privileged: false,
        inline: "ssh -tt -oStrictHostKeyChecking=no target"
      }
    end
  end


end
# vim: set syntax=ruby ts=2 sw=2 et:
