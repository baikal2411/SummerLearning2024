function H = Ray_model(L)
% 输入：
%   L:信道的实现数
% 输出：
%   H:信道向量
H = (randn(1,L)+j*randn(1,L))/sqrt(2);