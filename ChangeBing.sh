#!/bin/bash

#设置拥有图片权限的用户名
username="lihouyuan271813"
#设置桌面桌布路径
userbkg="/share/CACHEDEV1_DATA/.qos_bgImg/$username/cumsImg.jpg"
#如需将图片保存到指定路径，就去掉下面注释设置保存文件夹路径（在 FileStation 里面右键文件夹属性可以看到路径）
savepath="/share/CACHEDEV1_DATA/Public/BingWallPapers/"
savepathUHD="/share/CACHEDEV1_DATA/Public/BingWallPapers/UHD"

#解析壁纸的下载地址，获取1080p与4k以上分辨率的壁纸
api=$(wget -t 5 --no-check-certificate -qO- "https://bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
echo $api|grep -q enddate||exit
link=$(echo https://bing.com$(echo $api|sed 's/.\+"urlbase"[:" ]\+//g'|sed 's/".\+//g')_1920x1080.jpg)
linkUHD=$(echo https://bing.com$(echo $api|sed 's/.\+"urlbase"[:" ]\+//g'|sed 's/".\+//g')_UHD.jpg)
date=$(echo $api|sed 's/.\+enddate[": ]\+//g'|grep -Eo 2[0-9]{7}|head -1)
#下载壁纸至临时文件夹
tmpfile=/tmp/$date"_bing.jpg"
tmpfileUHD=/tmp/$date"_bingUHD.jpg"
wget -t 5 --no-check-certificate $link -qO $tmpfile
wget -t 5 --no-check-certificate $linkUHD -qO $tmpfileUHD
[ -s $tmpfile ]||exit
#解析壁纸著作权信息
title=$(echo $api|sed 's/.\+"title":"//g'|sed 's/".\+//g')
copyright=$(echo $api|sed 's/.\+"copyright[:" ]\+//g'|sed 's/".\+//g')
word=$(echo $copyright|sed 's/(.\+//g'|sed 's/\//,/g'|sed 's/ //g')
if [ ! -n "$title" ]; then
	cninfo=$(echo $copyright|sed 's/，/"/g'|sed 's/,/"/g'|sed 's/(/"/g'|sed 's/ //g'|sed 's/\//_/g'|sed 's/)//g')
	title=$(echo $cninfo|cut -d'"' -f1)
	word=$(echo $cninfo|cut -d'"' -f2)
fi

#修改登陆页面信息
#rm -rf /mnt/HDA_ROOT/.config/.qos_config/login/standard_bg.jpg
cp -f $tmpfile /mnt/HDA_ROOT/.config/.qos_config/login/standard_bg.jpg &>/dev/null
echo -e $title $word >/mnt/HDA_ROOT/.config/.qos_config/login/standard_massage.msg
#将图片应用于用户桌面
cp -f $tmpfile $userbkg
chown $username:everyone $userbkg
#将图片保存到指定路径
cp -f $tmpfile $savepath/$date@${title}-${word}.jpg
chown $username:everyone $savepath/$date@${title}-${word}.jpg
cp -f $tmpfileUHD $savepathUHD/$date@${title}-${word}_UHD.jpg
chown $username:everyone $savepathUHD/$date@${title}-${word}_UHD.jpg

rm -rf /tmp/*_bing.jpg
rm -rf /tmp/*_bingUHD.jpg