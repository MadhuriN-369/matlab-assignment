%% Q1 - Network Throughput and Data Transfer Time
clear; clc; close all;

% 1. Variables
fileSize_MB  = 24;      % MB (1 MB = 1,000,000 bytes)
linkCap_Mbps = 20;      % Mbps
usableFactor = 0.75;    % fraction of capacity available for file data

% 2. Effective data rate
effRate_Mbps = linkCap_Mbps * usableFactor;

% 3. File size in bits and transfer time
fileSize_bits  = fileSize_MB * 1e6 * 8;
transferTime_s = fileSize_bits / (effRate_Mbps * 1e6);

fprintf('--- Base case ---\n');
fprintf('File size            : %.0f MB = %.0f bits\n', fileSize_MB, fileSize_bits);
fprintf('Usable capacity      : %.2f\n', usableFactor);
fprintf('Effective data rate  : %.2f Mbps\n', effRate_Mbps);
fprintf('Transfer time        : %.2f s\n\n', transferTime_s);

% 4. Repeat for several usable capacity factors
factors   = [0.50 0.60 0.75 0.90 1.00];
effRates  = linkCap_Mbps * factors;
times_s   = fileSize_bits ./ (effRates * 1e6);

% 6. Results table
fprintf('%-18s %-22s %-20s\n', 'Usable factor', 'Effective rate (Mbps)', 'Transfer time (s)');
for k = 1:numel(factors)
    fprintf('%-18.2f %-22.2f %-20.2f\n', factors(k), effRates(k), times_s(k));
end

% 5. Plot
figure;
plot(factors, times_s, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
grid on;
title('Usable Capacity Factor vs Estimated Transfer Time');
xlabel('Usable capacity factor (fraction of 20 Mbps)');
ylabel('Estimated transfer time (s)');

% Interpretation
fprintf('\nInterpretation: transfer time is inversely proportional to the usable\n');
fprintf('capacity factor. As more of the link is available for data, the effective\n');
fprintf('rate rises and the same file takes less time to send.\n');
