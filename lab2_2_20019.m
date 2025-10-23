clear all; close all;
load sima;
figure; pwelch(s,[],[],[],Fs);
f1=700; f2=1500;
H= [zeros(1,f1) ones(1,f2+f1) zeros(1,Fs-2*f2) ones(1,f2+f1) zeros(1,f1)];
h=ifft(H,'symmetric');
middle=length(h)/2;
h=[h(middle+1:end) h(1:middle)];
h64=h(middle+1-32:middle+33);
% figure; stem([0:length(h64)-1],h64); grid;
% figure; freqz(h64,1); % σχεδιάζουμε την απόκριση συχνότητας της h64
wvtool(h64); % αποκρίσεις συχνότητας των περικομμένων h
wh=hamming(length(h64));
wk=kaiser(length(h64),5);
figure; plot(0:64,wk,'r',0:64,wh,'b'); grid;
h_hamming=h64.*wh';
% figure; stem([0:length(h64)-1],h_hamming); grid;
% figure; freqz(h_hamming,1);
h_kaiser=h64.*wk';
wvtool(h64,h_hamming,h_kaiser);
y_rect=conv(s,h64);
figure; pwelch(y_rect,[],[],[],Fs);
y_hamm=conv(s,h_hamming);
figure; pwelch(y_hamm,[],[],[],Fs);
y_kais=conv(s,h_kaiser);
figure; pwelch(y_kais,[],[],[],Fs);
% Βαθυπερατό Parks-MacClellan
hpm=firpm(64, [0 0.10 0.15 0.5]*2, [1 1 0 0]);
% figure; freqz(hpm,1);
s_pm=conv(s,hpm);
figure; pwelch(s_pm,[],[],[],Fs);
sound(20*s); % ακούμε το αρχικό σήμα, s
sound(20*s_lp); % ακούμε το φιλτραρισμένο σήμα, s_lp