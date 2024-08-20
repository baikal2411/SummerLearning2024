% plot_PL_Hata.m
clear, clf
fc= 1.5e9;
htx = 30;
hrx=2;
distance =[1:2:101].^2;
y_urban =PL_Hata(fc, distance, htx, hrx, 'urban');
y_suburban = PL_Hata(fc, distance, htx, hrx, 'suburban');
y_open=PL_Hata(fc, distance, htx, hrx, 'open');
semilogx(distance, y_urban, 'k-s', distance,y_suburban, 'k-o', distance,y_open, 'k-^')
title(['Hata PL model, f c=', num2str(fc/1e6), 'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('urban', 'suburban', 'open area', 'NorthWest')
grid on, axis([1 10000 40 200])
