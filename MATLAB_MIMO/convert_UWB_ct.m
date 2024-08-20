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

