fs = 1000;                    % Original sampling frequency
t = 0:1/fs:1-1/fs;            % Time vector
x = sin(2*pi*50*t);           % Example signal (50 Hz sine wave)
P = 3;                        % Upsampling factor
Q = 2;                        % Downsampling factor
y = resample(x, P, Q);        % Resample signal

% Plot the original and resampled signals
subplot(2,1,1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
t_resampled = (0:length(y)-1) * (Q/fs/P);
plot(t_resampled, y);
title('Resampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');
