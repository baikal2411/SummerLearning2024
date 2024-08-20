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








