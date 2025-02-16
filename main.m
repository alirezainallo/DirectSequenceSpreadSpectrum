clear all;close all;clc;

%% parameters
Fs = 48000;
fc = 1000;
fp = 32;
bit_t = 0.1;

%% message generation with BPSK
m = [0 0 1 1 1 1 0 0];
for bit = 1:length(m)
   if(m(bit)==0)
        m(bit) = -1;
   end
end 

message =  repmat(m,fp,1);
message =  reshape(message,1,[]);

%% PN generation and multiply with message
% pn_code = randi([0,1],1,length(m)*fp);
pn_code = [1,0,0,1,0,1,1,0,0,0,1,0,1,1,1,1,0,0,1,1,0,0,1,0,1,0,0,1,1,1,0,1,0,1,1,1,0,1,1,1,0,0,1,0,0,1,1,1,1,0,0,1,0,1,0,1,0,0,1,1,0,0,1,1,0,0,1,0,0,0,0,1,0,1,0,0,1,0,0,1,0,0,1,1,1,0,0,0,0,1,1,0,1,0,1,0,1,1,1,0,0,0,0,1,0,1,1,1,1,0,0,1,1,0,1,0,1,0,1,0,0,0,1,0,0,1,1,0,0,1,1,0,1,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,1,0,1,0,0,1,1,0,1,1,0,1,1,1,0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,1,0,1,1,1,0,0,0,1,1,0,1,1,1,0,0,1,1,0,0,1,0,1,1,0,0,0,1,1,1,0,1,1,0,0,1,1,1,0,0,0,1,0,0,0,1,0,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0,1];

for bit = 1:length(pn_code)
   if(pn_code(bit)==0)
        pn_code(bit) = -1;
   end
end 

DSSS = message.*pn_code;

%% create carrier and multipy with encoded sequence
t = 0:1/Fs:(bit_t-1/Fs);
s0 = -1*cos(2*pi*fc*t);
s1 = cos(2*pi*fc*t);
carrier = [];
BPSK = [];
for i = 1:length(DSSS)
    if (DSSS(i) == 1)
        BPSK = [BPSK s1];
    elseif (DSSS(i) == -1)
        BPSK = [BPSK s0];
    end 
    carrier = [carrier s1];
end    

%% save audio
filename = "BPSK.wav";
audiowrite(filename, BPSK, Fs);

% %% load audio
% filename = "BPSK_rec.wav";
% [BPSK, Fs] = audioread(filename);
% BPSK = BPSK';

%% my demodulation
% my carrier
myCarrier = [];
for i = 1:length(DSSS)
    myCarrier = [myCarrier s1];
end
% my demodulation
myRx =[];
myDemod = BPSK.*myCarrier;
t_Len = length(t);
for i = 1:length(pn_code)
    sumVal = sum(myDemod((((i-1)*t_Len)+1):i*t_Len));
    if(sumVal > 0)
        myRx = [myRx 1];
    else
        myRx = [myRx -1];
    end    
end
myCorr = xcorr(myRx,pn_code);
resultDebug = myRx.*pn_code;
if resultDebug == message
    fprintf("equals\n");
end
%% demodulation
rx =[];
for i = 1:length(pn_code)
    if(pn_code(i)==1)
        rx = [rx BPSK((((i-1)*length(t))+1):i*length(t))];
    else
        rx = [rx (-1)*BPSK((((i-1)*length(t))+1):i*length(t))];
    end    
end 

demod = rx.*carrier;
result = [];
for i = 1:length(m)
   x = length(t)*fp;
   cx = sum(carrier(((i-1)*x)+1:i*x).*demod(((i-1)*x)+1:i*x));
   if(cx>0)
       result = [result 1];
   else
       result = [result -1];
   end    
end    

pn_codeWrong = randi([0,1],1,length(m)*fp);
resultWrong = [];
rx2 =[];
for i = 1:length(pn_code)
    if(pn_codeWrong(i)==1)
        rx2 = [rx2 BPSK((((i-1)*length(t))+1):i*length(t))];
    else
        rx2 = [rx2 (-1)*BPSK((((i-1)*length(t))+1):i*length(t))];
    end    
end 

demod2 = rx2.*carrier;
for i = 1:length(m)
   x = length(t)*fp;
   cx = sum(carrier(((i-1)*x)+1:i*x).*demod2(((i-1)*x)+1:i*x));
   if(cx>0)
       resultWrong = [resultWrong 1];
   else
       resultWrong = [resultWrong -1];
   end    
end    
message1 =  repmat(result,fp,1);
message1 =  reshape(message1,1,[]);
message2 =  repmat(resultWrong,fp,1);
message2 =  reshape(message2,1,[]);



% %% Draw original message, PN code , encoded sequence on time domain
% pn_size = length(pn_code);
% tpn = linspace(0,length(m)*bit_t-bit_t/fp,pn_size);
% tm = 0:bit_t/fp:length(m)*bit_t-bit_t/fp;
% figure
% subplot(311)
% stairs(tm,message,'linewidth',2)
% title('Message bit sequence')
% axis([0 length(m)*bit_t -1 1]);
% subplot(312)
% stairs(tpn,pn_code,'linewidth',2)
% title('Pseudo-random code');
% axis([0 length(m)*bit_t -1 1]);
% subplot(313)
% stairs(tpn,DSSS,'linewidth',2)
% title('Modulated signal');
% axis([0 length(m)*bit_t -1 1]);
% 
% figure
% subplot(311)
% stairs(tm,message,'linewidth',2)
% title('Message bit sequence')
% axis([0 length(m)*bit_t -1 1]);
% subplot(312)
% stairs(tm,message1,'linewidth',2)
% title('Received message using true pseudo-random code')
% axis([0 length(m)*bit_t -1 1]);
% subplot(313)
% stairs(tm,message2,'linewidth',2)
% title('Received message using wrong pseudo-random code')
% axis([0 length(m)*bit_t -1 1]);
% 
% %% Draw original message, PN code , encoded sequence on frequency domain
% f = linspace(-Fs/2,Fs/2,1024);
% figure
% subplot(311)
% plot(f,abs(fftshift(fft(message,1024))),'linewidth',2);
% title('Message spectrum')
% subplot(312)
% plot(f,abs(fftshift(fft(pn_code,1024))),'linewidth',2);
% title('Pseudo-random code spectrum');
% subplot(313)
% plot(f,abs(fftshift(fft(DSSS,1024))),'linewidth',2);
% title('Modulated signal spectrum');
% figure;
% subplot(311)
% plot(f,abs(fftshift(fft(BPSK,1024))),'linewidth',2);
% title('Transmitted signal spectrum');
% subplot(312)
% plot(f,abs(fftshift(fft(rx,1024))),'linewidth',2);
% title('Received signal multiplied by pseudo code');
% subplot(313)
% plot(f,abs(fftshift(fft(demod,1024))),'linewidth',2);
% title('Demodulated signal spectrum before decision device ');
