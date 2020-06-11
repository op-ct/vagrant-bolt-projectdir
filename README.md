# vagrant-bolt-projectdir

<!-- vim-markdown-toc GFM -->

* [Description](#description)
* [Requirements](#requirements)
* [Usage](#usage)
* [Reference](#reference)
* [Limitations](#limitations)

<!-- vim-markdown-toc -->

## Description

A Vagrant project to
* provision a [Puppet Bolt][0] controller VM + various target VMs
* Serve as a functional Bolt project directory in `/vagrant`

## Requirements

* [Vagrant][2]
* [Puppet Bolt][3] 2.10.0+
* [VirtualBox][4]

## Usage

1. Customize the Bolt project directory however you need

2. Provision the VMs

   ```sh
   vagrant up
   ```
3. Log into the `bolt` controller

   ```ssh
   vagrant ssh bolt
   ```

4. Test-run Bolt shenanigans on your little private VM network to your heart's
   content.

## Reference

The Vagrantfile provisions the following VMs:

  | VM        | OS      | Purpose         |
  | --------- | ------- | --------------- |
  | `bolt`    | CentOS7 | Bolt controller |
  | `target8` | CentOS8 | EL8 target      |
  | `target7` | CentOS7 | EL7 target      |
  | `target6` | CentOS6 | EL6 target      |


During `vagrant up`, vagrant will:

- Configures the hostnames and SSH keys for each target VM
- Prepares the bolt controller VM to log into each target via SSH keys
- Once provisioned, `/vagrant` can serve as a functional [project directory][1]
  on the `bolt` controller VM.
  * `inventory.yaml` provides a `targets` group, and can access each target by
    name.
  * `bolt-project.yaml` turns `/vagrant` into a top-level directory for the
    `test::` namespace.

## Limitations

* This is just a simple Vagrantfile that spins up 4 VMs.  There's nothing fancy
  like the [oscar][5] stack's [vagrant-bolt][6] plugin.

[0]: https://puppet.com/open-source/bolt/
[1]: https://puppet.com/docs/bolt/latest/bolt_project_directories.html
[2]: https://www.vagrantup.com/
[3]: https://www.virtualbox.org/
[4]: https://puppet.com/docs/bolt/latest/bolt_installing.html
[5]: https://github.com/oscar-stack/oscar
[6]: https://github.com/oscar-stack/vagrant-bolt
