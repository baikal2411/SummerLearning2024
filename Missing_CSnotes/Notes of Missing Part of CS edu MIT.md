# Missing Courses of CS MIT

## LECTURE Ⅰ     SHELL

[Source]: https://missing.csail.mit.edu/2020/course-shell/

using `cd -` to return last page.

## LECTURE Ⅱ SHELL TOOLS AND SCRIPTING

In general, in shell scripts the space character will perform argument splitting.

`bash` has functions that take arguments and can operate with them. Here is an example of a function that creates a directory and `cd`s into it.

```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```



## LECTURE Ⅲ EDITORS: VIM

normal mode 和 insert mode之间的切换 
$$
normal\ mode\left\{
\begin{aligned}
&insert\ mode\ (press \ i)\\
&replace\ mode \ (press \ R)\\
&visual\ mode\ (press\ v)\\
&visual\ mode\ (press\ shift+v)\\
&visual\ mode\ (press\ ctrl+v)\\
&command\ line\ (press\ :)
\end{aligned}
\right.
$$
VIM中存在多个标签页，每个标签页可以创建多个窗口，每个窗口对应一个缓冲区

**但特定的缓冲区可以在多个或者一个窗口中打开！**

正常模式如何交互？

`HJKL`

附录：菜鸟教程Linux

目录文件结构：[Linux 系统目录结构 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-system-contents.html)

![image-20240808222801545](D:\desktop\暑假计划\Missing_CSnotes\image-20240808222801545.png)

![image-20240808223211002](D:\desktop\暑假计划\Missing_CSnotes\image-20240808223211002.png)

使用`chgrp`更改文件属组，使用`chown`以更改文件所有者，同时更改文件属组

使用二进制编码，利用`chmod`进行更改

例如：

```bash
chmod u=rwx,g=rx,o=r test1
```

![image-20240808230156039](D:\desktop\暑假计划\Missing_CSnotes\image-20240808230156039.png)

使用下述命令去除全部的可执行权限

```bash
chmod a-x test1
```

创建多层目录：（以下命令都可以使用man命令来查看）

![image-20240809095120265](D:\desktop\暑假计划\Missing_CSnotes\image-20240809095120265.png)

![image-20240809095145597](D:\desktop\暑假计划\Missing_CSnotes\image-20240809095145597.png)

![image-20240809100157390](D:\desktop\暑假计划\Missing_CSnotes\image-20240809100157390.png)

![image-20240809100410536](D:\desktop\暑假计划\Missing_CSnotes\image-20240809100410536.png)

![image-20240809100828685](D:\desktop\暑假计划\Missing_CSnotes\image-20240809100828685.png)

![image-20240809133553349](D:\desktop\暑假计划\Missing_CSnotes\image-20240809133553349.png)

用户和用户组管理

[Linux 用户和用户组管理 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-user-manage.html)

Vim normal mode的几个常用命令：

![image-20240809195506591](D:\desktop\暑假计划\Missing_CSnotes\image-20240809195506591.png)

此外，以下按键需要熟练掌握：

![image-20240809201559314](D:\desktop\暑假计划\Missing_CSnotes\image-20240809201559314.png)

![image-20240809201809265](D:\desktop\暑假计划\Missing_CSnotes\image-20240809201809265.png)

![image-20240809201852272](D:\desktop\暑假计划\Missing_CSnotes\image-20240809201852272.png)

![image-20240809201834108](D:\desktop\暑假计划\Missing_CSnotes\image-20240809201834108.png)

Shell的参数传递

![image-20240809212739261](D:\desktop\暑假计划\Missing_CSnotes\image-20240809212739261.png)

其它

![image-20240809214835376](D:\desktop\暑假计划\Missing_CSnotes\image-20240809214835376.png)

注意，单引号是原样输出字符串，不进行取变量或者转义；使用反引号`进行显示命令执行结果

![image-20240809215858135](D:\desktop\暑假计划\Missing_CSnotes\image-20240809215858135.png)

![image-20240809223811075](D:\desktop\暑假计划\Missing_CSnotes\image-20240809223811075.png)