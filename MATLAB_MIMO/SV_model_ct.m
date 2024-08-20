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
t0(k)= Tc;
path_ix= 0;
while (Tc<10*Gam)%橙循环
%确定每一橙的射线到达
Tr=0;%定义第一条射线的到达时刻相对为0
while (Tr<10*gam) %射线循环
t_val =Tc+Tr;%该射线的到达时间
%射线功率,式(2.14)
bk12 = b002*exp(-Tc/Gam)*exp(-Tr/gam);
r = sqrt(randn^2+randn^2)*sqrt(bk12/2);
h_val = exp(j*2*pi*rand)*r; %均匀相位
path_ix = path_ix+1;%该射线的行编号
tmp_h(path_ix)=h_val;
tmp_t(path_ix)=t_val;
Tr=Tr +exprnd(1/Lam);%基于式(2.11)的到达时间
end
Tc= Tc + exprnd(1/lam);%基于式(2.10)的橙到达时间
end
np(k)=path_ix;%该次实现的射线(子径)数
[sort_tmp_t,sort_ix]= sort(tmp_t(1:np(k))); %升序排列
t(1:np(k),k) = sort_tmp_t;
h( 1:np(k),k)= tmp_h(sort_ix(1:np(k)));%对该次实现施加对数阴影衰落
fac=10^(sdi*randn/20)/sqrt(h(1:np(k),k)'*h(1:np(k),k));
h(1:np(k),k)= h(1:np(k),k)*fac; %式(2.15)
end

