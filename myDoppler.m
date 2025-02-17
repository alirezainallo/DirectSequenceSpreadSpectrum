clear all;close all;clc;
% Parameters
fs = 1e4; % Sampling frequency
fc = 1000; % Carrier frequency (Hz)
fd = 50; % Doppler shift (Hz)
Rb = 100; % Bit rate
N = 100; % Number of bits

% Generate random BPSK message
bits = randi([0 1], 1, N);
bpsk_mod = 2*bits - 1;

% Time vector
t = (0:(length(bpsk_mod)*fs/Rb)-1)/fs;

% Carrier and Doppler Effect
carrier = cos(2*pi*fc*t);
doppler = cos(2*pi*(fc+fd)*t);
rx_signal = bpsk_mod(repelem(1:N, fs/Rb)) .* doppler;

% Doppler Compensation Loop
f_est = fc; % Initial estimate of frequency
step_size = 0.1; % Frequency adjustment step
num_iterations = 100;

for iter = 1:num_iterations
    % Local oscillator
    local_osc = cos(2*pi*f_est*t);
    
    % Mix (Down-convert)
    mixed_signal = rx_signal .* local_osc;
    
    % Low-pass filter (simple moving average)
    filt_signal = filter(ones(1,10)/10, 1, mixed_signal);
    
    % Demodulate
    demod = filt_signal(1:fs/Rb:end);
    rx_bits = demod > 0;
    
    % Correlation with original bits
    corr_val = sum(rx_bits == bits);
    
    % Adjust frequency estimate
    if corr_val < N/2
        f_est = f_est + step_size;
    else
        f_est = f_est - step_size;
    end
end

% Results
disp(['Estimated Doppler Shift: ', num2str(f_est - fc), ' Hz']);
disp(['Bit Error Rate (BER): ', num2str(sum(rx_bits ~= bits) / N)]);

% Plot
figure;
subplot(3,1,1);
plot(t, rx_signal);
title('Received Signal with Doppler Shift');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,2);
plot(t, mixed_signal);
title('After Mixing with Local Oscillator');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,3);
stem(bits, 'b');
hold on;
stem(rx_bits, 'r');
title('Transmitted vs. Received Bits');
xlabel('Bit Index'); ylabel('Bit Value');
legend('Transmitted', 'Received');
