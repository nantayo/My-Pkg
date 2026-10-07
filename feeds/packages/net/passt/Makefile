include $(TOPDIR)/rules.mk

PKG_NAME:=passt
PKG_VERSION:=2026.10.02
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-2026_10_02.cba3570.tar.gz
PKG_SOURCE_URL:=https://passt.top/passt/snapshot/
PKG_HASH:=7b81892b1070521ed217de672cdce43d7a37436e6f850cd04f2b63919ac484b6
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-2026_10_02.cba3570

PKG_MAINTAINER:=nantayo dev <sora1924@outlook.com>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=LICENSES/GPL-2.0-or-later.txt
PKG_CPE_ID:=cpe:/a:passt:passt

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/passt
  SECTION:=net
  CATEGORY:=Network
  TITLE:=passt/pasta user-mode networking
  URL:=https://passt.top/
endef

define Package/passt/description
  Unprivileged user-mode networking for VMs and containers.
  pasta is podman's default rootless network backend; this package
  also ships passt, passt-repair and pesto.
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) $(MAKE_FLAGS) passt pasta passt-repair pesto
endef

define Package/passt/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/passt $(1)/usr/bin/
	$(LN) passt $(1)/usr/bin/pasta
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/passt-repair $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/pesto $(1)/usr/bin/
endef

$(eval $(call BuildPackage,passt))