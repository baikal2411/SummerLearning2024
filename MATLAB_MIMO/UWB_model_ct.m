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

