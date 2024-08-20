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
