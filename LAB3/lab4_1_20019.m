clear all;
close all;
clc;
L=8; 
step=2; % ο αριθμός των πλατών και το βήμα μεταξύ τους
k=floor(log(L));
K=4;
Nsymb=2500;
x=round(rand(1,K*Nsymb));
mapping=[step/2; -step/2];
if(k>1)
 for j=2:k
 mapping=[mapping+2^(j-1)*step/2;-mapping-2^(j-1)*step/2];
 end
end
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb');
y1=[];
for i=1:length(xsym)
 y1=[y1 mapping(xsym(i)+1)];
end
nsamp=32;
rolloff=0.4;
delay=4;
filtorder=delay*nsamp*2;
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
y2=upsample(y1,nsamp);
ytx=conv(y2,rNyquist);
yrx=conv(ytx,rNyquist);
yrx = yrx(2*delay*nsamp+1:end-2*delay*nsamp);
figure(1);
plot(yrx(1:10*nsamp));
hold;
stem([1:nsamp:nsamp*10],y1(1:10));
figure(3);
pwelch(yrx);