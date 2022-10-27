# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "- Please flash via Magisk Manager only!"
fi

# space
if [ "$BOOTMODE" == true ]; then
  ui_print " "
fi

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`realpath /dev/*/.magisk`
fi

# path
if [ "$BOOTMODE" == true ]; then
  MIRROR=$MAGISKTMP/mirror
else
  MIRROR=
fi
SYSTEM=`realpath $MIRROR/system`
PRODUCT=`realpath $MIRROR/product`
VENDOR=`realpath $MIRROR/vendor`
SYSTEM_EXT=`realpath $MIRROR/system/system_ext`
ODM=`realpath /odm`
MY_PRODUCT=`realpath /my_product`

# optionals
OPTIONALS=/sdcard/optionals.prop

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
ui_print " MagiskVersion=$MAGISK_VER"
ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
ui_print " "

# sdk
NUM=18
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API. You have to upgrade your"
  ui_print "  Android version at least SDK API $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  ui_print " "
fi

# mount
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/cust /vendor
  mount -o rw -t auto /dev/block/bootdevice/by-name/vendor /vendor
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi

# sepolicy.rule
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ -f $FILE ] && [ "`grep_prop sepolicy.sh $OPTIONALS`" != 1 ]; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# cleaning
ui_print "- Cleaning..."
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# function
permissive_2() {
sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  magiskpolicy --live "permissive *"\
fi\' $MODPATH/post-fs-data.sh
}
permissive() {
SELINUX=`getenforce`
if [ "$SELINUX" == Enforcing ]; then
  setenforce 0
  SELINUX=`getenforce`
  if [ "$SELINUX" == Enforcing ]; then
    ui_print "  Your device can't be turned to Permissive state."
    ui_print "  Using Magisk Permissive mode instead."
    permissive_2
  else
    setenforce 1
    sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  setenforce 0\
fi\' $MODPATH/post-fs-data.sh
  fi
fi
}

# permissive
if [ "`grep_prop permissive.mode $OPTIONALS`" == 1 ]; then
  ui_print "- Using device Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif [ "`grep_prop permissive.mode $OPTIONALS`" == 2 ]; then
  ui_print "- Using Magisk Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive_2
  ui_print " "
fi

# function
extract_lib() {
  for APPS in $APP; do
    ui_print "- Extracting..."
    FILE=`find $MODPATH/system -type f -name $APPS.apk`
    DIR=`find $MODPATH/system -type d -name $APPS`/lib/$ARCH
    mkdir -p $DIR
    rm -rf $TMPDIR/*
    unzip -d $TMPDIR -o $FILE $DES
    cp -f $TMPDIR/$DES $DIR
    ui_print " "
  done
}

# extract
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
DES=lib/`getprop ro.product.cpu.abi`/*
extract_lib
chmod 0755 $DIR/*

# version
APP=HEXEditor
PKG=com.myprog.hexedit
CURRENT=`pm list packages --show-versioncode | grep $PKG | sed -n -e "s/package:$PKG versionCode://p"`
NEW=120
DIR=/system/priv-app/$APP
ui_print "- Current app versionCode: $CURRENT"
ui_print "  New app versionCode: $NEW"
if [ "$CURRENT" == "$NEW" ]; then
  if [ -d $DIR/oat ]; then
    ui_print "  Copying oat..."
    cp -rf $DIR/oat $MODPATH/$DIR
  elif [ -d $DIR/odex ]; then
    ui_print "  Copying odex..."
    cp -rf $DIR/odex $MODPATH/$DIR
  elif [ -f $DIR/$APP.odex ]; then
    ui_print "  Copying odex..."
    cp -f $DIR/$APP.odex $MODPATH/$DIR
  fi
fi
ui_print " "

# grant
FILE=$MODPATH/system/priv-app/$APP/$APP.apk
if ! pm list package | grep -Eq $PKG; then
  ui_print "- Granting all runtime permissions..."
  RES=`pm install -g -i com.android.vending $FILE`
  RES=`pm uninstall -k $PKG`
  ui_print " "
fi

# power save
FILE=$MODPATH/system/etc/sysconfig/*
if [ "`grep_prop power.save $OPTIONALS`" == 1 ]; then
  ui_print "- $MODNAME will not be allowed in power save."
  ui_print "  It may save your battery but decreasing $MODNAME performance."
  for PKGS in $PKG; do
    sed -i "s/<allow-in-power-save package=\"$PKGS\"\/>//g" $FILE
    sed -i "s/<allow-in-power-save package=\"$PKGS\" \/>//g" $FILE
  done
  ui_print " "
fi

# /priv-app
if [ ! -d $SYSTEM/priv-app ]; then
  ui_print "- /system/priv-app is not supported"
  ui_print "  Moving to /system/app..."
  rm -rf $MODPATH/system/app
  mv -f $MODPATH/system/priv-app $MODPATH/system/app
  ui_print " "
fi




