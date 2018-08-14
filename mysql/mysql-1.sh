#!/bin/bash
# mysql testing

mc="/usr/local/product/mysql-5.5.41/bin/mysql -uroot -p111111"
# 1. SHOW DATABASES;
# sql="SHOW DATABASES;"
# $mc -e "$sql"

# 2. SHOW TABLES FROM {table}
# sql="SHOW TABLES FROM test"
# $mc -e "$sql"

# 3. CREATE TABLE
# sql="CREATE TABLE test.webcount (
#     id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
#     date date,
#     ip VARCHAR(20),
#     num INT(11)
# )"
# $mc -e "$sql"

# 4. DESC {table}
# sql="DESC test.user;"
# $mc -e "$sql"

# 5. INSERT INTO {table} SET {field}={fieldVar},{field}={fieldVar}
# sql="INSERT INTO test.user SET username='user2', password='111'"
# $mc -e "$sql"

# 6. UPDATE {table} SET {field}={fieldVar},{field}={fieldVar} WHERE ...
# sql="UPDATE test.user SET username='user10',password=NULL WHERE id=3"
# $mc -e "$sql"

# 7. DELETE FROM {table} WHERE ...
# sql="DELETE FROM test.user WHERE id=3"
# $mc -e "$sql"


# 8. SELECT * FROM {table}
# sql="SELECT * FROM test.user"
# $mc -e "$sql"

# 9. DROP TABLE {table}
# sql="DROP TABLE test.user"
# $mc -e "$sql"

# 10. DROP databases {database}
# sql="DROP databases test1"
# $mc -e "$sql"