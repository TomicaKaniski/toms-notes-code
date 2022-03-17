:::::: check active routes (when NOT connected to VPN, before adding custom routes via PowerShell)

route print
:: ===========================================================================
:: Interface List
:: ...
:: ===========================================================================
:: 
:: IPv4 Route Table
:: ===========================================================================
:: Active Routes:
:: Network Destination        Netmask          Gateway       Interface  Metric
::           0.0.0.0          0.0.0.0     192.168.12.1   192.168.12.247     35
:: ...
::      192.168.12.0    255.255.255.0         On-link    192.168.12.247    291
::    192.168.12.247  255.255.255.255         On-link    192.168.12.247    291
::    192.168.12.255  255.255.255.255         On-link    192.168.12.247    291
:: ...
::   255.255.255.255  255.255.255.255         On-link         127.0.0.1    331
::   255.255.255.255  255.255.255.255         On-link    192.168.12.247    291
:: ...
:: ===========================================================================
:: Persistent Routes:
::   None
:: ...
