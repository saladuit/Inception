#!/bin/sh

mysql_install_db

# Function to wait for MariaDB server to start
wait_for_mariadb() {
  until mysqladmin ping -h "localhost" --silent; do
    echo "Waiting for MariaDB server to start..."
    sleep 2
  done
}

/etc/init.d/mysql start
wait_for_mariadb
# Set root option so that connection without root password is not possible

# Check if the database exists
if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then 
	echo "Database already exists"
else

mysql_secure_installation << _EOF_

Y
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
Y
n
Y
Y
_EOF_

# Add a root user on 127.0.0.1 to allow remote connection 
# Flush privileges allow to your sql tables to be updated automatically when you modify it
# mysql -uroot launch mysql command line client
echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

# Create database and user in the database for wordpress

echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root

# Verify SQL file before import
  if [ -f "/usr/local/bin/wordpress.sql" ]; then
    echo "Importing database schema from wordpress.sql..."
    mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql
  else
    echo "SQL file not found!"
  fi
fi

/etc/init.d/mysql stop

exec "$@"
