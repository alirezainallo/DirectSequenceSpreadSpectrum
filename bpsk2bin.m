clear all;close all;clc;

load('message.mat', 'messageReal');
load('pn_code.mat', 'pn_code');

fc = 1000;

% filename = "bpsk_sin_.wav";
% filename = "BPSK.wav";
filename = "BPSK_new_prn.wav";
[BPSK, Fs] = audioread(filename);
BPSK = BPSK';
figure();
plot(BPSK);

% K = 1.01;
% [P, Q] = float_to_rational(K);
% resample_BPSK = resample(BPSK, P, Q);
% 
% figure();
% plot(resample_BPSK);
% 
% resample_BPSK_2 = resample(resample_BPSK, 1, 48);
% 
% figure();
% plot(resample_BPSK_2);

K = 1;
% resample_BPSK_3 = resample(BPSK, 1, 48);
step = (Fs/fc)*K;
resample_BPSK_3 = BPSK(100:step:end);
for i = 1:length(resample_BPSK_3)
    if resample_BPSK_3(i) > 0
        resample_BPSK_3(i) = 1;
    else
        resample_BPSK_3(i) = -1;
    end
end
figure();
bar(resample_BPSK_3);

K = 1.02;
% resample_BPSK_3 = resample(BPSK, 1, 48);
step = (Fs/fc)*K;
resample_BPSK_3 = BPSK(50:step:end);
for i = 1:length(resample_BPSK_3)
    if resample_BPSK_3(i) > 0
        resample_BPSK_3(i) = 1;
    else
        resample_BPSK_3(i) = -1;
    end
end
figure();
bar(resample_BPSK_3);

function [p, q] = float_to_rational(k, tol)
    % k: the float number you want to convert to a rational fraction
    % tol: the tolerance for the approximation (optional)
    
    if nargin < 2
        tol = 1e-6; % Default tolerance
    end
    
    % Use the rat function to get the rational approximation
    [N, D] = rat(k, tol);
    
    % N is the numerator (p), D is the denominator (q)
    p = N;
    q = D;
end