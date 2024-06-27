# MDK5 软件入门

MDK5 由两个部分组成：MDK Core 和 Software Packs。其中，
Software Packs 可以独立于工具链进行新芯片支持和中间库的升级
$$
Software \ Packs=\left\{
\begin{aligned}
&Device  \\
&CMSIS \\
&Middleware
\end{aligned}
\right.
$$

## 包目录组织结构 

### **Driver文件夹**

![image-20240624171820034](D:\desktop\暑假计划\stm32学习\正点原子hal库\image-20240624171820034.png)

![image-20240624182240740](D:\desktop\暑假计划\stm32学习\正点原子hal库\image-20240624182240740.png)

### **Middlewares文件夹**

![image-20240624182807947](D:\desktop\暑假计划\stm32学习\正点原子hal库\image-20240624182807947.png)

### **Projects文件夹**

该文件夹存放的是一些可以直接编译的实例工程。每个文件夹对应一个 ST 官方的 Demo板。

### **Utilities文件夹**

其它

## **组织自己的项目结构**

在MDK中建立工程后，会有几种类型的文件：

| Template.uvprojx | 工程文件，皆以.uprojx为后缀 |
| ---------------- | --------------------------- |
| DebugConfig      | 调试配置文件                |
| Listings         | 编译中间文件                |
| Objects          | 编译中间文件                |

