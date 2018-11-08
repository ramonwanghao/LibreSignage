##
##  LibreSignage target config generator
##  for Apache 2 on Debian.
##

set -e
. build/scripts/conf.sh
. build/scripts/ldconf.sh

##
##  Configure apache2.
##

mkdir -p "$CONF_DIR/apache2";
{

echo '<VirtualHost *:80>';
if [ -n "$CONF_ADMIN_EMAIL" ]; then
	echo "	ServerAdmin $CONF_ADMIN_EMAIL";
fi
echo "	ServerName $CONF_NAME";
if [ -n "$CONF_ALIAS" ]; then
	echo "	ServerAlias $CONF_ALIAS";
fi
echo "	DocumentRoot $CONF_INSTALL_DIR/$CONF_NAME";
echo '	ErrorLog ${APACHE_LOG_DIR}/error.log';
echo '	CustomLog ${APACHE_LOG_DIR}/access.log combined';

echo '	RewriteEngine on';
echo '	RewriteRule ^/$ control [L,R=301]';

echo '	ErrorDocument 403 /errors/403/index.php';
echo '	ErrorDocument 404 /errors/404/index.php';
echo '	ErrorDocument 500 /errors/500/index.php';

echo "	<Directory \"$CONF_INSTALL_DIR/$CONF_NAME\">";
echo '		Options -Indexes';
echo '	</Directory>';


# Prevent access to 'data/', 'common/' and '/config'.
echo "	<DirectoryMatch \"^$CONF_INSTALL_DIR(/?)$CONF_NAME(/?)data(.+)\">";
echo '		RewriteEngine On';
echo '		RewriteRule .* - [R=404,L]';
echo '	</DirectoryMatch>';

echo "	<DirectoryMatch \"^$CONF_INSTALL_DIR(/?)$CONF_NAME(/?)common(.+)\">";
echo '		RewriteEngine On';
echo '		RewriteRule .* - [R=404,L]';
echo '	</DirectoryMatch>';

echo "	<DirectoryMatch \"^$CONF_INSTALL_DIR(/?)$CONF_NAME(/?)config(.+)\">";
echo '		RewriteEngine On';
echo '		RewriteRule .* - [R=404,L]';
echo '	</DirectoryMatch>';

# PHP config.
echo "	php_admin_flag file_uploads On"
echo "	php_admin_value upload_max_filesize 200M"
echo "	php_admin_value max_file_uploads 20"
echo "	php_admin_value post_max_size 210M"
echo "	php_admin_value memory_limit 300M"

echo '</VirtualHost>';

} > "$CONF_DIR/apache2/$CONF_NAME.conf"

# LibreSignage instance configuration.

mkdir -p "$CONF_DIR/libresignage/conf"
{

echo "<?php"
echo "return ["
echo "	'ADMIN_NAME' => '$CONF_ADMIN_NAME',"
echo "	'ADMIN_EMAIL' => '$CONF_ADMIN_EMAIL'"
echo "];"

} > "$CONF_DIR/libresignage/conf/01-admin-info.php"
