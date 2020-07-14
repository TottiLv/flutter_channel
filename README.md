# flutter_channel
首先创建flutter模型

flutter create -t module flutter_module

然后创建原生iOS项目

在iOS项目中通过pod进入flutter模型

Podfile加入如下代码：

flutter_application_path = '../flutter_ios_module'

load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')



install_all_flutter_pods(flutter_application_path)
  
 
