Настройка Микротика с нуля:

Настроим микротик в домашней сети:

Internet - Router (192.168.4.254/24) - Mikrotik (192.168.4.1/24) - Devices 192.168.4.100-200/24

TODO: Если микротик не досупен, придумать автоматическое переключение обратно на zuxel

Welcome to RouterOS!
   1) Set a strong router password in the System > Users menu
   2) Upgrade the software in the System > Packages menu
   3) Enable firewall on untrusted networks
   4) Set your country name to observe wireless regulations
-----------------------------------------------------------------------------
RouterMode:
 * WAN port is protected by firewall and enabled DHCP client
 * Wireless and Ethernet interfaces (except WAN port/s)
   are part of LAN bridge
LAN Configuration:
    IP address 192.168.88.1/24 is set on bridge (LAN port)
    DHCP Server: enabled;
    DNS: enabled;
wlan1 Configuration:
    mode:                ap-bridge;
    band:                2ghz-b/g/n;
    tx-chains:           0;1;
    rx-chains:           0;1;
    installation:        indoor;
    wpa2:      no;
    ht-extension:        20/40mhz-XX;
wlan2 Configuration:
    mode:                ap-bridge;
    band:                5ghz-a/n/ac;
    tx-chains:           0;1;
    rx-chains:           0;1;
    installation:        indoor;
    wpa2:      no;
    ht-extension:        20/40/80mhz-XXXX;
WAN (gateway) Configuration:
    gateway:  ether1 ;
    ip4 firewall:  enabled;
    ip6 firewall:  enabled;
    NAT:   enabled;
    DHCP Client: enabled;
Login
    admin user protected by password

-------------------------------------------------------------------------------
You can type "v" to see the exact commands that are used to add and remove
this default configuration, or you can view them later with
'/system default-configuration print' command.
To remove this default configuration type "r" or hit any other key to continue.
If you are connected using the above IP and you remove it, you will be disconnected.
