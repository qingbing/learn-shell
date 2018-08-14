#!/bin/bash
# mysql testing

mc="/usr/local/product/mysql-5.5.41/bin/mysql -uroot -p111111"

case $1 in 
    delete)
        sql="DELETE FROM test.user WHERE id='$2'"
        ;;
    insert)
        sql="INSERT INTO test.user SET username='$2', password='$3'"
        ;;
    update)
        sql="UPDATE test.user SET username='$3', password='$4' WHERE id='$2'"
        ;;
    select|*)
        sql="SELECT * FROM test.user"
        ;;
esac

$mc -e "$sql"

if [ "$1"x != "select"x ]; then
    sql="SELECT * FROM test.user"
    $mc -e "$sql"
fi