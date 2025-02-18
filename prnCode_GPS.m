clear all;close all;clc;

% Parameters for G1 and G2
G1_taps = [3 10];
G2_taps = [2 3 6 8 9 10];
prn_number = 1;  % PRN 1

% G2 tap selections for PRNs (For PRN 1: taps 2 and 6)
G2_select = [2, 6];

% Initialize Registers with all ones
G1 = ones(1, 10);
G2 = ones(1, 10);
C_A_code = zeros(1, 1024);

% Generate 1023-bit C/A code
for i = 1:1024
    % Get the output of G1 and G2
    G1_out = G1(end);
    G2_out = xor(G2(G2_select(1)), G2(G2_select(2)));
    
    % XOR G1 and G2 outputs to get the C/A code bit
    C_A_code(i) = xor(G1_out, G2_out);
    
    % Shift G1
    G1_feedback = xor(G1(G1_taps(1)), G1(G1_taps(2)));
    G1 = [G1_feedback, G1(1:end-1)];
    
    % Shift G2
    G2_feedback = G2(G2_taps(1));
    for j = 2:length(G2_taps)
        G2_feedback = xor(G2_feedback, G2(G2_taps(j)));
    end
    G2 = [G2_feedback, G2(1:end-1)];
end

% Display the C/A code
disp('1023-bit C/A Code for PRN 1:');
disp(C_A_code);

% Optional: Plot the C/A code
figure;
stem(C_A_code, 'filled');
title('1023-bit C/A Code for PRN 1');
xlabel('Bit Position');
ylabel('Code Value');
grid on;
