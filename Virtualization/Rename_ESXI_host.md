To rename a VMware ESX host:
If the ESX host is part of a cluster, drag it out of the cluster to remove it from the cluster.
If the ESX host is managed by VirtualCenter/vCenter, disconnect and remove the ESX host from the vCenter.
Make the modifications in your DNS environment to reflect the correct name and IP association for the new name.
Log in as root to the console of ESX host.
Using a text editor, change the name and domain name, if applicable, of the host in these files:
 
/etc/hosts
/etc/sysconfig/network
 
Run this command:

esxcfg-advcfg -s ESXi_FQDN /Misc/hostname
where ESXi_FQDN is the new FQDN hostname for the ESX host.
Reboot the ESX host.
Join the ESX host to VirtualCenter/vCenter Server and clusters.