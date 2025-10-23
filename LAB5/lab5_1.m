close all; 
clear all;
L=8; 
l=log2(L);
k=2*l;
core=[1+1i;1-1i;-1+1i;-1-1i]; 
mapping=core;
if(l>1)
 for j=1:l-1
 mapping=mapping+j*2*core(1);
 mapping=[mapping;conj(mapping)];
 mapping=[mapping;-conj(mapping)];
 end
end
scatterplot(mapping);
for i=1:length(mapping)
text(real(mapping(i)),imag(mapping(i)),num2str(de2bi(i-1,k,'left-msb')),'Color','red','FontSize', 6);
end






