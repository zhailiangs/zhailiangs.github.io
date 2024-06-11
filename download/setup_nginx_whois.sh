#!/bin/bash

# 获取当前服务器的IP地址
SERVER_IP=$(hostname -I | awk '{print $1}')

# 定义网站配置文件目录
CONFIG_DIR="/usr/local/nginx/conf/vhost"
WEBSITE_DIR="/home/wwwroot/whois"
NGINX_CONF="${CONFIG_DIR}/whois.conf"

# 创建网站目录
mkdir -p $WEBSITE_DIR

# 下载whois.php到网站目录
curl -o ${WEBSITE_DIR}/whois.php https://zhailiangs.github.io/download/whois.php

# 随机生成一个非80和443的端口
while :; do
    PORT=$((RANDOM % 64535 + 1024))
    if [[ $PORT -ne 80 && $PORT -ne 443 ]]; then
        break
    fi
done

# 创建Nginx配置文件
cat > $NGINX_CONF <<EOF
server {
    listen ${PORT};
    server_name ${SERVER_IP};

    root ${WEBSITE_DIR};
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    include enable-php.conf;
}
EOF

# 检查CentOS版本并重新加载Nginx
/etc/init.d/nginx reload

echo "Nginx configuration for whois site created successfully!"
echo "You can access the site at http://${SERVER_IP}:${PORT}/whois.php"

