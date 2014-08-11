![BVox](http://bvox.net/images/logo-bvox-big.png)
# knife-xenserver

Provision virtual machines with Citrix XenServer and Opscode Chef.

## Upgrading knife-xenserver

When upgrading knife-xenserver, it's very important to remove older knife-xenserver versions

    gem update knife-xenserver
    gem clean knife-xenserver

## Usage

    knife xenserver --help

In addition to knife-xenserver plugin, this extension allows us to check resources available on XenServer:

- Is there enough memory on any node available for VM (VM ram + 25% overhead; 3% of host node reserved)?
- Is there enough storage available for VM from template and associated disks (use 100% of requested size during checks)
- Supports configuration parameters in knife.rb which can override defaults

## Examples

List all the VMs

    knife xenserver vm list --xenserver-host fooserver \
                            --xenserver-username root \
                            --xenserver-password secret


List custom templates

    knife xenserver template list --xenserver-host fooserver \
                                  --xenserver-username root \
                                  --xenserver-password secret

Include built-in templates too

    knife xenserver template list --xenserver-host fooserver \
                                  --xenserver-username root \
                                  --xenserver-password secret \
                                  --include-builtin

Create a new template from a VHD file (PV by default, use --hvm otherwise)

    knife xenserver template create --vm-name ubuntu-precise-amd64 \
                                    --vm-disk ubuntu-precise.vhd \
                                    --vm-memory 512 \
                                    --vm-networks 'Integration-VLAN' \
                                    --storage-repository 'Local storage' \
                                    --xenserver-password changeme \
                                    --xenserver-host 10.0.0.2


Create a VM from template ed089e35-fb49-f555-4e20-9b7f3db8df2d and bootstrap it using the 'root' user and password 'secret'. The VM is created without VIFs, inherited VIFs from template are removed by default (use --keep-template-networks to avoid that)

    knife xenserver vm create --vm-template ed089e35-fb49-f555-4e20-9b7f3db8df2d \
                              --vm-name foobar --ssh-user root \
                              --ssh-password secret

Create a VM from template and add two custom VIFs in networks 'Integration-VLAN' and 'Another-VLAN', with MAC address 11:22:33:44:55:66 for the first VIF

    knife xenserver vm create --vm-template ed089e35-fb49-f555-4e20-9b7f3db8df2d \
                              --vm-name foobar --ssh-user root \
                              --ssh-password secret \
                              --vm-networks 'Integration-VLAN,Another-VLAN' \
                              --mac-addresses 11:22:33:44:55:66

Create a VM from template and supply ip/host/domain configuration. Requires installation of xe-automater scripts
(https://github.com/krobertson/xenserver-automater)

    knife xenserver vm create   --vm-template my-template -x root --keep-template-networks \
                                --vm-name my-hostname \
                                --vm-ip 172.20.1.25 --vm-netmask 255.255.0.0 --vm-gateway 172.20.0.1 --vm-dns 172.20.0.3 \
                                --vm-domain my-domain.local

The domU/guest will also need xe-guest-utilities installed. You can then list xenstore attributes running 'xenstore-ls vm-data' inside domU.

List hypervisor networks

    knife xenserver network list

## Sample .chef/knife.rb config

    knife[:xenserver_password] = "secret"
    knife[:xenserver_username] = "root"
    knife[:xenserver_host]     = "xenserver-real"

Vendavo specific config options:

    knife[:xen_use_additional_allocation_pct] = 80.0     # 80% of requested storage size is used for checking disk space availability (default 100%)
    knife[:xen_use_template_allocation_pct] = 50.0       # 50% of template storage size is used for checking disk space availability (default 100%)
    knife[:xen_max_storage_allocated_pct] = 90.0         # do not proceed when real storage utilization goes over 90% of storage size (allows overallocation; default 80%)
    knife[:xen_vm_ram_overhead_pct] = 20.0               # add 20% to new VM ram size in order to reflect memory overhead with this VM prior trying to find home server (default 25%)
    knife[:xen_host_max_ram_utilization_pct] = 97.0      # this is max memory utilization on one host node (default 95%)


# Building the rubygem

    gem build knife-xenserver.gemspec
