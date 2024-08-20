# MIMO_OFDM Matlab实现

[TOC]



## Chapter Ⅰ 无线信道：传播和衰落

在无线通信中，无线传播是指无线电波从发射机传播到接收机的行为。在传播过程中，无线电波主要受三种物理现象的影响:**反射、绕射和散射**。反射是指电磁波在传播的过程中遇到一个**尺寸远大于其波长**的物体（如地球和建筑物表面）而产生的物理现象。它使信号功率被反射回发射端，而不是完全沿着去往接收端的路径传播。绕射/衍射是指发射机和接收机之间的无线路径被**尖锐、不规则的物体表面或小的缺口（洞）**阻挡而发生的物理现象。看起来好像电波在这些小的障碍物周围发生了弯曲或穿过小孔后继续扩散。即使不存在可视路径，通过衍射产生的二次波也可以建立一条从发射端到接收端的路径。散射是由**一个或者多个尺寸远小于其波长的本地障碍物引起电磁波偏离原来传播方向的物理现象**。引起散射的这些障碍物，如植物、路标、灯柱等，被称为散射体。换句话说，无线电波的传播是一个复杂和不可预测的过程，由反射、绕射和散射决定，不同距离处的信号强度随环境的变化而变化。
无线信道的一个典型特征是“衰落”现象，即信号幅度在时间和频率上的波动。加性噪声是信号恶化的最普遍来源，而衰落是其另一种来源。与加性噪声不同的是，衰落在无线信道中引起**非加性的信号扰动**。衰落也可以由**多径传播**引起(称之为多径衰落)，或者由**障碍物的遮蔽**引起(称之为阴影衰落)。

阴影衰落是一种**慢衰落过程**，描述接收机和发射机之间的中等路径损耗的波动特性。换句话说，大尺度衰落的特性由平均路径损耗和阴影衰落来描述。另一方面，小尺度衰落是指当移动台在较短距离内移动时，由多条路径的相消或相长干涉引起信号电平的快速波动。根据多径时延的相对扩媵，用信坦的频率还挥仕〈如频率选择的或频率平坦的）来描述小尺度衰落的特性。此外，根据信道在时间上的波动（用多普勒扩展描述)，短期衰落可以分为快衰落和慢衰落。

![image-20240818150843914](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818150843914.png)

链路预算

![image-20240818151514140](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818151514140.png)

### 大尺度衰落

#### 一般路径损耗模型

![image-20240818155310596](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818155310596.png)

引入随环境改变的路径损耗指数$n$,得出

#### 对数距离路径损耗模型

![image-20240818155550093](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818155550093.png)

#### 对数正态阴影模型

![image-20240818160243223](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818160243223.png)

```matlab
%自由空间的路径损耗模型
function PL = PL_free(fc,dist,Gt,Gr)
%输入
%fc:载波频率[Hz]
%dist:基站和移动台之间的距离[m]
%Gt:发射机天线增益
%Gr:接收机天线增益
%输出：
%PL:路径损耗
lamda= 3e8/fc;%计算波长
tmp = lamda./(4*pi*dist);
if nargin>2,tmp = tmp*sqrt(Gt); end
if nargin>3,tmp = tmp*sqrt(Gr); end
%根据输入的参数的数量确定是否乘以增益
PL =-20*log10(tmp);%式(1.2)/(1.3)

```

```matlab
function PL=PL_logdist_or_norm(fc,d,d0,n,sigma)
%对数距离或对数阴影路径损耗模型
%输入
%fc:载波频率[Hz]
%d:基站和移动台之间的距离[m]
%d0:参考距离[m]
%n:路径损耗指数
%sigma:方差[dB]
%输出
%PL:路径损耗[dB]
lamda= 3e8/fc;
PL=-20*log10(lamda/(4*pi*d0)) + 10*n*log10(d/d0); %式(1.4)
if nargin> 4
PL=PL+ sigma*randn(size(d));%式(1.5)
end

```

```matlab
%plot_PL_general.m,绘制不同的路径损耗模型
clear all, clf, clc
fc= 1.5e9;d0 = 100;sigma= 3;
distance = [1:2:31].^2;
Gt=[1 1 0.5];
Gr=[1 0.5 0.5];
Exp=[2 3 6];
for k = 1:3
	y_Free(k,:)=PL_free(fc,distance,Gt(k),Gr(k));
	y_logdist(k,:)=PL_logdist_or_norm(fc,distance,d0,Exp(k));
	y_lognorm(k,:)=PL_logdist_or_norm(fc,distance,d0,Exp(1),sigma);
end
subplot(131)
semilogx(distance,y_Free(1,:),'k-o',distance,y_Free(2,:),'k-^',distance,y_Free(3,:),'k-s')
grid on, axis([1 1000 40 110])
title(['Free PL-loss Model,f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('G_t=1, G_r=1','G_t=1, G_r=0.5','G_t=0.5,G_r=0.5','NorthWest')

subplot(132)
semilogx(distance,y_logdist(1,:),'k-o',distance,y_logdist(2,:),'k-^' ,distance,y_logdist(3,:),'k-s')
grid on, axis([1 1000 40 110])
title(['Log-distance Path-loss Model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('n=2','n=3','n=6','NorthWest')

subplot(133)
semilogx(distance,y_lognorm(1,:),'k-o',distance,y_lognorm(2,:),'k-^',distance,y_lognorm(3,:),'k-s')
grid on, axis([1 1000 40 110])
title(['Log-normal Path-loss Model,f_c=',num2str(fc/1e6),'MHz, ', '\sigma=', num2str(sigma), 'dB'])
xlabel( 'Distance[m]'), ylabel('Path loss[dB]')
legend('path 1','path 2','path 2','NorthWest')
```

绘制结果如下图所示：

![image-20240818170136255](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818170136255.png)

#### Okumura模型

+ 预测城市地区损耗的模型，考虑了天线高度和地区覆盖类型

![image-20240818170629711](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818170629711.png)

![image-20240818170710507](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818170710507.png)

#### Hata模型

将上述模型扩展到各种传播环境：

![image-20240818170917058](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818170917058.png)

```matlab
function PL=PL_Hata(fc,d,htx,hrx,Etype)% Hata模型
%输入
%fc:载波频率[Hz]
%d:基站和移动台之间的距离[m]
%htx:发射机高度[m]
%hrx:接收机高度[m]
%Etype:环境类型('urban','suburban','open')
%输出
%PL:路径损耗[dB]
if nargin<5
    Etype ='URBAN';
end
fc = fc/(1e6);
if fc >= 150 && fc<=200
    C_Rx= 8.29*(log10(1.54*hrx))^2-1.1;
elseif fc>200
    C_Rx =3.2*(log10(11.75*hrx))^2-4.97; %式(1.9)
else
    C_Rx= 0.8+(1.1*log10(fc)-0.7)*hrx-1.56*log10(fc);%式(1.8)
end
PL=69.55 +26.16*log10(fc)-13.82*log10(htx) -C_Rx ...
+(44.9-6.55*log10(htx))*log10(d/1000); %式(1.7)
EType = upper(Etype);
if EType(1) == 'S'
    PL=PL -2*(log10(fc/28))^2 -5.4;%式(1.10)
elseif EType(1)=='O'
    PL=PL+(18.33-4.78*log10(fc))*log10(fc)-40.97;%式(1.11
end

```

```matlab
% plot_PL_Hata.m
clear, clf
fc= 1.5e9;
htx = 30;
hrx=2;
distance =[1:2:31].^2;
y_urban =PL_Hata(fc, distance, htx, hrx, 'urban');
y_suburban = PL_Hata(fc, distance, htx, hrx, 'suburban');
y_open=PL_Hata(fc, distance, htx, hrx, 'open');
semilogx(distance, y_urban, 'k-s', distance,y_suburban, 'k-o', distance,y_open, 'k-^')
title(['Hata PL model, f c=', num2str(fc/1e6), 'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('urban', 'suburban', 'open area', 'NorthWest')
grid on, axis([1 1000 40 110])

```

#### IEEE 802.16d模型

![image-20240818173815860](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818173815860.png)

![image-20240818192147668](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818192147668.png)

![image-20240818192333520](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818192333520.png)

根据上式子求解出新的参考距离$d_{0}^{'}$
$$
d_{0}^{'}=d_{0} {10}^{-\frac{C_{r}+C_{Rx}}{10 \gamma}}
$$
![image-20240818192930084](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818192930084.png)

函数表达式代码：

```matlab
function PL=PL_IEEE80216d(fc,d,type,htx,hrx,corr_fact,mod)% IEEE 802.16d模型
%输入:
%fc:载波频率[Hz]
%d:基站和移动台之间的距离[m]
%type:可以选择'A','B’或'C
%htx:发射机高度[m]
%hrx:接收机高度[m]
%corr_fact:如果存在阴影，那么设置为'ATnT或 'Okumura'。否则,设置为NO'
%mod:设置为'mod'来得到修正的IEEE 802.16d模型
%输出:
%PL:路径损耗[dB]
Mod = 'UNMOD';
if nargin >6
    Mod = upper(mod);
end
if nargin==6 && corr_fact(1)=='m'
    Mod = 'MOD';
    corr_fact= 'NO';
elseif nargin<6
    corr_fact = 'No';
    if nargin ==5 && hrx(1) == 'm'
        Mod = 'MOD';
        hrx = 2;
    elseif nargin<5
        hrx = 2;
        if nargin == 4 && htx(1)=='m'
            Mod = 'MOD';
            htx = 30;
        elseif nargin<4
            htx =30;
            if  nargin == 3 && type(1)=='m'
                Mod = 'MOD';
                type = 'A';
            elseif nargin<3
                type = 'A';
            end
        end
    end
end
d0 = 100;
Type = upper(type);
if Type~='A'&& Type~='B' && Type ~='C'
    disp('Error: The selected type is not supported');
    return;
end
switch upper(corr_fact)
case 'ATNT'
    PLf= 6*log10(fc/2e9);%式（1.13)
    PLh=-10.8*log10(hrx/2);%式（1.14)
case 'OKUMURA'
    PLf= 6*log10(fc/2e9);%式（1.13)
    if hrx <= 3
    CRx = -10*log10(hrx/3);%式（1.15)
    else
    CRx =-20*log10(hrx/3);
    end
case 'NO'
    PLf = 0;
    PLh=0;
end
if Type=='A'
    a= 4.6; %式(1.13)
    b= 0.0075;
    c= 12.6;
elseif Type=='B'
    a=4;
    b= 0.0065;
    c= 17.1;
else
    a= 3.6;
    b= 0.005;
    c=20;
end
lamda= 3e8/fc;
gamma= a-b*htx+c/htx;%式（1.12)
d0_pr = d0;
if Mod(1)== 'M'
    d0_pr = d0*10^-((PLf+PLh)/(10*gamma));%式(1.17)
end
A=20*log10(4*pi*d0_pr/lamda)+ PLf+PLh;
for k=1 : length(d)
    if d(k) > d0_pr
        PL(k)=A+10*gamma*log10(d(k)/d0);%式（1.18)
    else
        PL(k)=-10*log10((lamda/(4*pi*d(k)))^2);
    end
end
```

作图脚本：

```matlab
% plot_PL_IEEE80216d.m
clear, clf, clc
fc= 2e9;htx=[30 30];hrx=[2 10];
distance =[1:1000];
for k=1:2
    y_IEEE16d(k,:)=PL_IEEE80216d(fc,distance,'A',htx(k),hrx(k),'atnt');
    y_MIEEE16d(k,:)=PL_IEEE80216d(fc,distance,'A',htx(k),hrx(k),'atnt','mod');
end
subplot(121)
semilogx(distance,y_IEEE16d(1,:),'k:','linewidth',1.5), hold on
semilogx(distance,y_IEEE16d(2,:),'k-','linewidth',1.5), grid on
title(['IEEE 802.16d Path loss Models,f_c=',num2str(fc/1e6),'MHz'])
axis([1 1000 10 150])
xlabel('Distance[m]'), ylabel('Pathloss[dB]')
legend('h_{Tx} = 30m, h_{Rx}=2m','h_{Tx} =30m, h_{Rx} = 10m')
subplot( 122)
semilogx(distance,y_MIEEE16d(1,:),'k:','linewidth',1.5), hold on
semilogx(distance,y_MIEEE16d(2,:),'k-','linewidth',1.5), grid on
title(['Modified IEEE 802.16d Path loss Models,f_c=', num2str(fc/1e6),'MHz'])
axis([1 1000 10 150])
xlabel('Distance[m]'), ylabel('Pathloss[dB]')
legend('h_{Tx}=30m, h_{Rx}=2m','h_{Tx} =30m, h_{Rx}-10m')

```

![image-20240818203648353](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818203648353.png)

### 小尺度衰落

决定因素：多径传播，移动台速度，周围物体的速度，信号传输带宽

#### 参数

功率时延分布PDP

![image-20240818205102639](D:\desktop\暑假计划\MATLAB_MIMO\image-20240818205102639.png)

平均过量时延$\tau_{k}$
$$
\overline{\tau}=\frac{\sum_{k}a_{k}^{2}\tau_{k}}{\sum_{k}a_{k}^{2}}
$$
由PDP的二阶中心矩的平方根给出RMS时延扩展$\sigma_{\tau}$
$$
\sigma_{\tau}=\sqrt{\overline{\tau^{2}}-\overline{\tau}^{2}}
$$
相干带宽与RMS时延扩展的关系：

![image-20240819102835140](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819102835140.png)

#### 时间色散衰落与频率色散衰落

当移动台移动时，接收信号衰落的具体类型由传输方案和信道特点决定。传输方案由信号的参数确定，如信号带宽和符号周期。无线信道的特点由两种不同的信道参数描述，它们是多径时延扩展和多普勒扩展。多径时延扩展和多普勒扩展分别引起时间色散效应和频率色散效应。根据时间色散的程度或频率色散的程度，它们将分别引起频率选择性衰落或时间选择性衰落。

时间色散效应----频率选择性衰落信道

![image-20240819103800100](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819103800100.png)

![image-20240819103932295](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819103932295.png)

频率色散效应----时间选择性衰落信道

![image-20240819104025650](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819104025650.png)

![image-20240819104054190](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819104054190.png)

#### 衰落信道的统计特性和产生

Clarke模型

![image-20240819104606749](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819104606749.png)

![image-20240819104717570](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819104717570.png)

经典多普勒谱

接收信号服从瑞利分布/服从莱斯分布

![image-20240819105233382](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819105233382.png)

#### 衰落信道的生成：书P18

LOS的pdf----莱斯分布，NLOS----瑞利分布

![image-20240819110213806](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819110213806.png)

不存在LOS分量时，上式简化为：

![image-20240819114057695](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819114057695.png)

K增大时趋于高斯的pdf，对于瑞利衰落信道：K约取-40dB，对于高斯信道而言，取K>15dB

#### 瑞利模型

```matlab
function H = Ray_model(L)
% 输入：
%   L:信道的实现数
% 输出：
%   H:信道向量
H = (randn(1,L)+j*randn(1,L))/sqrt(2);
```

#### 莱斯信道模型

```matlab
function H = Ric_model(K_dB,L)
%莱斯信道模型
%输入:
%K_dB:K因子[dB]
%L:信道实现数
%输出
%H:信道向量
K=10^(K_dB/10);
H=sqrt(K/(K+1)) + sqrt(1/(K+1))*Ray_model(L);

```

```matlab
% plot_Ray Ric_channel.m
clear, clf
N= 200000;level= 30;
K_dB=[-40 15];
Rayleigh_ch = zeros(1,N);
Rician_ch= zeros(2,N);
gss =['k-s'; 'b-o'; 'r-^'];
%瑞利模型
Rayleigh_ch =Ray_model(N);
[temp,x] = hist(abs(Rayleigh_ch(1,:)),level);
plot(x, temp, gss(1,:)), hold on
%莱斯模型
for i= 1 : length(K_dB)
Rician_ch(i,:)= Ric_model(K_dB(1),N);
[temp x] = hist(abs(Rician_ch(i,:)), level);
plot(x, temp, gss(i+1,:))
end
xlabel('x'),ylabel('Occurance')
legend('Rayleigh','Rician,K=-40dB','Riacian,K=15dB')
```

## Chapter Ⅱ SISO模型

### 室内信道模型

#### 一般室内信道模型----2-径模型

两条射线：

零时延的直射路径，时延$\tau_{1}>0$的反射路径

![image-20240819185033858](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819185033858.png)

```matlab
% plot_2ray_exp_model.m
clear, clf
scale= 1e-9;
%纳秒
Ts= 10*scale;
%采样时间
t_rms =30*scale;
%RMS时延扩展
num_ch= 10000;%信道数
%2-径模型
pow_2=[0.5 0.5];
delay_2 = [0 t_rms*2]/scale;
H_2= Ray_model(num_ch).'*sqrt(pow_2);
avg_pow_h_2 = mean(H_2.*conj(H_2));
subplot(221)
stem(delay_2,pow_2), hold on
stem(delay_2,avg_pow_h_2,'r.')
xlabel('Delay[ns]'), ylabel('Channel Power[linear]')
title('Ideal PDP and simulated PDP of 2-ray model')
legend('Ideal','Simulation')
axis([0 140 0 0.7])
%指数模型
pow_e=exp_PDP(t_rms,Ts);
delay_e= (0:length(pow_e)-1)*Ts/scale;
for i= 1 : length(pow_e)
    H_e(:, i)=Ray_model(num_ch).'*sqrt(pow_e(i));
end
avg_pow_h_e = mean(H_e.*conj(H_e));
subplot(222)
stem(delay_e,pow_e), hold on
stem(delay_e, avg_pow_h_e, 'r.')
xlabel('Delay[ns]'), ylabel('Channel Power[linear]')
title('Ideal PDP and simulated PDP of exponential model')
legend('Ideal' , 'Simulation')
axis([0 140 0 0.7])

```

#### 一般室内信道模型----指数模型

```matlab
function PDP = exp_PDP(tau_d,Ts,A_dB,norm_flag)%指数PDP生成器
%输入:
%tau_d: RMS时延扩展[s]
%Ts:采样时间[s]
%A_dB:最小的不可忽略的功率[dB]
%norm_flag:归一化总功率为1
%输出:
%PDP:PDP向量
if nargin <4, norm_flag = 1;end %归一化
if nargin<3,A_dB=-20; end % 20dB 以下
sigma_tau = tau_d;
A=10^(A_dB/10);
lmax = ceil(-tau_d*log(A)/Ts); %式(2.2)
%计算功率归一化的归一化因子
if norm_flag
p0= (1-exp(-Ts/sigma_tau))/(1-exp(-(lmax+1)*Ts/sigma_tau));%式(2.4)
else
p0 =1/sigma_tau;
end
%指数 PDP
l=0:lmax;
PDP = p0*exp(-l*Ts/sigma_tau);%式(2.5)
```

#### IEEE 802.11 信道模型

采取有限脉冲响应滤波器的输出表示信道脉冲响应

![image-20240819191652481](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819191652481.png)

```matlab
% plot_IEEE80211_model.m
clear, clf
scale= 1e-9;
%纳秒
Ts = 50*scale;
%采样时间
t_rms = 25*scale;
% RMS时延扩展
num_ch = 10000;
%信道数
N=128;
% FFT尺寸

PDP = IEEE_802_11_model(t_rms,Ts);
for k= 1: length(PDP)
h(:,k)=Ray_model(num_ch).'*sqrt(PDP(k));
avg_pow_h(k) = mean(h(:,k).*conj(h(:,k)));
end
H= fft(h(1,:),N);
subplot(221)
stem([0:length(PDP)-1],PDP,'ko'), hold on
stem([0:length(PDP)-1],avg_pow_h,'k.')
xlabel('channel tap index, p')
ylabel('Average Channel Power[linear]')
title('IEEE 802.11 Model, \sigma_\tau=25ns,T_S-50ns')
legend('Ideal','Simulation'); 
axis([-1 7 0 1])
subplot(222)
plot([-N/2+1:N/2]/N/Ts/10^6,10*log10(H.*conj(H)),'k-')
xlabel('Frequency[MHz]'), ylabel('Channel power[dB]')
title('Frequency response,\sigma_\tau=25ns,T_S=50ns')

```

```matlab
function PDP= IEEE_802_11_model(sigma_tau,Ts)%IEEE 802.11信道模型PDP生成器
%输入:
%   sigma_tau : RMS 时延扩展
%   Ts:采样时间
%输出:
%   PDP:功率时延分布
lmax = ceil(10*sigma_tau/Ts);%式(2.6)
sigma02 =(1-exp(-Ts/sigma_tau))/(1-exp(-(lmax+1)*Ts/sigma_tau)); %式(2.9)
l=0:lmax;
PDP = sigma02*exp(-l*Ts/sigma_tau);%式(2.8)
```

#### Saleh-Valenzuela信道模型

![image-20240819193740068](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819193740068.png)

```matlab
% plot SVmodel_ct.m
clear, clf, close all
Lam = 0.0233;
lambda=2.5;
Gam=7.4;
gamma= 4.3;
N= 1000; %信道数
power_nom=1;%第一橙第一射线的功率
std_shdw = 3; %对数阴影衰落的标准差
t1=0:300;
t2=0:0.01:5;
p_cluster =Lam*exp(-Lam*t1);%理想的指数PDF
h_cluster = exprnd(1/Lam,1,N);%产生随机数
[n_cluster x_cluster] = hist(h_cluster,25);%得到分布
subplot(221)
plot(t1,p_cluster,'k'), hold on
plot(x_cluster,n_cluster*p_cluster(1)/n_cluster(1),'k:');%画图
legend('Ideal','Simulation')
title(['Distribution of Cluster Arrival Time,\Lambda=',num2str(Lam)])
xlabel('T_m-T_{m-1}[ns]'), ylabel('p(T_m|T_{m-1})')
p_ray = lambda*exp(-lambda*t2);
%理想的指数PDF
h_ray = exprnd(1/lambda,1,1000);
%生成随机数
[n_ray,x_ray] = hist(h_ray,25);
%得到分布
subplot(222)
plot(t2,p_ray,'k'), hold on
plot(x_ray,n_ray*p_ray(1)/n_ray(1),'k:') %画图
legend('Ideal','Simulation')
title(['Distribution of Ray Arrival Time, \lambda=', num2str(lambda)])
xlabel('\tau_{r,m}-\tau_{(r-1),m} [ns]')
ylabel('p(\tau_{r,m}|\tau_{(r-1),m})')
[h,t,t0,np]=SV_model_ct(Lam,lambda,Gam,gamma,N,power_nom,std_shdw);
subplot(223)
stem(t(1:np(1),1),abs(h(1:np(1),1)),'ko')
title('Generated Channel Impulse Response')
xlabel('delay[ns]'), ylabel('Magnitude')
X= 10.^(std_shdw*randn(1,N)./20);
[temp,x]= hist(20*log10(X),25);
subplot(224)
plot(x,temp,'k-')
axis([-10 10 0 120])
title(['Log-normal Distribution, \sigma_X=',num2str(std_shdw),'dB'])
xlabel('20*log10(X)[dB]'), ylabel('Occasion')
```

```matlab
function [h,t,t0,np] = SV_model_ct(Lam,lam,Gam,gam,num_ch,b002,sdi,nlos)
% S-V信道模型
%输入
% Lam:簇到达率[GHz](每纳秒的平均橙数量)
%lam:射线到达率[GHz](每纳秒的平均射线数量)
% Gam:簇衰减因子(时间常量，纳秒)
% gam:射线衰减因子(时间常量，纳秒)
% num_ch :产生随机信道实现的数量
% b002:第一橙中第一射线的功率
%sdi:整个脉冲响应的阴影衰落的标准差[dB]
%nlos:用于描述产生NLOS信道的标志
%输出
% h: num_ch列的矩阵,每一列表示信道模型（脉冲响应)的一个随机实现
%t:信道(路径)所在时刻(纳秒)，路径的幅度存于h中
%t0:对于每一次实现，第一橙的到达时间
%np:对于每一次实现的路径数
%由(t(1:np(k),k), h(1:np(k),k))给出第k个信道脉冲响应的实现
if nargin<8 % LOS环境
    nlos = 0;
end
if nargin<7 % 0dB
    sdi =0;
end
if nargin<6%第一橙的第一条射线的功率
    b002=1;
end
h_len= 1000;
for k= 1:num_ch %按照信道数循环
tmp_h= zeros(h_len,1);
tmp_t = zeros(h_len,1);
if nlos
Tc = exprnd(1/Lam);
else
Tc=0;%第一簇在时刻0到达
end
```

#### UWB信道模型

![image-20240819201528161](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819201528161.png)

![image-20240819201548607](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819201548607.png)

```matlab
function [Lam,lam,Gam,gam,nlos,sdi,sdc,sdr] = UWB_parameters(cm)
%用于标准UWB信道模型的S-V模型的参数
%输入:
%cm=1:基于 TDC对 LOS 0-4m的测量
%cm-2:基于 TDC对 NLOS 0-4m的测量
%cm=3:基于TDC对NLOS 4-10m的测量
%cm-4 :25ns RMS时延扩展的多径信道
%输出:
% Lam:族到达率(每纳秒的簇数量)
% lam:射线到达率(每纳秒的射线数量)
% Gam:簇衰减因子（时间常数,纳秒)
%gam:射线衰减因子(时间常数,纳秒)
%nlos :NLOS信道的标志
%sdi:整个脉冲响应的对数正态阴影的标准差
% sdc:橙衰落的对数正态随机变量的标准差
%sdr:射线衰落的对数正态随机变量的标准差
%表2.1:
tmp = 4.8/sqrt(2);
Tb2_1= [0.0233 2.5 7.1 4.3 0 3 tmp tmp;
        0.4 0.5 5.5 6.7 1 3 tmp tmp;
        0.0667 2.1 14 7.9 1 3 tmp tmp;
        0.0667 2.1 24 12 1 3 tmp tmp];
Lam=Tb2_1(cm,1); lam = Tb2_1(cm,2);
Gam = Tb2_1(cm,3); gam= Tb2_1(cm,4);
nlos= Tb2_1(cm,5); sdi= Tb2_1(cm,6);
sdc= Tb2_1(cm,7); sdr= Tb2_1(cm,8);

```

```matlab
function [hN,N]= convert_UWB_ct(h_ct, t, np, num_channels, ts)
%将连续时间的信道模型h_ct转换为N倍过采样的离散时间的采样值
% h_ct, t, np, num_channels与 uwb_model中的含义一样
% ts是期望的时间分辨率
% hN是以ts/N时间分辨率产生的
min_Nfs = 100;% GHz
N= max(1, ceil(min_Nfs*ts));%N*s = N/ts是整数倍抽取前的中频采样频率N= 2^nextpow2(N);%取N为2的指数，便于实现有效的多级抽取
Nfs = N/ts;
t_max= max(t(:));%所有信道中的最大时间值
h_len = 1 +floor(t_max * Nfs);%在ts/N的时间采样数
hN = zeros(h_len,num_channels);
for k= 1 : num_channels
np_k= np(k);%在这一次信道中的路径数
t_Nfs =1+ floor(t( 1:np_k,k)* Nfs); %对这一次信道量化的时间向量
for n = 1:np_k
hN(t_Nfs(n),k) = hN(t_Nfs(n),k)+h_ct(n,k);
end
end
```

```matlab
function [h,t,t0,np]= UWB_model_ct(Lam,lam,Gam,gam,num_ch,nlos,sdi,sdc,sdr)
% IEEE 802.15.3a UWB信道模型,用于PHY 提案的评估
%改进的S-V信道模型的连续时间的实现
%输入:
% Lam:簇到达率[GHz](每纳秒的平均族数量)
% lam:射线到达率[GHz](每纳秒的平均射线数量)
% Gam:族衰减因子(时间常数,纳秒)
% gam:射线衰减因子(时间常数,纳秒)
% num_ch: 生成的随机实现的数量
% nlos :用于描述生成NLOS信道的标志
% sdi:整个脉冲响应的对数正态阴影的标准差
% sdc:对于橙衰落的对数正态随机变量的标准差
%sdr:对于射线衰落的对数正态随机变量的标准差
%输出:
%h: num_ch列的矩阵,每一列包含信道模型(脉冲响应)的一个随机实现
%t:信道(路径）所在时刻(纳秒)，路径的幅度存于h中
%t0:对于每一次实现，第一族的到达时间
%np:对于每一次实现的路径数
%由(t(1:np(k),k),h(1:np(k),k))给出kth信道脉冲响应的实现
%初始化
std_L= 1/sqrt(2*Lam); %簇到达间隔的标准差（纳秒)
std_lam = 1/sqrt(2*lam);%射线到达间隔的标准差(纳秒）
mu_const =(sdc^2+sdr^2)*log(10)/20;%预先计算，便后使用
h_len =1000;
for k=1:num_ch%按照信道数循环
tmp_h= zeros(h_len,1);
tmp_t= zeros(h_len,1);
if nlos
Tc=(std_L*randn)^2+(std_L*randn)^2;%第一簇随机到达
else
Tc=0;%第一簇在时刻0到达
end
t0(k)=Tc;
path_ix=0;
while (Tc<10*Gam)
    Tr=0;
    ln_xi = sdc*randn;
    while(Tr<10*gam)
        t_val = Tc+Tr;%该射线的到达时间
        mu =(-10*Tc/Gam-10*Tr/gam)/log(10) - mu_const;%式(2.19)
        ln_beta= mu +sdr*randn;
        pk = 2*round(rand)-1;
        h_val = pk*10^((ln_xi+ln_beta)/20);
        path_ix = path_ix+1;%该射线的行编号
        tmp_h(path_ix)= h_val;
        tmp_t(path_ix)=t_val;
        Tr=Tr+(std_lam*randn)^2 +(std_lam*randn)^2;
    end
Tc= Tc+ (std_L*randn)^2 +(std_L*randn)^2;
end
np(k)=path_ix;%该次实现的射线(路径)数
[sort_tmp_t,sort_ix]= sort(tmp_t(1:np(k)));%按照时间的升序排列
t(1:np(k),k) = sort_tmp_t;
h(1:np(k),k)= tmp_h(sort_ix(1:np(k)));%对该次实现施加对数正态阴影
fac= 10^(sdi*randn/20)/sqrt(h( 1:np(k),k)'*h(1:np(k),k));
h(1:np(k),k) = h(1:np(k),k)*fac;
end
```

```matlab
% plot_UWB channel.m
clear, clf
Ts= 0.167; %采样周期（纳秒)
num_ch =100;%生成的信道脉冲响应数
randn('state', 12);
%为了再现，设置函数的初始态
rand('state',12);
%为了再现，设置函数的初始态
cm=1; %信道模型编号:1-4
%根据信道模型编号,得到信道模型的参数
[Lam, lam, Gam, gam, nlos, sdi, sdc, sdr]= UWB_parameters(cm);%得到一组（脉冲响应)实现
[h_ct, t_ct, t0, np] = UWB_model_ct(Lam, lam, Gam, gam, num_ch, nlos, sdi, sdc, sdr);
%将连续时间结果转化为离散时间结果
[hN, N]=convert_UWB_ct(h_ct,t_ct, np, num_ch,Ts);
h= resample(hN, 1,N);%对hN的列进行N倍抽取h= hN; %对抽取过程施加的1/N加以校正
channel_energy = sum(abs(h).^2);%信道能量
h_len = size(h,1);
t =[0:(h_len-1)]*Ts; %计算过量时延和 RMS 时延时使用
for k=1:num_ch
    %确定过量时延和RMS时延
    sq_h= abs(h(:,k)).^2/channel_energy(k);
    t_norm=t - t0(k);%去除第一橙的随机到达时间
    excess_delay(k)= t_norm*sq_h;
    rms_delay(k)= sqrt((t_norm-excess_delay(k)).^2*sq_h);
    %确定显著路径的数量(峰值功率为10 dB以内的路径
    temp_h= abs(h(:,k));
    threshold_dB=-10; % dB
    temp_thresh=10^(threshold_dB/20)*max(temp_h);
    num_sig_paths(k)= sum(temp_h>temp_thresh);
%确定显著路径的数量(占信道总能量的×%）
    temp_sort = sort(temp_h.^2);%按照能量的升序排列
    cum_energy = cumsum(temp_sort(end:-1:1));%累积的能量
    x = 0.85;
    index_e = min(find(cum_energy >= x*cum_energy(end)));
    num_sig_e_paths(k) = index_e;
end
energy_mean=mean(10*log10(channel_energy));
energy_stddev= std( 10*log10(channel_energy));
mean_excess_delay = mean(excess_delay);
mean_rms_delay = mean(rms_delay);
mean_sig_paths = mean(num_sig_paths);
mean_sig_e_paths = mean(num_sig_e_paths);

temp_average_power = sum(h'.*h')/num_ch;
temp_average_power = temp_average_power/max(temp_average_power);
average_decay_profile_dB= 10*log10(temp_average_power);
fprintf(1,['Model Parameters\n \Lam=%.4f, lam=%.4f, Gam = %.4f, gam=%.4f\n NLOS flag=%d,std_shdw=%.4f, td_ln_1=%.4f, td_ln_2%.4f\n'],...
 Lam, lam, Gam, gam, nlos, sdi, sdc, sdr);
fprintf(1 ,' Model Characteristics\n');
fprintf(1, 'Mean delays: excess (tau_m)= %.1f ns, RMS (tau_rms)= %1.fn', ...
mean_excess_delay, mean_rms_delay);
fprintf(1,' # paths: NP_10dB=%.1f, NP_85%%=%.1fn',...
mean_sig_paths, mean_sig_e_paths);
fprintf(1,'Channel energy: mean = %.1f dB, std deviation = %.1f dBin', ...
energy_mean, energy_stddev);

subplot(321)
plot(t,h), grid on
title('Impulse response realizations')
xlabel('Time [ns]')
subplot(322)
plot([ 1:num_ch], excess_delay,'b-',[1 num_ch], mean_excess_delay*[1 1], 'r-');
title('Excess delay [ns]'), grid on
xlabel('Channel number')
subplot(323)
plot([ 1:num_ch], rms_delay, 'b-',[1 num_ch], mean_rms_delay*[1 1], 'r-');
title('RMS delay [ns]'),grid on
xlabel('Channel number')
subplot(324)
plot([ 1:num_ch], num_sig_paths, 'b-', [1 num_ch], mean_sig_paths*[1 1], 'r-');
title('Number of significant paths within 10 dB of peak')
xlabel('Channel number'), grid on
subplot(325)
plot(t,average_decay_profile_dB)
grid on
title('Average Power Decay Profile')
axis([0 t(end) -60 0])
xlabel('Delay (nsec)'), 
ylabel('Average power (dB)')
subplot(326)
figh = plot([1:num_ch],10*log10(channel_energy),'b-',...
[1 num_ch], energy_mean*[1 1], 'g-',...
[1 num_ch], energy_mean+energy_stddev*[1 1], 'r:',...
[1 num_ch], energy_mean-energy_stddev*[1 1], 'r:');
xlabel('Channel number'), ylabel( 'dB')
title('Channel Energy')
legend(figh, 'Per-channel energy', 'Mean', '\pm Std. deviation')
```

![image-20240819214903394](D:\desktop\暑假计划\MATLAB_MIMO\image-20240819214903394.png)

### 室外信道模型

室外信道受终端移动速度的影响，特点是信道增益是时变的。

#### FWGN信道模型

#### 改进的频域FWGN模型

#### 时域FWGN模型

#### 改进的时域FWGN模型

#### Jakes模型

#### 基于射线的信道模型

#### 频率选择性衰落信道模型

#### SUI信道模型

## Chapter Ⅲ MIMO信道模型

