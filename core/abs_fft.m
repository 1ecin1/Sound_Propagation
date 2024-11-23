%逆傅里叶
temp_fx=ifft(fk);
temp_fx=temp_fx(1 : N+1);
temp_fx(1)=0.000000000000000 + 0.000000000000000i;
temp_fx(N+1)=0.000000000000000 + 0.000000000000000i;
%逆插值
starter_temp = interp1(dep{m,1},phi{1,1},zd,    'linear');
