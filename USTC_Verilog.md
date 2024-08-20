

# **中国科技大学Verilog实验课程** 

[TOC]



## Chapter Ⅰ 基础概念

![image-20240812202206517](D:\desktop\暑假计划\image-20240812202206517.png)

#### 归约运算符与按位运算符

![image-20240812202422006](D:\desktop\暑假计划\image-20240812202422006.png)

![image-20240812202450180](D:\desktop\暑假计划\image-20240812202450180.png)

#### 移位运算符

![image-20240812204531517](D:\desktop\暑假计划\image-20240812204531517.png)

#### 拼接运算符

![image-20240812204817956](D:\desktop\暑假计划\image-20240812204817956.png)

#### 连续赋值：assign

![image-20240812205240681](D:\desktop\暑假计划\image-20240812205240681.png)

#### 过程赋值：always

![image-20240812205533293](D:\desktop\暑假计划\image-20240812205533293.png)

![image-20240812205646612](D:\desktop\暑假计划\image-20240812205646612.png)

#### 阻塞赋值和非阻塞赋值

![image-20240812205842729](D:\desktop\暑假计划\image-20240812205842729.png)

注意！

养成使用 `begin`/`end` 关键字的习惯

input、inout 类型的端口不能声明为 reg 数据类型，因为 reg 类型常用于保存数值，而输入端口只反映与其相连的外部信号的变化，不应保存这些信号的值。output 类型的端口则可以声明为 wire 或 reg 数据类型。

在 Verilog 中，wire 型为默认数据类型，因此当端口为 wire 型时，不用再次声明端口类型为 wire；但是当端口为 reg 型时，对应的 reg 声明不可省略。

#### Verilog的基本结构

```verilog
module FA (
    input           a, b, cin, 
    output          cout, 
    output reg      s
);
```

```verilog
module 模块名 (
    // 端口定义之间用英文逗号 , 分隔开
    输入端口定义,         // 输入端口只能是 wire 类型
    输出端口定义          // 输出端口可以根据需要定义为 wire 或 reg 类型
);                      // 不要忘记这里的分号

    内部信号定义语句       // 内部信号可以根据需要定义为 wire 或 reg 类型
    模块实例化语句         // 将其他模块接入电路
    assign 数据流赋值语句
    always 过程赋值语句
endmodule
```

#### 模块例化

首先定义一个模块

```verilog
module FA (
    input [7:0]         a, b,
    input               cin,
    output reg [7:0]    s,
    output              cout
);
```

在顶层模块中，我们定义如下变量：

```verilog
wire [7:0] num1, num2, sum;
wire cin, cout;
```

+ 基于位置的端口关联（不便）
+ 基于名字的端口关联（常用）

![image-20240812214113160](D:\desktop\暑假计划\image-20240812214113160.png)

![image-20240812214224174](D:\desktop\暑假计划\image-20240812214224174.png)

#### 参数传递

在编写子模块时并不预先指定位宽，而是在例化的时候根据需要确定位宽。此时我们可以使用 Verilog 的带参数例化功能：模块声明时使用 `parameter` 关键字指定参数，例化时将新的参数值写入模块例化语句，以此来改写子模块的参数值。

```verilog
module MUX2 
# (
    parameter                   WIDTH = 8
)(
    input [WIDTH-1: 0]          num1, num2,
    input                       sel,
    output reg [WIDTH-1: 0]     ans
); 
always @(*) begin
    if (sel)
        ans = num1;
    else
        ans = num2;
end
endmodule
```

例化：

```verilog
wire [3:0] num1, num2, ans;
wire sel;

MUX2 #(4) mux (
    .num1(num1),
    .num2(num2),
    .sel(sel),
    .ans(ans)
);
```

## Chapter Ⅱ Verilog 的描述层次

- 结构化描述方式：调用其他已经定义过的低层次模块对整个电路的功能进行描述，或者直接调用 Verilog 内部预先定义的基本门级元件描述电路的结构进行描述。
- 数据流描述方式：使用连续赋值语句 assign 对电路的逻辑功能进行描述。该方式特别适合于对组合逻辑电路建模。
- 行为级描述方式：使用过程块语句结构 always 和比较抽象的高级程序语句对电路的逻辑功能进行描述。

#### 从结构化层面描述电路

![image-20240812222444364](D:\desktop\暑假计划\image-20240812222444364.png)

例如。使用如下语句对电路进行结构级描述：

<img src="D:\desktop\暑假计划\image-20240812223208722.png" alt="image-20240812223208722" style="zoom:50%;" />

![image-20240812223225717](D:\desktop\暑假计划\image-20240812223225717.png)

#### 数据流描述方式

```verilog
module MUX2(
    input       a, b,
    input       sel,
    output      out
);

assign out = (a & ~sel) | (b & sel); 
endmodule
```

可以看到，得出逻辑表达式后使用`assign`语句进行赋值

#### 行为级描述方式

很多时候，我们难以得到模块的电路结构，或者得到的结构十分繁琐，这时我们就可以使用行为级描述，以**类似于高级语言**的抽象层次进行硬件结构开发。这一层面的描述过程更看重功能需求与算法实现，也是对于我们最为友好的描述方式。

```verilog
module MUX2(
    input       a, b,
    input       sel,
    output reg  out
);
always @(*) begin
    if (!sel)
        out = a;
    else
        out = b;
end
endmodule
```

#### 时钟信号和复位信号

```verilog
parameter T_high = 10;
parameter T_low = 5;   
reg clk;  
always begin
    clk = 1;
    # T_high;
    clk = 0;
    # T_low;
end
```

下面的代码是错误的！

```verilog
module Init4wire (
    input       a, b, c,
    output      out
);
wire temp = 0;
assign temp = a | b;
assign out = temp | c;
endmodule
```

第一句`temp=0`实际上等价于`assign temp = 0`故只有第一句起作用！**第二句是无用的！**

为确保实际环境下数字系统在上电后有一个明确、稳定的初始状态，且系统在运行紊乱时可以恢复到正常的初始状态，我们会在模块设计中添加复位模块。复位电路保证了系统工作的可控性，在一定程度上其重要性不亚于时钟信号。

从时序上来看，复位电路可分为**同步复位（Synchronous Reset）**和**异步复位（Asynchronous Reset）**两种。

![image-20240812224850716](D:\desktop\暑假计划\image-20240812224850716.png)

同步复位保证了信号是与时钟同步变化的，有利于保证时序的稳定性，因此被广泛使用。但大多数时序逻辑单元并没有同步复位端，使用同步复位描述得到的电路往往会消耗更多的逻辑资源。此外，复位信号的宽度必须大于一个时钟周期，否则便有可能发生遗漏。

![image-20240812225442773](D:\desktop\暑假计划\image-20240812225442773.png)

**异步复位会导致复位信号与时钟信号之间没有明确的时序关系，并且复位信号容易受到外部因素的干扰，产生意想不到的复位操作**。

#### 尽量使用同步复位的原因

```verilog
module Reset_test(
    input               clk, 
    input               rst, // 复位信号，高电平有效
    input               en,  // 写入控制信号 
    input [15:0]        din,
    output reg          [15:0] dout1,
    output reg          [15:0] dout2
);

always @(posedge clk or posedge rst) begin
    if (en) 
        dout1 <= din;
    else if (rst) 
        dout1 <= 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) 
        dout2 <= 0;
    else if (en)
        dout2 <= din;
end
endmodule
```

右边两个黄色的矩形是自动生成的寄存器（也就是时序逻辑单元），从名字可以看出上面的对应 dout1，下面的对应 dout2。注意观察左侧 rst 信号的连接情况，我们发现 dout1 并没有与 rst 信号相连！此外，dout2 寄存器也比 dout1 寄存器多了一个 CLR 端口。**这表明 dout1 并没有将 rst 视作异步复位信号**。

为什么会这样呢？实际上这是 if-else 语句的优先级导致的。在 dout1 对应的描述里，rst 信号比 en 信号判断的优先级低。也就是说，如果 en 信号为高电平，那么在 rst 的上升沿到来时，dout1 信号先会进入 `if (en)` 的判断，结果为真，从而执行 `dout1 <= din;` 而不是复位操作 `dout1 <= 0;`，这显然不符合异步复位的要求。所以在这里编译器将 rst 视作了同步复位信号。

#### 搭建Logisim教程

[Logisim 使用教程 - Digital Lab 2024 (ustc.edu.cn)](https://soc.ustc.edu.cn/Digital/history/2023/lab0/logisim/)

#### 使用VScode编辑

[Verilog 编程 - Digital Lab 2024 (ustc.edu.cn)](https://soc.ustc.edu.cn/Digital/history/2023/lab1/verilog_coding/)

#### 几点注意事项

+ 在进行模块例化时，无论端口数目多少，请一定使用基于端口名称的关联
+ 阻塞赋值 `=` 只用在 `assign` 和 `always @(*)` 的组合逻辑中，非阻塞赋值 `<=` 只用在 `always @(posedge clk)` 的时序逻辑中。请不要在错误的场景下使用，甚至二者混用。
+ 不要使用`for`循环

```verilog
// 括号中的代码需要缩进
cache_memory way0 (
    .addra (w_index), // Tab 缩进
    .clka (clk),
    .dina (mem_din),
    .ena (mem_en[0]),
    .wea (mem_we),
    .addrb (r_index),
    .doutb (mem_dout0)
); // 分号不要忘记

// begin...end 中的代码需要缩进
always @(*) begin
    case (wrt_data_sel) // Tab 缩进
        1'b0: mem_din = w_data_AXI;
        1'b1: begin
            case(wrt_type) // Tab 缩进
                BYTE: mem_din = {64{w_data_CPU[7:0]}}; // Tab 缩进
                HALF: mem_din = {32{w_data_CPU[15:0]}};
                WORD: mem_din = {16{w_data_CPU}};
                default: mem_din = 0;
            endcase // 与 17 行的 case 对齐
        end // 与 1'b1 对齐，因为这个 end 对应 16 行的 begin
    endcase // 与 14 行的 case 对齐
end // 与 always 对齐
```

## Chapter Ⅲ 测试与仿真

### 再遇Verilog

#### 关于阻塞赋值

在同一个 always 块里的阻塞赋值语句也可以是并行执行的，**只要其内部的信号不会产生冲突**。

作为一门硬件描述语言，我们一直在强调：**Verilog 中的每一条语句都对应着一种实际的硬件结构，例如 if 语句对应的是选择器。**

![image-20240813121154509](D:\desktop\暑假计划\image-20240813121154509.png)

如上，虽然是 `阻塞赋值`但是当`sel`信号发生变化时，信号`out1`和`out2`是同步变化的！

如果两个 if 的赋值对象没有冲突，那么两个 if 描述的多选器是并行的，否则是串行的。

#### 避免锁存器：逻辑缺陷，自引用与默认赋值

在 Verilog 中，一个变量如果声明为寄存器类型（reg），它既可以被综合成组合逻辑的导线，也可能被综合成时序逻辑中的寄存器或锁存器。在使用 `always @(*)` 语句时，我们会希望变量被综合成导线，但是有时候由于代码书写问题，它会被综合成我们不期望的锁存器结构，进而对电路带来危害。主要有：

- 电路的输出状态可能发生多次变化，增加了下一级电路的不确定性；
- 在大部分 FPGA 的设计里，锁存器结构会消耗更多的电路资源；
- 锁存器导致电路不能按照我们预期的方式工作，在调试时带来额外的问题。

因此，我们在代码书写时需要格外注意，应当避免出现锁存器。一个简单且好记的原则是：**组合逻辑中不应出现记忆电路，即电路不能保存自身的状态。违反了这一原则的组合逻辑电路往往就会产生锁存器**。

产生`latch`的原因有以下几种：

在**组合逻辑**中`if else`的缺陷：

![image-20240813122117393](D:\desktop\暑假计划\image-20240813122117393.png)

当 en 信号为 1 时，q 会被赋值为 data 的值；当 en 信号不变时，由于 always 语句里的 if 缺少对应的 else 分支，因此编译器默认 else 的分支下寄存器 q 的值保持**不变**。此时电路应当具有存储数据的功能，所以变量 q 会被综合成锁存器结构。

+ 特别注意！在时序逻辑中，不完整的 if-else 结构不会产生锁存器

另外，漏掉信号的某些情况也可能导致错误：

```verilog
// 补全 if-else 分支结构    
always @(*) begin
    if (en)  begin
        q1 = data1;
        q2 = 1'b0;
    end
    else begin
        q1 = 1'b0;
        q2 = data2;
    end
end

// 为 q1、q2 赋初值
always @(*) begin
    q1 = 1'b0;
    q2 = 1'b0;
    if (en)
        q1 = data1;
    else
        q2 = data2;
end
```

避免因为case产生的错误：

```verilog
// 使用 default 补充逻辑
always @(*) begin
    case(sel)
        2'b00:    q = data1;
        2'b01:    q = data2;
        default:  q = 1'b0;
    endcase
end

// 枚举补充逻辑
always @(*) begin
    case(sel)
        2'b00:  q = data1;
        2'b01:  q = data2;
        2'b10, 2'b11:  
                q = 1'b0;
    endcase
end

// 使用默认赋值
always @(*) begin
    q = 1'b0;
    case(sel)
        2'b00:  q = data1;
        2'b01:  q = data2;
    endcase
end
```

**在 always 语句块的一开始就进行默认赋值**。这样可以避免潜在的逻辑不完整风险。

**信号不要给信号自己赋值，且不要用赋值信号本身参与判断条件逻辑**。否则也会产生latch

### 编写测试文件

#### Testbench 

由**不可综合**的 Verilog 代码组成，这些代码用于生成待测模块的输入，并验证待测模块的输出是否正确（是否符合预期）

- 激励（Stimulus Block）是专门为待测模块生成的输入。我们需要尽可能产生全面的测试场景，包括合法的和不合法的。
- 输出校验（Output Checker）用于检查被测模块的输出是否符合预期。
- 被测模块（Design Under Test, DUT。也称 Unit Under Test, UUT）是我们编写的 Verilog 模块，Testbench 的主要目的就是对其进行验证，以确保在特定输入下其输出均与预期一致。

编写 Testbench 的第一步是创建一个 Verilog 模块作为测试的顶层模块。与正常设计时的 Verilog module 不同，用于测试的模块应当**没有输入和输出**，这是因为 Testbench 模块应当是完全独立的，不受外部信号的干扰。

接下来，我们需要例化待测模块，将信号连接到待测模块以允许激励代码运行。这些信号包括时钟信号和复位信号，以及传入 Testbench 的测试数据。

```verilog
module Module_tb ();

// 定义并产生激励信号
// ......

Test_module #(
    // 参数接口
) test (
    // 待测模块端口
);
endmodule
```

使用延时可能屏蔽掉信号的变化：

![image-20240813160802305](D:\desktop\暑假计划\image-20240813160802305.png)

![image-20240813160958548](D:\desktop\暑假计划\image-20240813160958548.png)

与 always 块不同，在 initial 块中编写的 Verilog 代码几乎都是不可综合的，因此基本上只被用于仿真与初始化信号。

#### 循环

除了 Lab1 中介绍的赋值语句和分支语句，Verilog 中也有循环语句。它们分别是 while、for、repeat 和 forever 循环。循环语句只能在 always 或 initial 块中使用，其内部可以包含延迟表达式。

```verilog
integer i;
reg [3:0] counter;
initial begin
    counter = 'b0;
    for (i = 0; i <= 10; i = i + 1) begin
        #10;
        counter = counter + 1'b1;
    end
end
```

在 Verilog 语言里，`i = i + 1` 不能像 C 语言那样写成 `i++` 的形式，`i = i - 1` 也不能写成 `i--` 的形式。

```verilog
reg [3:0] counter;
initial begin
    counter = 'b0;
    repeat (11) begin
        #10;
        counter = counter + 1'b1;
    end
end
```

#### 测试文件中的系统任务

![image-20240813161737314](D:\desktop\暑假计划\image-20240813161737314.png)

```verilog
reg [4:0] x;
initial begin
    x = 0;
    repeat (10) begin
        // 分别用 2 进制、16 进制和 10 进制来打印 x 的值
        $display("x(bin) = %b, x(hex) = %h, x(decimal) = %d\n", x, x, x);
        #10;
        x = x + 2;
    end
end
```

`$monitor` 函数与 `$display` 函数非常相似，但它一般被用来监视 Testbench 中的特定信号。这些信号中的任何一个改变状态，都会在终端打印一条消息。

```verilog
reg [4:0] a, b;
initial begin
    a = 0;
    b = 20;
    repeat (10) begin
        #10;
        a = a + 2;
        b = b - 2;
    end
end

initial begin
    $monitor("now a = %d, b = %d\n", a, b);
end
```

使用`$ time`获取系统仿真时间：

```verilog
reg [4:0] a, b;
initial begin
    a = 0;
    b = 20;
    repeat (10) begin
        #10;
        a = a + 2;
        b = b - 2;
    end
end

initial begin
    $monitor("Time %0t: a = %d, b = %d\n", $time, a, b);
end
```

#### 计时器测试文件实例

```verilog
module Counter_tb();
reg clk, rst;
wire out;

initial begin
    clk = 0;
    rst = 1;
    #50;
    rst = 0;
end
always #10 clk = ~clk;

Counter #(8) my_counter (
    .clk(clk),
    .rst(rst),
    .out(out)
);
endmodule
```

#### 最大值测试文件实例

```verilog
module MAX2_tb();
parameter TEST_NUM = 5;
reg clk;
reg [7:0] num1, num2, correct;
wire [7:0] out;

MAX2 max2 (
    .num1(num1),
    .num2(num2),
    .max(out)
);

initial begin
    clk = 0;
    forever begin
        #10;
        clk = ~clk;
    end
end

integer index, fid;
initial begin
    index = 0;
    fid = $fopen("test_data.txt", "r");
    $display("[Testbench]: ========== Ready to start the test. ==========");
    repeat(TEST_NUM) begin
        @(posedge clk);
        $fscanf(fid, "%d, %d, %d", num1, num2, correct);
        index = index + 1;
    end
    #50;
    $fclose(fid);
    $display("[Testbench]: ========== Done. ==========");
    $finish;
end

always @(posedge clk) begin
    #1;
    if (out != correct) begin
        $display("[Module MAX2]: Time %0t: Found ERROR at testcase No.%0d", $time, index);
    end
end
endmodule
```

测试过程：[使用 Vivado 进行仿真 - Digital Lab 2024 (ustc.edu.cn)](https://soc.ustc.edu.cn/Digital/history/2023/lab2/simulation/)

## Chapter Ⅳ 上板运行

### 消抖：

```verilog
module Jitter_Clear(
    input               clk,
    input               btn,
    output              btn_clean
);
reg [3:0] cnt;

always @(posedge clk) begin
    if (!btn)
        cnt <= 4'h0;
    else if (cnt < 4'h8)
        cnt <= cnt + 1'b1;
end

assign btn_clean = cnt[3];
endmodule
```

### 边沿检测：

同步检测与异步检测

>异步检测的原理是直接将输入信号作为敏感变量加入到 always 基本块的头部。**这种做法在大部分情况下都是极为不推荐的！**在 FPGA 综合时，我们需要避免非时钟信号、复位信号等出现在敏感变量列表中。

```matlab
module edge_capture(
    input             clk,
    input             rst,

    input             sig_in,  // Signal input
    output            pos_edge,
    output            neg_edge
);

reg sig_r1, sig_r2;
always @(posedge clk) begin
    if (rst) begin
        sig_r1 <= 0;
        sig_r2 <= 0;
    end
    else begin
        sig_r1 <= sig_in;
        sig_r2 <= sig_r1;
    end
end
assign pos_edge = (sig_r1 && ~sig_r2) ? 1 : 0;
assign neg_edge = (~sig_r1 && sig_r2) ? 1 : 0;
endmodule
```

以上是两级寄存器比较给出结果

使用三级寄存器来避免**亚稳态**

### 计数器分频

```verilog
module Clock_10M(
    input                   clk, rst,
    output reg              led
);
reg [3:0] cnt;
wire pulse_10m;

always @(posedge clk) begin
    if (rst)
        cnt <= 4'b0;
    else if (cnt >= 9)
        cnt <= 4'b0;
    else
        cnt <= cnt + 4'b1;
end

assign pulse_10m = (cnt == 4'h1);

always @(posedge clk) begin
    if (rst)
        led <= 1'b0;
    else if (pulse_10m)
        led <= ~led;
end
endmodule
```

### IP分频

利用IP核的例化格式代码！

[信号处理 - Digital Lab 2024 (ustc.edu.cn)](https://soc.ustc.edu.cn/Digital/history/2023/lab3/signals/)

再创建模板文件

```verilog
module Top (
    input               clk,
    input               rst
);
wire clk_10m, clk_200m, locked;

myclock clock(
    .clk_in1    (clk),
    .clk_out1   (clk_10m),
    .clk_out2   (clk_200m),
    .reset      (rst),
    .locked     (locked)
);
endmodule
```

```verilog
module Top_tb();
reg clk, rst;

initial begin
    clk = 0;
    forever
    #5 clk = ~clk;
end

initial begin
    rst = 1;
    #100 rst = 0;
end

Top top_test (
    .clk(clk),
    .rst(rst)
);
endmodule
```

### 有限状态机

[有限状态机 - Digital Lab 2024 (ustc.edu.cn)](https://soc.ustc.edu.cn/Digital/history/2023/lab5/FSM/)

Moore和Mealy有限状态机

```verilog
module FSM (
    input           clk,
    input           rst,
    // ......
    // 其他输入输出信号
);
// 状态空间位数 n
parameter WIDTH = 3;
// 状态变量
reg [WIDTH-1: 0] current_state, next_state;

// 为了便于标识，我们用局部参数定义状态的别名代替状态编码
localparam STATE_NAME_1 = 3'd0;
localparam STATE_NAME_2 = 3'd1;
// ......

// ==========================================================
// Part 1: 使用同步时序进行状态更新，即更新 current_state 的内容。
// ==========================================================
always @(posedge clk) begin
    // 首先检测复位信号
    if (rst)  
        current_state <= RESET_STATE;
    // 随后再进行内容更新
    else 
        current_state <= next_state;
end

// ==========================================================
// Part 2: 使用组合逻辑判断状态跳转逻辑，即根据 current_state 与
//         其他信号确定 next_state。
// ==========================================================
// 一般使用 case + if 语句描述跳转逻辑
always @(*) begin
    // 先对 next_state 进行默认赋值，防止出现遗漏
    next_state = current_state;
    case (current_state)
        STATE_NAME_1: begin
            // ......
        end
        STATE_NAME_2: begin
            // ......
        end
        default: begin
            // ......
        end
    endcase
end

// ==========================================================
// Part 3: 使用组合逻辑描述状态机的输出。这里是 mealy 型状态机
//         与 moore 型状态机区别的地方。
// ==========================================================
// 可以直接使用 assign 进行简单逻辑的赋值
assign out1 = ......;
// 也可以用 case + if 语句进行复杂逻辑的描述
always @(*) begin
    case (current_state)
        STATE_NAME_1: begin
            // ......
        end
        STATE_NAME_2: begin
            // ......
        end
        default: begin
            // ......
        end
    endcase
end
endmodule
```

有的时候状态机内的输出信号不止一种，为了保证低耦合性，避免可能发生的错误，我们建议每一个 always 块内仅进行一个变量的赋值。

使用后缀识别来确定序列的正确与否，否则就有多个状态！

比如序列识别`0100`则作出以下的状态转移图：

![image-20240820135236756](D:\desktop\暑假计划\image-20240820135236756.png)

再对以上的5个状态进行编码：

状态更新：

```verilog
always @(posedge clk) begin
    if (reset)
        current_state <= S0;
    else
        current_state <= next_state;
end
```

状态转移：

```verilog
always @(*) begin
    next_state = current_state;
    case (current_state)
        S0: begin   // -
            if (in)
                next_state = S0;    // -
            else
                next_state = S1;    // 0
        end

        S1: begin   // 0
            if (in)
                next_state = S2;    // 01
            else
                next_state = S1;    // 0
        end

        S2: begin   // 01
            if (in)
                next_state = S0;    // -
            else
                next_state = S3;    // 010
        end

        S3: begin   // 010
            if (in)
                next_state = S2;    // 01
            else
                next_state = S4;    // 0100
        end

        S4: begin   // 0100
            if (in)
                next_state = S2;    // 01
            else
                next_state = S1;    // 0
        end
    endcase
end
```

### 可复位时钟

```verilog
module TIMER (
    input                           clk,rst,
    output              [3:0]       seg_data,
    output              [2:0]       seg_an
);

    reg [3:0] outm ;
    reg [3:0] outss;
    reg [3:0] outsg;
    reg [3:0] outst;
    reg [39:0] count;

    initial begin
        outm    = 4'H0;
        outss   = 4'H0;
        outsg   = 4'H0;
        outst   = 4'H0;
        count   = 40'H0;
    end

    always@ (posedge clk) begin
        if (rst) begin
            count <= 40'H1;
        end
        else begin
            if (count != 40'D6000000000)
                count <= count + 40'H1;
            else
                count <= 40'H1;
        end
    end

    /*使用 Lab3 实验练习中编写的数码管显示模块*/
    Segment segment(
        .clk                (clk),
        .rst                (rst),
        .output_data        ({outm, outss, outsg, outst}),
        .output_valid       (8'HFF),     // 如果你没有实现，可以不需要这个端口
        .seg_data           (seg_data),
        .seg_an             (seg_an)
    );

    always@ (posedge clk) begin
        if(rst) begin
            outm    <=  4'H0;
            outss   <=  4'H0;
            outsg   <=  4'H0;
            outst   <=  4'H0;
        end
        else begin
            outm    <=  (count % 40'D6000000000 != 0)   ?   outm        :
                        (outm != 4'H5)                  ?   outm + 1    :
                                                            4'H0        ;  
            outss   <=  (count % 40'D1000000000 != 0)   ?   outss       :
                        (outss != 4'H5)                 ?   outss + 1   :
                                                            4'H0        ; 
            outsg   <=  (count % 40'D100000000 != 0)    ?   outsg       :
                        (outsg != 4'H9)                 ?   outsg + 1   :
                                                            4'H0        ; 
            outst   <=  (count % 40'D10000000 != 0)     ?   outst       :
                        (outst != 4'H9)                 ?   outst + 1   :
                                                            4'H0        ; 
        end
    end
endmodule
```

### 移位寄存器

```verilog
module Shift_Reg(
    input                       clk,
    input                       rst,
    input                       en,
    input           [3:0]       din,
    output          [3:0]       seg_data,
    output          [2:0]       seg_an,
    output          [7:0]       led_sig 
);

    reg [31:0] shift_reg;              //创建 32 位寄存器分成八个四位寄存器用来级联成移位寄存器
    reg [3:0] out_data;

    initial begin
        shift_reg = 32'H0;
        out_data = 4'H0;
    end

    /*使用 Lab3 实验练习中编写的数码管显示模块*/
    Segment segment(
        .clk                (clk),
        .rst                (rst),
        .output_data        (shift_reg),
        .output_valid       (8'HFF),
        .seg_data           (seg_data),
        .seg_an             (seg_an)
    );

    /*使用上面示例中展示的单个数码管显示模块*/
    Single_Segment single_segment(
        .num                (out_data),
        .led_sig            (led_sig)
    );

    wire pos_en;

    /*使用 Lab3 的边沿检测模块*/
    edge_capture en_pos_capture(
        .clk(clk),
        .rst(rst),

        .sig_in(en),
        .pos_edge(pos_en),
        .neg_edge()
    );

    always@ (posedge clk) begin
        if (en_pos) begin
            shift_reg <= {shift_reg[27:0], din};
            out_data <= shift_reg[31:28];
        end
    end

    endmodule
```

### 交通信号灯

>运用 FSM 来设计时序逻辑电路时，不管状态机多么简单，信号量多么少，都尽量采用三段式 Verilog 代码框架进行设计

首先定义状态变量及其名称：

```verilog
reg [1:0] current_state, next_state;
localparam RED = 2'd0;
localparam YELLOW = 2'd1;
localparam GREEN = 2'd2;
```

状态更新：

```verilog
always @(posedge clk) begin
    if (reset)
        current_state <= GREEN;
    else
        current_state <= next_state;
end
```

状态转移：

```verilog
always @(*) begin
    next_state = current_state;
    case (current_state)
        GREEN:
            next_state = YELLOW;
        RED:
            next_state = GREEN;
        YELLOW:
            next_state = RED;
    endcase
end
```

输出：

```verilog
assign green = current_state == GREEN;
assign yellow = current_state == YELLOW;
assign red = current_state == RED;
```

### 投币机

假设S0 表示售卖机里还没有钱币，S1 表示已经投了 5 分钱。

商品单价 10 分钱，硬币有 5 分和 10 分两种。假定一次只能投入一枚硬币

约定：AB/YZ

A=1 表示投入 5 分钱，B=1 表示投入 10 分钱，Y=1 表示弹出饮料，Z=1 表示找零。

![image-20240820142840293](D:\desktop\暑假计划\image-20240820142840293.png)

画出卡诺图并进行化简

![img](https://soc.ustc.edu.cn/Digital/history/2023/lab5/figs/example_coin_format.png)

### 超前进位加法器



余下内容略
