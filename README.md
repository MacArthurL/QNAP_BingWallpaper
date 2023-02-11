# QNAP_BingWallpaper
威联通(QNAP)实现自动将登陆界面和桌面背景更换为每日Bing壁纸
参考了两位大佬的代码，一是群晖的美化代码：https://github.com/shenhaiyu/DSM_Login_BingWallpaper，另一个是威联通的bingwallpaper套件：https://github.com/Jay-Young/qpkg
Bingwallpaper套件版只能更换登陆界面，通过google检索后发现个人桌面保存路径为/share/CACHEDEV1_DATA/.qos_bgImg/$username/cumsImg.jpg（453bmini机型）
文件需要使用编辑器对用户名和壁纸保存路径进行设置
威联通更改计划任务方式为：SSH连接后，获取root权限后，通过vi /etc/config/crontab进行编辑，计划任务为 0 0,4 * * * sh /share/Public/ChangeBing.sh > /dev/null 2>&1，其中/share/Public/ChangeBing.sh需要更换为美化文件上传路径。
重启crontab即可，crontab /etc/config/crontab && /etc/init.d/crond.sh restart
