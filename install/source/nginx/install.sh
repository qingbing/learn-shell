#!/bin/bash
# install nginx

CURDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

LOGDIR=$CURDIR/log
addDir $LOGDIR

LOGFILE=$LOGDIR/install.log
date '+%Y-%m-%d %T - nginx install '> $LOGFILE
echo '==========================================='>> $LOGFILE

TARGET_DIR='/usr/local/product/nginx'
addDir $TARGET_DIR

sname='nginx'

VERSION='1.6.2';
PACKAGE_NAME='nginx-'$VERSION
PACKAGE=$PACKAGE_NAME'.tar.gz'
INSTALL_DIR=$CURDIR/$VERSION
WEBROOT=/data/web
addDir $WEBROOT

# echo "VERSION : "$VERSION
# echo "PACKAGE_NAME : "$PACKAGE_NAME
# echo "PACKAGE : "$PACKAGE
# echo "INSTALL_DIR : "$INSTALL_DIR
# echo "TARGET_DIR : "$TARGET_DIR


function clearOldLog ()
{
    # remove logfile
    rm -f $LOGFILE
    # remove tar file.
    rm -rf $INSTALL_DIR/$PACKAGE_NAME
}

function unpress ()
{
    cd $INSTALL_DIR
    tar -xzvf $PACKAGE | tee -a $LOGFILE
}


function makeAndInstall ()
{
    cd $INSTALL_DIR/$PACKAGE_NAME
    ./configure --prefix=$TARGET_DIR --with-http_ssl_module --with-pcre | tee -a $LOGFILE
    make | tee -a $LOGFILE
    make install | tee -a $LOGFILE
}

# open port:80
function configFirewall ()
{
    addFirewallPort 80/tcp
    reloadFirewall
}

function configure ()
{
    cd $TARGET_DIR/conf
    cp nginx.conf nginx.conf.bak
    addDir vhosts
    cd $INSTALL_DIR
    cp nginx.conf $TARGET_DIR/conf/nginx.conf
}

function machineOnStart ()
{
    echo 
}

function addHost ()
{
    domain=$1
    hostWebroot="$WEBROOT/$domain"
    # entrance the install directory.
    cd $INSTALL_DIR
    if [ -e host.conf.tmp ]; then
        rm -f host.conf.tmp
    fi

    # create the config file for host.
    cp -f host.conf host.conf.tmp
    sed -i "s!{webroot}!${WEBROOT}!g" host.conf.tmp
    sed -i "s!{domain}!${domain}!g" host.conf.tmp
    mv host.conf.tmp $TARGET_DIR/conf/vhosts/${domain}.conf

    # create testing html
    addDir $hostWebroot
    if [ -e index.html.tmp ]; then
        rm -f index.html.tmp
    fi
    cp -f index.html index.html.tmp
    sed -i "s!{domain}!${domain}!g" index.html.tmp
    mv index.html.tmp $hostWebroot/index.html
}

# entrance
function index ()
{
    clearOldLog
    configFirewall | tee -a $LOGFILE
    unpress
    # make ane make install
    makeAndInstall
    # config start when machine starting.
    machineOnStart
    # config nginx
    configure
    # add a test host
    addHost 'test.us'
    # start service
    service nginx restart
}