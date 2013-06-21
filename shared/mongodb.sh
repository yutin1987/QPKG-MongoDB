#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="mongodb"
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
BIN_PATH=/bin
#WEB_SHARENAME=$(/sbin/getcfg SHARE_DEF defWeb -d Web -f /etc/config/def_share.info)
#SYS_WEB_PATH=$( /sbin/getcfg $WEB_SHARENAME path -f /etc/config/smb.conf)
#QPKG_WWW=$QPKG_DIR/www
#SYS_WWW=$SYS_WEB_PATH/drupal7_qs

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi

    chmod 755 $QPKG_DIR/bin/*
    ln -nfs $QPKG_DIR/bin/mongod $BIN_PATH/
    ln -nfs $QPKG_DIR/bin/mongos $BIN_PATH/
    ln -nfs $QPKG_DIR/bin/mongo $BIN_PATH/

    ln -nfs $QPKG_DIR/bin/mongodump $BIN_PATH/
    ln -nfs $QPKG_DIR/bin/mongorestore $BIN_PATH/
    ln -nfs $QPKG_DIR/bin/mongoexport $BIN_PATH/
    ln -nfs $QPKG_DIR/bin/mongoimport $BIN_PATH/
    ln -nfs $QPKG_DIR/bin/mongofiles $BIN_PATH/
    ln -nfs $QPKG_DIR/bin/mongostat $BIN_PATH/

    mkdir -p /mnt/ext/opt/mongo/db
    
    $QPKG_DIR/bin/mongod --dbpath=/mnt/ext/opt/mongo/db --fork --logpath /mnt/ext/opt/mongo/log
    : ADD START ACTIONS HERE
    ;;

  stop)
    killall -2 mongod

    rm -f $BIN_PATH/mongod
    rm -f $BIN_PATH/mongos
    rm -f $BIN_PATH/mongo

    rm -f $BIN_PATH/mongodump
    rm -f $BIN_PATH/mongorestore
    rm -f $BIN_PATH/mongoexport
    rm -f $BIN_PATH/mongoimport
    rm -f $BIN_PATH/mongofiles
    rm -f $BIN_PATH/mongostat

    : ADD STOP ACTIONS HERE
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
