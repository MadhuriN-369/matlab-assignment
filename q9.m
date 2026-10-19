%% Q9 - Packet Loss and Network Performance
clear; clc; close all;

% 1. Data (NaN for lost packets)
pktNum = 1:10;
status = [1 1 1 0 1 1 0 1 1 1];
delay  = [12 15 11 NaN 18 14 NaN 20 13 16];     % ms

% 2. Counts
nTx   = numel(pktNum);
nRx   = sum(status == 1);
nLost = sum(status == 0);

% 3. Ratios
PDR  = nRx   / nTx * 100;
PLR  = nLost / nTx * 100;

% 4. Delay statistics (received packets only)
rxDelay    = delay(status == 1);
meanDelay  = mean(rxDelay);
medDelay   = median(rxDelay);
minDelay   = min(rxDelay);
maxDelay   = max(rxDelay);

% 6. Summary
fprintf('Packets transmitted : %d\n', nTx);
fprintf('Packets received    : %d\n', nRx);
fprintf('Packets lost        : %d\n', nLost);
fprintf('Packet delivery ratio : %.1f %%\n', PDR);
fprintf('Packet loss ratio     : %.1f %%\n', PLR);
fprintf('Mean delay   : %.3f ms\n', meanDelay);
fprintf('Median delay : %.3f ms\n', medDelay);
fprintf('Minimum delay: %.3f ms\n', minDelay);
fprintf('Maximum delay: %.3f ms\n', maxDelay);

% 5. Plot
figure; hold on;
hRx = plot(pktNum(status==1), delay(status==1), 'b-o', 'LineWidth', 1.3, 'MarkerFaceColor', 'b');
lostIdx = find(status == 0);
hLost = plot(pktNum(lostIdx), zeros(size(lostIdx)), 'rx', 'MarkerSize', 12, 'LineWidth', 2.5);
grid on;
legend([hRx hLost], 'Received packet delay', 'Lost packet (no delay measured)', 'Location', 'north');
title('Measured One-Way Delay per Packet');
xlabel('Packet number');
ylabel('One-way delay (ms)');
xticks(pktNum);
ylim([0, maxDelay*1.2]);
hold off;

fprintf('\nInterpretation: a lost packet has no delay measurement at all. Treating it as 0 ms\n');
fprintf('would suggest it arrived instantly, which would drag the mean and minimum delay down\n');
fprintf('and make the network look faster than it really is. Loss is reported separately as the\n');
fprintf('loss ratio, and delay statistics use received packets only.\n');
