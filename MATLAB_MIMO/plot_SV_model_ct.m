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
