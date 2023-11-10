[Источник](https://mikrotik.axiom-pro.ru/articles/miktotik-nachalnaia-nastroika.php)
## === Установка и установка пароля администратора ===

    # Скачиваем образ с [сайта](https://mikrotik.com/download) (я качал OVA для удобства)
    # Регистрируем в VMware
    # заходим в машину - admin (без пароля)
    # устанавливаем пароль

## === Шаг 1. Начальные приготовления ===

    # Обезопасим Mikrotik путем отключения админа (брутят именно его пароль)

`[admin@MikroTik] > use add name=username password=userpassword group=full` - мы создали пользователя

`[admin@MikroTik] > quit` - вышли из учетки админа

`[sitis@MikroTik] > user disable admin` - отключили учетку admin

`[sitis@MikroTik] > user print` - посмотрели какие учетки есть

## === Шаг 2. Настройка интерфейсов ===

`[sitis@MikroTik] > interface print` - смотрим список интерфейсов

    Flags: R - RUNNING
    Columns: NAME, TYPE, ACTUAL-MTU, MAC-ADDRESS
    #   NAME    TYPE   ACTUAL-MTU  MAC-ADDRESS      
    0 R ether1  ether        1500  00:0C:29:0D:F3:3A

`[sitis@MikroTik] > interface enable 0` - Активируем интерфейс 0, который будет подключен к провайдеру и зададим ему ip адрес.

`[sitis@MikroTik] > ip address add address=192.168.4.1/24 interface=ether1` - задали ip адрес интерфейсу ether1 (в нашем случае с номером 0)

`[sitis@MikroTik] > ip address print` - смотрим появился ли ip адрес у интерфейса

`[sitis@MikroTik] > ip route add gateway=192.168.4.254` - указываем шлюз по умолчанию

`[sitis@MikroTik] > ip route print` - смотрим таблицу мартшрутизации

## === Шаг 3. Настройка DNS. ===

`[sitis@MikroTik] > ip dns set servers=8.8.8.8,8.8.4.4` - назначили гугловские dns 

`[sitis@MikroTik] > ip dns print` - проверили

                          servers: 8.8.8.8,8.8.4.4
                  dynamic-servers: 
                   use-doh-server: 
                  verify-doh-cert: no
            allow-remote-requests: yes
              max-udp-packet-size: 4096
             query-server-timeout: 2s
              query-total-timeout: 10s
           max-concurrent-queries: 100
      max-concurrent-tcp-sessions: 20
                       cache-size: 2048KiB
                    cache-max-ttl: 1w
                       cache-used: 91KiB


## === Шаг 4. Настройка доступа к сети интернет. ===

`[mkt@MikroTik] > ip firewall nat add chain=srcnat action=masquerade
out-interface=!ether2` - дали доступ к интернету интерфейсу 2 (я не настраивал его, но в если 2 интерфейса то второй иметь доступа не будет)

        # добаляем правила для служебных пакетов

`[mkt@MikroTik] > ip firewall filter add chain=forward connection-state=invalid
action=drop comment="Drop invalid connection packets"`

`[mkt@MikroTik] > ip firewall filter add chain=forward connection-state=established
action=accept comment="Allow established connections"`

`[mkt@MikroTik] > ip firewall filter add chain=forward connection-state=related
action=accept comment="Allow related connections"`

`[mkt@MikroTik] > ip firewall filter add chain=forward protocol=udp
action=accept comment="Allow UDP"`

`[mkt@MikroTik] > ip firewall filter add chain forward protocol=icmp
action=accept comment="Allow ICMP Ping"`

    # Дальше добавляем правила для машины PC4.

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.10/32
action=accept comment="Allow all for admin"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.10/32
action=accept comment="Allow all for admin"`

    # Разрешаем работу сервера до протоколу http, smtp, pop.

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.2/32
protocol=tcp src-port=80 action=accept comment="Allow http for server (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.2/32
protocol=tcp dst-port=80 action=accept comment="Allow http for server (out)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.2/32
protocol=tcp src-port=25 action=accept comment="Allow smtp for server (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.2/32
protocol=tcp dst-port=25 action=accept comment="Allow smtp for server (out)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.2/32
protocol=tcp src-port=110 action=accept comment="Allow pop for server (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.2/32
protocol=tcp dst-port=110 action=accept comment="Allow pop for server (out)"`

    # Таким же образом задаем правила для остальных машин, разрешая им http, https, ftp, icq, jabber.

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.20/32
protocol=tcp src-port=80 action=accept comment="Allow http for pc1 (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.20/32
protocol=tcp dst-port=80 action=accept comment="Allow http for pc1 (out)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.20/32
protocol=tcp src-port=443 action=accept comment="Allow https for pc1 (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.20/32
protocol=tcp dst-port=443 action=accept comment="Allow https for pc1 (out)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.20/32
protocol=tcp src-port=21 action=accept comment="Allow ftp for pc1 (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.20/32
protocol=tcp dst-port=21 action=accept comment="Allow ftp for pc1 (out)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.20/32
protocol=tcp src-port=5190 action=accept comment="Allow icq for pc1 (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.20/32
protocol=tcp dst-port=5190 action=accept comment="Allow icq for pc1 (out)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward dst-address=192.168.0.20/32
protocol=tcp src-port=5222 action=accept comment="Allow jabber for pc1 (in)"`

`[mkt@MikroTik] > ip firewall filter add chain=forward src-address=192.168.0.20/32
protocol=tcp dst-port=5222 action=accept comment="Allow jabber for pc1 (out)"`

    # Повторяем эти правила для каждой машины, если необходимо разрешить дополнительные порты, то шаблон написания, я думаю, понятен.

    # Ну и под конец запрещаем все остальное, что не разрешили выше.

`[mkt@MikroTik] > ip firewall filter add chain=forward action=drop comment="Drop all"`

## === Шаг 5. Входящие. ===

    # Теперь надо разрешить что бы входящие соединения по http, smtp и pop автоматически попадали бы на сервер.

`[mkt@MikroTik] > ip firewall nat add chain=dstnat dst-address=192.168.1.116/32
protocol=tcp dst-port=80 action=dst-nat to-addresses=192.168.0.2 to-ports=80
comment="NAT for http"`

`[mkt@MikroTik] > ip firewall nat add chain=dstnat dst-address=192.168.1.116/32
protocol=tcp dst-port=25 action=dst-nat to-addresses=192.168.0.2 to-ports=25
comment="NAT for smtp"`

`[mkt@MikroTik] > ip firewall nat add chain=dstnat dst-address=192.168.1.116/32
protocol=tcp dst-port=110 action=dst-nat to-addresses=192.168.0.2 to-ports=110
comment="NAT for pop"`

    # Если мы говорим про абсолютный минимум и простоту, это на этом все. Какие действия были сделаны?
       - Были включены два интерфейса ether1 и ether2.
       - Назначены ip адреса для интерфейсов.
       - Назначен шлюз по умолчанию.
       - Заданы DNS сервера.
       - Прописаны правила для машин с неограниченным доступом.
       - Прописаны правила для машин с ограниченным доступом по портам.
       - Прописаны правила преобразования сетевых адресов для доступа из вне к веб и почтовому серверам.











