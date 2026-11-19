#!/bin/bash
set -e

rm -rf feeds/luci/applications/luci-app-dae feeds/packages/net/dae
cp -rf clone/daepkg/luci-app-dae feeds/luci/applications/
cp -rf clone/daepkg/luci-lib-daeuniverse feeds/luci/libs/
cp -rf clone/daepkg/dae feeds/packages/net/

# 源码跟随 daepkg 的 PKG_VERSION（官方 tag 就是 v<PKG_VERSION>）
DAE_TAG="v$(sed -n 's/^PKG_VERSION:=//p' feeds/packages/net/dae/Makefile | sed 's/.*,//; s/)$//')"
git clone --recurse-submodules --depth=1 --branch "$DAE_TAG" https://github.com/daeuniverse/dae feeds/packages/net/dae/src

# dae 2.1.2 起要求 Go 1.27，25.12 的 golang/host 默认仍是 1.26
sed -i 's|^PKG_BUILD_DIR:=|PKG_BUILD_DEPENDS:=golang1.27/host\nPKG_BUILD_DIR:=|' feeds/packages/net/dae/Makefile

awk '{ print } index($0, "$(LN) ../v2ray/geosite.dat") { print "\t$(INSTALL_DIR) $(1)/lib/upgrade/keep.d"; print "\techo /etc/dae > $(1)/lib/upgrade/keep.d/dae" }' feeds/packages/net/dae/Makefile > feeds/packages/net/dae/Makefile.new && mv feeds/packages/net/dae/Makefile.new feeds/packages/net/dae/Makefile
grep -q 'keep.d/dae' feeds/packages/net/dae/Makefile || { echo 'diy: failed to add keep.d install line to dae Makefile'; exit 1; }
