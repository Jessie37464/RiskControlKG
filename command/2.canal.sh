#canal安装路径:/Users/zhengqixin/canal
# 参考：https://github.com/alibaba/canal/wiki/QuickStart

#1.下载canal
  wget https://github.com/alibaba/canal/releases/download/canal-1.1.6-alpha-1/canal.deployer-1.1.6-SNAPSHOT.tar.gz

#2.解压

#3.修改配置文件账号和密码
  vi conf/example/instance.properties

#4.启动
  sh bin/startup.sh

#5.查看 server 日志
  vi logs/canal/canal.log</pre>

#6.查看 instance 的日志
  vi logs/example/example.log

#7.关闭
  sh bin/stop.sh


