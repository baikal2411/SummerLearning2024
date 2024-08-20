# Chapter4 基础知识入门

## STM32F103体系架构

![image-20240705002420787](D:\desktop\暑假计划\stm32学习\image-20240705002420787.png)

![image-20240705002506881](D:\desktop\暑假计划\stm32学习\image-20240705002506881.png)

## STM32F103 时钟树

![image-20240705002613252](D:\desktop\暑假计划\stm32学习\image-20240705002613252.png)

![image-20240705002633178](D:\desktop\暑假计划\stm32学习\image-20240705002633178.png)

SystemInit 主要做了如下三个方面工作：
1） 复位 RCC 时钟配置为默认复位值（默认开始了 HIS）
2） 外部存储器配置
3） 中断向量表地址配置
HAL 库的 SystemInit 函数并没有像标准库的 SystemInit 函数一样进行时钟的初始化配置。HAL库的 SystemInit 函数除了打开 HSI 之外，没有任何时钟相关配置，所以使用 HAL 库我们必须编写自己的时钟配置函数。

![image-20240705125509418](D:\desktop\暑假计划\stm32学习\image-20240705125509418.png)

![image-20240705125632794](D:\desktop\暑假计划\stm32学习\image-20240705125632794.png)