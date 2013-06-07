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

    ln -nfs $QPKG_DIR/bin/mongod /opt/bin/
    ln -nfs $QPKG_DIR/bin/mongos /opt/bin/
    ln -nfs $QPKG_DIR/bin/mongo /opt/bin/

    ln -nfs $QPKG_DIR/bin/mongodump /opt/bin/
    ln -nfs $QPKG_DIR/bin/mongorestore /opt/bin/
    ln -nfs $QPKG_DIR/bin/mongoexport /opt/bin/
    ln -nfs $QPKG_DIR/bin/mongoimport /opt/bin/
    ln -nfs $QPKG_DIR/bin/mongofiles /opt/bin/
    ln -nfs $QPKG_DIR/bin/mongostat /opt/bin/

    mkdir -p /mnt/ext/opt/mongo/db
    
    mongod --dbpath=/mnt/ext/opt/mongo/db --fork --logpath /mnt/ext/opt/mongo/log
    : ADD START ACTIONS HERE
    ;;

  stop)
    killall -2 mongod
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
