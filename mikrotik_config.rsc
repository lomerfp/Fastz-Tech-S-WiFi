# ###########################################################
# Fastz Tech S-WiFi - Core MikroTik Configuration Script
# Target Device: MikroTik hEX / hAP Series
# Location Deployment: Lolachat / Nabilatuk, Uganda
# ###########################################################

/interface ethernet
set [ find default-name=ether1 ] name=ether1-WAN comment="Connected to 4G/5G Gateway Router"
set [ find default-name=ether2 ] name=ether2-LAN-AP comment="Connected to Ubiquiti Access Point"

/ip pool
add name=dhcp_hotspot_pool ranges=192.168.88.10-192.168.88.254

/ip dhcp-server
add address-pool=dhcp_hotspot_pool disabled=no interface=ether2-LAN-AP lease-time=1h name=dhcp_hotspot

/ip address
add address=192.168.88.1/24 interface=ether2-LAN-AP network=192.168.88.0

/ip dhcp-client
add comment="Fetch WAN dynamic IP from Airtel/MTN FWA Gateway" disabled=no interface=ether1-WAN

/ip dns
set allow-remote-requests=yes servers=8.8.8.8,1.1.1.1

/ip firewall nat
add action=masquerade chain=srcnat comment="Masquerade WAN traffic" out-interface=ether1-WAN

/ip hotspot profile
add hotspot-address=192.168.88.1 login-by=http-chap,http-pap name=Fastz_Profile use-radius=yes

/ip hotspot
add address-pool=dhcp_hotspot_pool disabled=no interface=ether2-LAN-AP name=Fastz_Hotspot profile=Fastz_Profile

/radius
add address=127.0.0.1 secret=FastzTechSecret2026 service=hotspot comment="Local API payment sync"
