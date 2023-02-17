## CREATE VM Template with cloud-init

1.  create new VM with 999 vm-id, enable qemu-agent

2.  select do not use any media

3.  set minimum spec, 1 core 1g ram, and remove storage

4.  network setting depend on your network setup like vlan etc

5.  after create, go to newly created vm > hardware and add cloud init drive and select local-lvm

6.  go to vm > Cloud-Init to set up coressponding info like username, password or ssh-key

7.  login into the proxmox host, download the cloud-init image
    `wget <image name>`

8.  run `qm set <VM-ID> --serial0 socket --vga serial0` to setup console view for the vm

9.  change the downloaded image name to qcow2, `mv abc.img to abc.qcow2`

10. then resize the newly qcow2 image to desire size, `qemu-img resize abc.qcow2 20G`

11. then import the img into disk `qm importdist <VM-ID> abc.qcow2 local-lvm`

12. go to the vm > Hardware > Disk > tick Discard if using SSD

13. change the vm boot order

14. the right click the vm on the left-side bar, select convert to template
