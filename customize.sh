ui_print " "

# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "- Please flash via Magisk Manager only!"
fi

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

# sepolicy.rule
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ -f $FILE ] && ! getprop | grep -Eq "sepolicy.sh\]: \[1"; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# cleaning
ui_print "- Cleaning..."
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
for APPS in $APP; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
rm -f $MODPATH/LICENSE
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# function
permissive() {
  SELINUX=`getenforce`
  if [ "$SELINUX" == Enforcing ]; then
    setenforce 0
    SELINUX=`getenforce`
    if [ "$SELINUX" == Enforcing ]; then
      ui_print "  ! Your device can't be turned to Permissive state."
    fi
    setenforce 1
  fi
  sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  setenforce 0\
fi\' $MODPATH/post-fs-data.sh
}

# permissive
if getprop | grep -Eq "permissive.mode\]: \[1"; then
  ui_print "- Using permissive method"
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif getprop | grep -Eq "permissive.mode\]: \[2"; then
  ui_print "- Using both permissive and SE policy patch"
  permissive
  ui_print " "
fi

# function
extract_lib() {
  for APPS in $APP; do
    ui_print "- Extracting $APPS.apk libs..."
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
PROP=`getprop ro.product.cpu.abi`
DES=lib/$PROP/*
extract_lib
chmod 0755 $DIR/*

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi

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
PROP=`getprop power.save`
FILE=$MODPATH/system/etc/sysconfig/*
if [ "$PROP" == 1 ]; then
  ui_print "- $MODNAME will not be allowed in power save."
  ui_print "  It may save your battery but decreasing $MODNAME performance."
  for PKGS in $PKG; do
    sed -i "s/<allow-in-power-save package=\"$PKGS\"\/>//g" $FILE
    sed -i "s/<allow-in-power-save package=\"$PKGS\" \/>//g" $FILE
  done
  ui_print " "
fi

# /priv-app
if [ "$BOOTMODE" == true ]; then
  DIR=$MAGISKTMP/mirror/system/priv-app
else
  DIR=/system/priv-app
fi
if [ ! -d $DIR ]; then
  ui_print "- /system/priv-app is not supported"
  ui_print "  Moving to /system/app..."
  rm -rf $MODPATH/system/app
  mv -f $MODPATH/system/priv-app $MODPATH/system/app
  ui_print " "
fi




