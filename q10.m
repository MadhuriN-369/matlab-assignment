%% Q10 - Bandwidth Comparison and File Download Time
clear; clc; close all;

fileSize_MB = 150;
% 1. Arrays
names    = {'Connection A', 'Connection B', 'Connection C'};
bw_Mbps  = [25 50 100];
usable   = [0.80 0.55 0.30];

% 2. Effective bandwidth
effBW = bw_Mbps .* usable;

% 3. File size in bits and download time
fileBits = fileSize_MB * 1e6 * 8;
time_s   = fileBits ./ (effBW * 1e6);

% 4. Table
fprintf('File size = %d MB = %.0f bits\n\n', fileSize_MB, fileBits);
fprintf('%-14s %-18s %-14s %-20s %-18s\n', 'Connection', 'Nominal (Mbps)', 'Usable frac.', 'Effective (Mbps)', 'Download time (s)');
for k = 1:3
    fprintf('%-14s %-18.1f %-14.2f %-20.2f %-18.2f\n', names{k}, bw_Mbps(k), usable(k), effBW(k), time_s(k));
end

% 5. Bar chart
figure;
bar(time_s);
set(gca, 'XTickLabel', names);
grid on;
title('Estimated Download Time of a 150 MB File');
xlabel('Connection');
ylabel('Download time (s)');
for k = 1:3
    text(k, time_s(k), sprintf('%.1f s', time_s(k)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

% 6. Fastest connection
[tmin, idx] = min(time_s);
fprintf('\nFastest connection: %s (%.2f s)\n', names{idx}, tmin);
fprintf('Interpretation: download time depends on the EFFECTIVE bandwidth (nominal x usable\n');
fprintf('fraction), not the nominal bandwidth. A fast link that is heavily utilised by other\n');
fprintf('traffic may leave less capacity for your file than a slower but lightly used link.\n');
