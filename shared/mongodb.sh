#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="mongodb"
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
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

    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongod
    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongos
    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongo

    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongodump
    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongorestore
    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongoexport
    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongoimport
    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongofiles
    ln -nfs /opt/bin/ $QPKG_DIR/bin/mongostat

    mkdir -p /mnt/ext/opt/mongo/db
    
    mongod --dbpath=/mnt/ext/opt/mongo/db
    : ADD START ACTIONS HERE
    ;;

  stop)
    killall -9 mongod
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
