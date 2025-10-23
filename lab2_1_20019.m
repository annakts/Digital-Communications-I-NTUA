clear all; close all;
%load sima;
Fs=8192;
Ts=1/Fs;
T=1;
t=0:Ts:T-Ts;
A=1;
s=sin(2*pi*700*t)+sin(2*pi*900*t)+sin(2*pi*1400*t)+sin(2*pi*2500*t);
figure; pwelch(s,[],[],[],Fs);
% Ορίζεται η ιδανική βαθυπερατή συνάρτηση Η, με συχνότ. αποκοπ. Fs/8
H=[ones(1,Fs/8) zeros(1,Fs-Fs/4) ones(1,Fs/8)];
% Υπολογίζεται η κρουστική απόκριση με αντίστροφο μετασχ. Fourier
% Εναλλακτικά, μπορεί να χρησιμοποιηθεί η αναλυτική σχέση Sa(x)
h=ifft(H,'symmetric');
middle=length(h)/2;
h=ifftshift(h);
h32=h(middle+1-16:middle+17);
h64=h(middle+1-32:middle+33);
h128=h(middle+1-64:middle+65);
h160=h(middle+1-80:middle+81);
figure; stem([0:length(h160)-1],h160); grid;
figure; freqz(h160,1); % σχεδιάζουμε την απόκριση συχνότητας της h160
wvtool(h32,h64,h128,h160); % αποκρίσεις συχνότητας των περικομμένων h
% Οι πλευρικοί λοβοί είναι υψηλοί!
% Πολλαπλασιάζουμε την περικομμένη κρουστική απόκριση με κατάλληλο
% παράθυρο. Χρησιμοποιούμε την h160 και παράθυρα hamming και kaiser
wh=hamming(length(h160));
wk=kaiser(length(h160),5);
figure; plot(0:160,wk,'r',0:160,wh,'b'); grid;
h_hamming=h160.*wh';
 figure; stem([0:length(h160)-1],h_hamming); grid;
 figure; freqz(h_hamming,1);
h_kaiser=h160.*wk';
wvtool(h160,h_hamming,h_kaiser);
% Φιλτράρουμε το σήμα μας με καθένα από τα τρία φίλτρα
y_rect=conv(s,h160);
figure; pwelch(y_rect,[],[],[],Fs);
y_hamm=conv(s,h_hamming);
figure; pwelch(y_hamm,[],[],[],Fs);
y_kais=conv(s,h_kaiser);
figure; pwelch(y_kais,[],[],[],Fs);
% 
% Βαθυπερατό Parks-MacClellan
hpm=firpm(160, [0 0.11 0.12 0.5]*2, [1 1 0 0]);
 figure; freqz(hpm,1);
s_pm=conv(s,hpm);
figure; pwelch(s_pm,[],[],[],Fs);
sound(20*s); % ακούμε το αρχικό σήμα, s
sound(20*s_lp); % ακούμε το φιλτραρισμένο σήμα, s_lp