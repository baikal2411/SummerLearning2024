function PL=PL_IEEE80216d(fc,d,type,htx,hrx,corr_fact,mod)% IEEE 802.16d模型
%输入:
%fc:载波频率[Hz]
%d:基站和移动台之间的距离[m]
%type:可以选择'A','B\或'C
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