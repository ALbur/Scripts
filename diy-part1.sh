#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
sed -i '10s/^/#/' feeds.conf.default

# Add a feed source
#echo 'src-git argon https://github.com/jerrykuku/luci-theme-argon' >>feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small.git;master' >>feeds.conf.default
echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default
echo 'src-git nas_istoreos https://github.com/istoreos/istoreos.git;main' >> feeds.conf.default
echo 'src-git nas_istore https://github.com/linkease/istore.git;main' >> feeds.conf.default
echo 'src-git nas_isp https://github.com/linkease/istore-packages.git;main' >> feeds.conf.default
echo 'src-git kenzok8 https://github.com/kenzok8/openwrt-packages.git;master' >> feeds.conf.default
