#!/bin/sh
echo SOURCECODEURL: "$SOURCECODEURL"
echo PKGNAME: "$PKGNAME"
echo BOARD: "$BOARD"

WORKDIR="$(pwd)"

sudo -E apt-get update
sudo -E apt-get install git  asciidoc bash bc binutils bzip2 fastjar flex gawk gcc genisoimage gettext git intltool jikespg libgtk2.0-dev libncurses5-dev libssl1.0-dev make mercurial patch perl-modules python2.7-dev rsync ruby sdcc subversion unzip util-linux wget xsltproc zlib1g-dev zlib1g-dev -y


mkdir -p  ${WORKDIR}/buildsource
cd  ${WORKDIR}/buildsource
git clone "$SOURCECODEURL"
cd  ${WORKDIR}


mips_siflower_sdk_get()
{
	 git clone https://github.com/gl-inet-builder/openwrt-siflower-1806.git openwrt
}

axt1800_sdk_get()
{
	wget -q -O openwrt.tar.xz https://fw.gl-inet.com/releases/v21.02-SNAPSHOT/sdk/openwrt-ipq807x-ipq60xx_gcc-5.5.0_musl_eabi.Linux-x86_64.tar.xz
	mkdir -p ${WORKDIR}/openwrt
	tar -Jxf openwrt.tar.xz -C ${WORKDIR}/openwrt --strip=1
	echo src-git packages https://git.openwrt.org/feed/packages.git^78bcd00c13587571b5c79ed2fc3363aa674aaef7 >${WORKDIR}/openwrt/feeds.conf.default
	echo src-git routing https://git.openwrt.org/feed/routing.git^a0d61bddb3ce4ca54bd76af86c28f58feb6cc044 >>${WORKDIR}/openwrt/feeds.conf.default
	echo src-git telephony https://git.openwrt.org/feed/telephony.git^0183c1adda0e7581698b0ea4bff7c08379acf447 >>${WORKDIR}/openwrt/feeds.conf.default
	echo src-git luci https://git.openwrt.org/feed/routing.git^a0d61bddb3ce4ca54bd76af86c28f58feb6cc044 >>${WORKDIR}/openwrt/feeds.conf.default
	
	sed -i '246,258d' ${WORKDIR}/openwrt/include/package-ipkg.mk
}

mt7981_sdk_get()
{
	 git clone https://github.com/gl-inet-builder/openwrt-mt7981.git  openwrt
}
mt7621_sdk_get()
{
	 git clone https://github.com/gl-inet-builder/openwrt-ramips-1907.git  openwrt
}
msm8916_sdk_get()
{
	 git clone https://github.com/HandsomeMod/HandsomeMod.git  openwrt
}

case "$BOARD" in
	"SF1200" |\
	"SFT1200" )
		mips_siflower_sdk_get
		echo CONFIG_ALL=y >.config
	;;
	"AXT1800" )
		axt1800_sdk_get
		echo CONFIG_ALL=y >.config
	;;
	"MT2500" )
		mt7981_sdk_get
		echo CONFIG_ALL=y >.config
	;;
  	"MT1300" )
		mt7621_sdk_get
		echo CONFIG_ALL=y >.config
	;;
	"MSM8916" )
		msm8916_sdk_get
		echo "CONFIG_PACKAGE_${PKGNAME}=m" >> ipk.config
		mv ipk.config openwrt/.config
	;;
	*)
esac

cd openwrt
sed -i "1i\src-link githubaction ${WORKDIR}/buildsource" feeds.conf.default

ls -l
cat feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
echo -e "$(nproc) thread compile"
make -j$(nproc) || make -j1 || make -j1 V=s
echo "::set-output name=status::success"
find bin -type f -exec ls -lh {} \;
find bin -type f -name "*.ipk" -exec cp -f {} "${WORKDIR}" \; 
