#!/bin/bash
# install mysql

CURDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

LOGDIR=$CURDIR/log
addDir $LOGDIR

LOGFILE=$LOGDIR/install.log
date '+%Y-%m-%d %T - mysql install '> $LOGFILE
echo '==========================================='>> $LOGFILE
sname='msyql'

rootPassword='111111'
webRootPassword="ww111111"

VERSION='5.5.41';
PACKAGE_NAME='mysql-'$VERSION
PACKAGE=$PACKAGE_NAME'.tar.gz'
INSTALL_DIR=$CURDIR/$VERSION
TARGET_DIR='/usr/local/product/mysql-'$VERSION
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

function checkExist ()
{
    rpm -qa | grep mysql
    if [ $? -ne 0 ]; then
        rpm -e mysql
    fi
}

# open port:3306
function configFirewall ()
{
    addFirewallPort 3306/tcp
    reloadFirewall
}

function unpress ()
{
    cd $INSTALL_DIR
    tar -xzvf $PACKAGE | tee -a $LOGFILE
}


function makeAndInstall ()
{
    yum install cmake cmake-devel | tee -a $LOGFILE

    cd $INSTALL_DIR/$PACKAGE_NAME
    cmake . -LH or cmake . | tee -a $LOGFILE
    make clean && rm -f CMakeCache.txt
    cmake -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} \
        -DMYSQL_DATADIR=${TARGET_DIR}/data \
        -DWITH_INNOBASE_STORAGE_ENGINE=1  \
        -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
        -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
        -DWITH_READLINE=1 \
        -DENABLED_LOCAL_INFILE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
        -DMYSQL_TCP_PORT=3306 \
        -DEXTRA_CHARSETS=all \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci | tee -a $LOGFILE

    make && make install | tee -a $LOGFILE
}

function configure ()
{
    # user config
    cat /etc/group | grep mysql &> /dev/null
    if [ $? -ne 0 ]; then
        groupadd mysql
    fi
    id mysql
    if [ $? -ne 0 ]; then
        useradd -g mysql mysql
    fi
    chown -R mysql:mysql $TARGET_DIR

    # mysql init
    cd $TARGET_DIR
    cp support-files/my-medium.cnf /etc/my.cnf
    scripts/mysql_install_db --basedir=$TARGET_DIR --datadir=$TARGET_DIR/data --user=mysql
    cp support-files/mysql.server /etc/init.d/mysqld


    # environment variable
    grep 'mysql' /etc/profile &> /dev/null
    if [ $1 -ne 0 ]; then
        echo "PATH=$TARGET_DIR/bin:\$PATH" >> /etc/profile
        echo "export PATH" >> /etc/profile
        source /etc/profile
    fi

    # change default password for mysql.root
    ${TARGET_DIR}/bin/mysqladmin -u root password "${rootPassword}"
    # password for remote root
    ${TARGET_DIR}/bin/mysql -uroot -p${rootPassword} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${webRootPassword}' WITH GRANT OPTION"
}

function machineOnStart ()
{
    # auto start service when machine is started.
    systemctl enable mysqld
    # start service now.
    systemctl restart mysqld
}

# entrance
function index ()
{
    clearOldLog
    checkExist
    configFirewall | tee -a $LOGFILE
    unpress
    # make ane make install
    makeAndInstall
    # configure
    configure
    # config start when machine starting.
    machineOnStart
}