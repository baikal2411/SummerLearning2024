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
