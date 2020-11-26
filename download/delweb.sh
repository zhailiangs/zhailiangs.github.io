#!/bin/sh
until [ $domain ]
do
  read -p "Please enter the Domain for delete : " domain
done
domainlist=(${domain//,/ })
for i in ${domainlist[@]}
do
   echo $i
done

until [ $issure ]
do
  read -p "Do you decide to delete the above domain name? (y or n): " issure
done

if [ $issure != 'y' ]
then
	exit
fi

for j in ${domainlist[@]}
do
   if [ $j ]
   then
       rm -f /usr/local/nginx/conf/vhost/$j.conf
       chattr -i /home/wwwroot/$j/.user.ini
       rm -rf /home/wwwroot/$j
   fi   
done
