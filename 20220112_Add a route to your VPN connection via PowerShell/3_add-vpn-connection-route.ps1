### add custom route (to be active when connected to "MyWorkStuff" VPN)

Add-VpnConnectionRoute -ConnectionName "MyWorkStuff" -DestinationPrefix "192.168.13.0/24" -RouteMetric 1
