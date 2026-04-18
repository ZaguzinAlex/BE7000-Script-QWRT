#!/bin/sh

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' 

echo -e "${YELLOW}=== Удаление пакетов и настройка локализации ===${NC}"

PACKAGES="IPv6-6in4|6in4 IPv6-6rd|6rd AQ-FW-Download|aq-fw-download DDNS-Aliyun|ddns-scripts_aliyun DDNS-Cloudflare|ddns-scripts_cloudflare.com-v4 DDNS-Dnspod|ddns-scripts_dnspod DDNS-FreeDNS|ddns-scripts_freedns_42_pl DDNS-GoDaddy|ddns-scripts_godaddy.com-v1 DDNS-No-IP|ddns-scripts_no-ip_com DDNS-Route53|ddns-scripts_route53-v1 Access-Control|luci-app-accesscontrol Fan-Control|luci-app-fancontrol IPSec-Server|luci-app-ipsec-server Modem-Data|luci-app-modem-data OpenClash|luci-app-openclash OpenVPN-Server|luci-app-openvpn-server RGB-Control-GUI|luci-app-rgbcontrol USB-Printer|luci-app-usb-printer ZModem|luci-app-zmodem OpenVPN-Easy-RSA|openvpn-easy-rsa OpenVPN-OpenSSL|openvpn-openssl PPP-PPPoE|ppp-mod-pppoe PPP-PPPoL2TP|ppp-mod-pppol2tp PPP-PPTP|ppp-mod-pptp RGB-Control-Core|rgbcontrol PPPoE-Common|rp-pppoe-common PPPoE-Relay|rp-pppoe-relay PPPoE-Server|rp-pppoe-server RPCD-RRDNS|rpcd-mod-rrdns Ruby-Base|ruby Ruby-BigDecimal|ruby-bigdecimal Ruby-Date|ruby-date Ruby-Enc|ruby-enc Ruby-StrScan|ruby-strscan SSR-Check|shadowsocksr-libev-ssr-check SSR-Local|shadowsocksr-libev-ssr-local SSR-Redir|shadowsocksr-libev-ssr-redir SSR-Server|shadowsocksr-libev-ssr-server SS-Rust-Local|shadowsocks-rust-sslocal Strongswan|strongswan Strongswan-IPSec|strongswan-ipsec Strongswan-GMP|strongswan-mod-gmp MSD-Lite|luci-app-msd_lite DDNS-en|luci-i18n-ddns-en DDNS-zh|luci-i18n-ddns-zh-cn VLMCSD-KMS|luci-app-vlmcsd ZeroTier-GUI|luci-app-zerotier ZeroTier-Core|zerotier AdBlock-GUI|luci-app-adblock AdBlock-Core|adblock Wireguard-Kernel|kmod-wireguard Wireguard-Tools|wireguard-tools"

for item in $PACKAGES; do
    name=$(echo "$item" | cut -d'|' -f1)
    pkg=$(echo "$item" | cut -d'|' -f2)

    echo -ne "Удалить ${RED}$name${NC} ($pkg)? (${YELLOW}y${NC}/${GREEN}n${NC}): "
    read res < /dev/tty

    if [ "$res" = "y" ]; then
        echo "Удаление $pkg..."
        opkg remove "$pkg" --force-remove --force-removal-of-dependent-packages
    fi
done

echo "Обновление списка пакетов..."
opkg update

echo -e "\n${YELLOW}Установка русской локализации...${NC}"
opkg install luci-i18n-base-ru luci-i18n-ddns-ru luci-i18n-firewall-ru luci-i18n-samba-ru luci-i18n-upnp-ru luci-i18n-wol-ru luci-i18n-statistics-ru

echo "Активация русского языка..."
uci set luci.main.lang=ru
uci commit luci
/etc/init.d/uhttpd restart

echo -e "${GREEN}Готово! Интерфейс переключен на русский.${NC}"
