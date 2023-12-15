:: start 启动一个控制窗口
:: -c 设置启动参数，每个启动参数使用&&分隔
:: "" 用于执行计算机空白字符
:: ;bash 防止git-bash窗口关闭的结尾符号
start C:\Program" "Files\Git\git-bash.exe -c "git add .&&git commit -m 'automatic push origin'&&git push origin main;bash"