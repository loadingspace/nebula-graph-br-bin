# nebula-graph-br-bin

nebula graph backup&restore script (use snapshot)

基于nebula-graph snapshot的备份恢复脚本

snapshot说明：*https://docs.nebula-graph.com.cn/2.0.1/7.data-security/3.manage-snapshot/*

nebula-console说明：*https://docs.nebula-graph.com.cn/2.0.1/2.quick-start/3.connect-to-nebula-graph/*

## 使用方式

！！！恢复功能restore需要配置，脚本服务器与nebula-graph各个节点的ssh免密登录

    用法:

      备份
      ./nebula_br.sh backup [nebulahost] [port] [user] [password]

      删除备份
      ./nebula_br.sh delete [nebulahost] [port] [user] [password] [snapshotname]

      恢复到某个版本
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

backup:

    [root@test nebula-br]# ./nebula_br.sh backup nebula-graph-1 9669 1 1
    nebula-consle is ok!
    2021/07/15 16:08:49 [INFO] connection pool is initialized successfully
    backup success! 
    
show:

    [root@test nebula-br]# ./nebula_br.sh show nebula-graphd1 9669 1 1
    nebula-consle is ok!
    2021/07/15 16:10:32 [INFO] connection pool is initialized successfully

    result:

       SNAPSHOT_2021_07_15_16_08_55   VALID   nebula-graph-1:9779,nebula-graph-3:9779,nebula-graph-3:9779   

    finish!
    
delete 

    [root@test nebula-br]# ./nebula_br.sh delete nebula-graphd1 9669 1 1 SNAPSHOT_2021_07_15_10_27_36
    nebula-consle is ok!
    2021/07/15 16:13:20 [INFO] connection pool is initialized successfully
    2021/07/15 16:13:20 [INFO] connection pool is initialized successfully
    delete success! 
    
restore

    [root@test nebula-br]# ./nebula_br.sh restore nebula-graph-1 9669 1 1 SNAPSHOT_2021_07_15_16_08_55 "/nebula/scripts/nebula.service restart all"
    nebula-consle is ok!
    /nebula/scripts/nebula.service restart all
    /nebula/scripts/nebula.service restart all
    2021/07/15 16:14:42 [INFO] connection pool is initialized successfully

    result:

       SNAPSHOT_2021_07_15_10_51_44   VALID   nebula-graph-1:9779,nebula-graph-2:9779,nebula-graph-3:9779   
       SNAPSHOT_2021_07_15_14_41_17   VALID   nebula-graph-1:9779,nebula-graph-2:9779,nebula-graph-3:9779   
       SNAPSHOT_2021_07_15_14_49_32   VALID   nebula-graph-1:9779,nebula-graph-2:9779,nebula-graph-3:9779   
       SNAPSHOT_2021_07_15_16_08_55   VALID   nebula-graph-1:9779,nebula-graph-2:9779,nebula-graph-3:9779   

    finish!

    正在处理 nebula-graph-1
    ssh nebula-graph-1 'bash -s' < /tmp/nebula-br/nebula_restore.sh SNAPSHOT_2021_07_15_16_08_55 "/nebula/scripts/nebula.service restart all"
    /nebula/scripts/nebula.service restart all
    开始覆盖数据文件...
    cover dir: /nebula/data/meta/nebula/0/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/11/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/32/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/33/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/89/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/94/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/99/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    执行重启命令...
    /nebula/scripts/nebula.service restart all
    [INFO] Stopping nebula-metad...
    [INFO] Done
    [INFO] Starting nebula-metad...
    [INFO] Done
    [INFO] Stopping nebula-graphd...
    [INFO] Done
    [INFO] Starting nebula-graphd...
    [INFO] Done
    [INFO] Stopping nebula-storaged...
    [INFO] Done
    [ERROR] nebula-storaged already running: 8030
    正在处理 nebula-graph-2
    ssh nebula-graph-2 'bash -s' < /tmp/nebula-br/nebula_restore.sh SNAPSHOT_2021_07_15_16_08_55 "/nebula/scripts/nebula.service restart all"
    /nebula/scripts/nebula.service restart all
    开始覆盖数据文件...
    cover dir: /nebula/data/storage/nebula/11/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/32/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/33/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/89/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/94/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/99/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    执行重启命令...
    /nebula/scripts/nebula.service restart all
    [INFO] Stopping nebula-metad...
    [INFO] Done
    [INFO] Starting nebula-metad...
    [INFO] Done
    [INFO] Stopping nebula-graphd...
    [INFO] Done
    [INFO] Starting nebula-graphd...
    [INFO] Done
    [INFO] Stopping nebula-storaged...
    [INFO] Done
    [INFO] Starting nebula-storaged...
    [INFO] Done
    正在处理 nebula-graph-3
    ssh nebula-graph-3 'bash -s' < /tmp/nebula-br/nebula_restore.sh SNAPSHOT_2021_07_15_16_08_55 "/nebula/scripts/nebula.service restart all"
    /nebula/scripts/nebula.service restart all
    开始覆盖数据文件...
    cover dir: /nebula/data/storage/nebula/11/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/32/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/33/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/89/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/94/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    cover dir: /nebula/data/storage/nebula/99/checkpoints/SNAPSHOT_2021_07_15_16_08_55
    执行重启命令...
    /nebula/scripts/nebula.service restart all
    [INFO] Stopping nebula-metad...
    [INFO] Done
    [INFO] Starting nebula-metad...
    [INFO] Done
    [INFO] Stopping nebula-graphd...
    [INFO] Done
    [INFO] Starting nebula-graphd...
    [INFO] Done
    [INFO] Stopping nebula-storaged...
    [INFO] Done
    [INFO] Starting nebula-storaged...
    [INFO] Done
    


## 注意事项

1. 脚本在第一次使用时会下载nebula-console源码并进行编译，请确保你的机器存在go.
   
   如果编译不成功，可在脚本同级目录下创建`nebula-console`文件夹，将官方编译好的可执行文件，放入其中。并将文件名称改为`nebula-console`
   
2. 回滚恢复操作需要在nebula-graph的各个节点操作，因此需要：执行脚本的机器能免密登录到各个nebula-graph节点
