# seu-autologin
东南大学校园网自动登录脚本(截至2025年2月仍然可用)

Platform: Ubuntu 24.04

# Usage(安装路径默认/opt/seu-autologin/)
1. 克隆源代码
   
`git clone https://github.com/ChenYuWuAi/seu-autologin`

2. 拷贝并填写密码
   
`cd seu-autologin`

`sudo mkdir /opt/seu-autologin`

`sudo cp ./seu-autologin.sh /opt/seu-autologin/`

使用你最喜欢的编辑器编辑`seu-autologin.sh`的前几行，只需要加入学号和密码即可。

> 根据环境的不同，你需要进行基本测试，修改sh脚本判断是否连上SEU-WLAN的逻辑，或者开机延时

3. 设置权限(防止泄密)
   
`sudo chmod 700 /opt/seu-autologin/seu-autologin.sh`

4. 允许开机启动
   
`sudo cp ./seu-autologin.service /etc/systemd/system/`

`sudo systemctl daemon-reload`

`sudo systemctl enable seu-autologin.service`
# 日志查看
`sudo journalctl -u seu-autologin -b`
