clear all;close all;clc;

%% parameters
Fs = 48000;
fc = 1000;
fp = 32;
bit_t = 0.001;

%% message generation with BPSK
m = [0 0 1 1 1 1 0 0];
m(m == 0) = -1;

message =  repmat(m,fp,1);
message =  reshape(message,1,[]);
save('message.mat', 'message');
% load('message.mat', 'message');
%% PN generation and multiply with message
% pn_code = randi([0,1],1,fp);
pn_code = [1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,0,1,1,1,0,0,0,0,0,0,1,1,0,0];
pn_code(pn_code == 0) = -1;
save('pn_code.mat', 'pn_code');
% load('pn_code.mat', 'pn_code');

%% PN to data
DSSS = zeros(1, length(m) * fp);
for i = 1:length(m)
    start_idx = (i - 1) * fp + 1;
    end_idx = i * fp;
    DSSS(start_idx:end_idx) = m(i) * pn_code; % Direct assignment
end

%% bar DSSS
bar(DSSS);

%% create carrier and multipy with encoded sequence
t = 0:1/Fs:(bit_t-1/Fs);
s0 = -1*sin(2*pi*fc*t);
s1 = sin(2*pi*fc*t);
% s0 = -1*cos(2*pi*fc*t);
% s1 = cos(2*pi*fc*t);
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
figure();
plot(carrier);

%% save audio
filename = "BPSK.wav";
audiowrite(filename, BPSK, Fs);