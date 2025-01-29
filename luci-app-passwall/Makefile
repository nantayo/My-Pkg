# Copyright (C) 2018-2020 L-WRT Team
# Copyright (C) 2021-2025 xiaorouji
#
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-passwall
PKG_VERSION:=25.1.28
PKG_RELEASE:=1

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_$(PKG_NAME)_Iptables_Transparent_Proxy \
	CONFIG_PACKAGE_$(PKG_NAME)_Nftables_Transparent_Proxy \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_Haproxy \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_Shadowsocks_Rust_Client \

LUCI_TITLE:=LuCI support for PassWall
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+coreutils +coreutils-base64 +coreutils-nohup +curl +dnsmasq-full +ip-full +libuci-lua +lua +luci-compat +luci-lib-jsonc +microsocks +resolveip +tcping

define Package/$(PKG_NAME)/config
menu "Configuration"
	depends on PACKAGE_$(PKG_NAME)

config PACKAGE_$(PKG_NAME)_Iptables_Transparent_Proxy
	bool "Iptables Transparent Proxy"
	select PACKAGE_ipset
	select PACKAGE_ipt2socks
	select PACKAGE_iptables
	select PACKAGE_iptables-zz-legacy
	select PACKAGE_iptables-mod-conntrack-extra
	select PACKAGE_iptables-mod-iprange
	select PACKAGE_iptables-mod-socket
	select PACKAGE_iptables-mod-tproxy
	select PACKAGE_kmod-ipt-nat
	default y if ! PACKAGE_firewall4

config PACKAGE_$(PKG_NAME)_Nftables_Transparent_Proxy
	bool "Nftables Transparent Proxy"
	select PACKAGE_ipt2socks
	select PACKAGE_nftables
	select PACKAGE_kmod-nft-socket
	select PACKAGE_kmod-nft-tproxy
	select PACKAGE_kmod-nft-nat
	default y if PACKAGE_firewall4

config PACKAGE_$(PKG_NAME)_INCLUDE_Haproxy
	bool "Include Haproxy"
	select PACKAGE_haproxy
	default y

config PACKAGE_$(PKG_NAME)_INCLUDE_Shadowsocks_Rust_Client
	bool "Include Shadowsocks Rust Client"
	select PACKAGE_shadowsocks-rust-sslocal
	default y

endmenu
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/passwall
/etc/config/passwall_server
/usr/share/passwall/rules/direct_host
/usr/share/passwall/rules/direct_ip
/usr/share/passwall/rules/proxy_host
/usr/share/passwall/rules/proxy_ip
/usr/share/passwall/rules/block_host
/usr/share/passwall/rules/block_ip
/usr/share/passwall/rules/lanlist_ipv4
/usr/share/passwall/rules/lanlist_ipv6
/usr/share/passwall/rules/domains_excluded
/www/luci-static/resources/qrcode.min.js
endef

define Package/$(PKG_NAME)/postrm
#!/bin/sh
rm -f $${IPKG_INSTROOT}/usr/share/passwall/rules/*.nft
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature