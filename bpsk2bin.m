clear all;close all;clc;

fc = 1000;

filename = "BPSK_.wav";
[BPSK, Fs] = audioread(filename);
BPSK = BPSK';

startInd = 0;
for i = 1:length(BPSK)
    if abs(BPSK(i)) > 0.3
        startInd = i;
        break;
    end
end
P = 1;
Q = 48;
bin_BPSK = resample(BPSK(startInd:end), P, Q);

for i = 1:length(bin_BPSK)
    if     bin_BPSK(i) > 0.3
        bin_BPSK(i) = 1;
    elseif bin_BPSK(i) < -0.3
        bin_BPSK(i) = 0;
    else
        bin_BPSK = bin_BPSK(1:i);
        break;
    end
    
end
