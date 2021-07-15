# nebula-graph-br-bin

nebula graph backup&restore script (use snapshot)

基于nebula-graph snapshot的备份恢复脚本

snapshot说明：*https://docs.nebula-graph.com.cn/2.0.1/7.data-security/3.manage-snapshot/*

nebula-console说明：*https://docs.nebula-graph.com.cn/2.0.1/2.quick-start/3.connect-to-nebula-graph/*

## 使用方式

    用法:

      备份
      ./nebula_br.sh backup [nebulahost] [port] [user] [password]

      删除备份
      ./nebula_br.sh delete [nebulahost] [port] [user] [password] [snapshotname]

      回滚到某个版本
      ./nebula_br.sh restore [nebulahost] [port] [user] [password] [snapshotname] [restartnebulacommand]

      查看所有备份
      ./nebula_br.sh show [nebulahost] [port] [user] [password]
      
`nebulahost` : graphd服务所在地址。  example：*localhost*, *192.168.78.12*

`port` : graphd服务所使用端口. example：*9669*

`user` : 设置Nebula Graph账号的用户名。未启用身份认证时，用户名可以填写任意字符。

`password` : 设置用户名对应的密码。未启用身份认证时，密码可以填写任意字符。

`snapshotname` : snapshot名称

`restartnebulacommand` : 你重启nebula-graph的脚本命令，在回滚时重启服务使用

## 示例




## 注意事项

1. 脚本在第一次使用时会下载nebula-console源码并进行编译，请确保你的机器存在go.
   
   如果编译不成功，可在脚本同级目录下创建`nebula-console`文件夹，将官方编译好的可执行文件，放入其中。并将文件名称改为`nebula-console`
   
2. 回滚恢复操作需要在nebula-graph的各个节点操作，因此需要：执行脚本的机器能免密登录到各个nebula-graph节点
