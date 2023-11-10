## ===============Первоначальная настройка сети CentOS====================

1) Смотри какие интерфейсы у нас есть:

   ```$ ip a```

    ```
    [sitis@GitLAB ~]$ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
           valid_lft forever preferred_lft forever
    2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
        link/ether 00:0c:29:f2:8e:96 brd ff:ff:ff:ff:ff:ff
        inet 192.168.4.2/24 brd 192.168.4.255 scope global noprefixroute ens192
           valid_lft forever preferred_lft forever
        inet6 fe80::fac8:c380:f895:9d79/64 scope link noprefixroute 
           valid_lft forever preferred_lft forever
    ```
    
    смотрим название интерфейса в нашем случае "ens192"
2) Редактируем файл настроек сети

   ```$ sudo vi /etc/sysconfig/network-scripts/ifcfg-ens192```

   ```
    TYPE=Ethernet
    PROXY_METHOD=none
    BROWSER_ONLY=no
    BOOTPROTO=static (можем написать dhcp)
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE=stable-privacy
    NAME=ens192
    UUID=dc102b55-6e20-4112-bc3f-37dd1da024fa
    DEVICE=ens192
    ONBOOT=yes
    IPADDR=192.168.4.2
    PREFIX=24
    GATEWAY=192.168.4.254
    DNS1=8.8.8.8
    DNS2=8.8.4.4
    IPV6_PRIVACY=no
    ```
3) После редактирования перезапускаем службу сети:

    ```$ sudo systemctl restart network```
## =======================================================================


