function H = Ric_model(K_dB,L)
%莱斯信道模型
%输入:
%K_dB:K因子[dB]
%L:信道实现数
%输出
%H:信道向量
K=10^(K_dB/10);
H=sqrt(K/(K+1)) + sqrt(1/(K+1))*Ray_model(L);
