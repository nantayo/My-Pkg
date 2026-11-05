#!/bin/bash
set -e

rm -rf feeds/luci/applications/luci-app-dae feeds/packages/net/dae
cp -rf clone/daepkg/luci-app-dae feeds/luci/applications/
cp -rf clone/daepkg/luci-lib-daeuniverse feeds/luci/libs/
cp -rf clone/daepkg/dae feeds/packages/net/

# 固定在 b29e378（2026-10-30，main 上最后一个 go.mod 仍为 1.26 的提交）：
# 它已包含 dae#1110 修复（tproxy.c 里的 sock_bound_to_daddr 精确地址校验），
# 因此继续用 feed 默认的 golang/host（1.26）即可，无需引入 Go 1.27。
# 需要其它版本时用 DAE_REF=<commit> 覆盖（同样要求 go.mod <= 1.26）。
DAE_REF="${DAE_REF:-b29e3789deafd6b240913540141e740ba297eaa2}"
DAE_SRC=feeds/packages/net/dae/src
git clone --recurse-submodules --depth=1 https://github.com/daeuniverse/dae "$DAE_SRC"
if [ "$DAE_REF" != "main" ]; then
	git -C "$DAE_SRC" fetch --depth=1 origin "$DAE_REF"
	git -C "$DAE_SRC" checkout -q FETCH_HEAD
	git -C "$DAE_SRC" submodule update --init --recursive
fi
sed -i 's|^PKG_BUILD_DIR:=|PKG_BUILD_DEPENDS:=golang/host\nPKG_BUILD_DIR:=|' feeds/packages/net/dae/Makefile
# r99 便于与官方 2.1.1-r3/r5 区分，且排序更高，可直接升级覆盖
sed -i 's|^PKG_RELEASE:=.*|PKG_RELEASE:=99|' feeds/packages/net/dae/Makefile

echo "diy: dae $(git -C "$DAE_SRC" rev-parse --short=10 HEAD) ($(grep -m1 '^go ' "$DAE_SRC/go.mod"))"

awk '{ print } index($0, "$(LN) ../v2ray/geosite.dat") { print "\t$(INSTALL_DIR) $(1)/lib/upgrade/keep.d"; print "\t$(INSTALL_DATA) $(PKG_DIR)/files/keep.d/dae $(1)/lib/upgrade/keep.d/dae" }' feeds/packages/net/dae/Makefile > feeds/packages/net/dae/Makefile.new && mv feeds/packages/net/dae/Makefile.new feeds/packages/net/dae/Makefile
grep -q 'keep.d/dae' feeds/packages/net/dae/Makefile || { echo 'diy: failed to add keep.d install line to dae Makefile'; exit 1; }
