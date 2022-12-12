#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-partt.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
sed -i '10s/^/#/' feeds.conf.default

# Add a feed source
#echo 'src-git ' >>feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small.git;master' >>feeds.conf.default
echo 'src-git kenzok8 https://github.com/kenzok8/openwrt-packages.git;master' >> feeds.conf.default
echo 'src-git netnasemusic https://github.com/maxlicheng/luci-app-unblockmusic.git;master' >>feeds.conf.default
