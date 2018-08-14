#!/bin/bash
# install php

CURDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

LOGDIR=$CURDIR/log
addDir $LOGDIR

LOGFILE=$LOGDIR/install.log
date '+%Y-%m-%d %T - php install '> $LOGFILE
echo '==========================================='>> $LOGFILE
sname='php'


VERSION='5.6.30';
PACKAGE_NAME='php-'$VERSION
PACKAGE=$PACKAGE_NAME'.tar.gz'
INSTALL_DIR=$CURDIR/$VERSION
TARGET_DIR='/usr/local/product/php'$VERSION
addDir $TARGET_DIR

# echo VERSION : $VERSION
# echo PACKAGE_NAME : $PACKAGE_NAME
# echo PACKAGE : $PACKAGE
# echo INSTALL_DIR : $INSTALL_DIR
# echo TARGET_DIR : $TARGET_DIR

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
    yum -y install libxml2 libxml2-devel libcurl libcurl-devel | tee -a $LOGFILE
    yum -y install libpng libpng-devel libjpeg libjpeg-devel freetype freetype-devel | tee -a $LOGFILE

    cd $INSTALL_DIR/$PACKAGE_NAME
    ./configure --prefix=${TARGET_DIR} \
        --enable-fpm \
        --enable-debug \
        --disable-short-tags \
        --enable-bcmath \
        --enable-calendar \
        --enable-exif \
        --enable-ftp \
        --enable-mbstring \
        --enable-opcache \
        --enable-pcntl \
        --enable-shmop \
        --enable-soap \
        --enable-sockets \
        --enable-sysvsem \
        --enable-zip \
        --enable-mysqlnd \
        --with-mysql=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-mysqli=mysqlnd \
        --with-gd \
        --with-jpeg-dir \
        --with-png-dir \
        --with-freetype-dir \
        --with-zlib \
        --enable-gd-native-ttf \
        --enable-gd-jis-conv | tee -a $LOGFILE
    make | tee -a $LOGFILE
    make install | tee -a $LOGFILE
}

function machineOnStart ()
{
    if [ ! -e $TARGET_DIR/etc/php-fpm.conf ]; then
        if [ -e $TARGET_DIR/etc/php-fpm.conf.default ]; then
            cp $TARGET_DIR/etc/php-fpm.conf.default $TARGET_DIR/etc/php-fpm.conf
        fi
    fi
    grep 'php-fpm' /etc/rc.local
    if [ $? -ne 0 ]; then
        echo "$TARGET_DIR/sbin/php-fpm" >> /etc/rc.local
    fi
}

function configure ()
{
    configFile=$TARGET_DIR/lib/php.ini
    if [ ! -e $configFile ]; then
        touch $configFile
    fi
    echo "date.timezone = PRC" >> $configFile
}

# entrance
function index ()
{
    clearOldLog
    unpress
    # make ane make install
    makeAndInstall
    # config start when machine starting.
    machineOnStart
    # configure
    configure
    $TARGET_DIR/sbin/php-fpm | tee -a $LOGFILE
}