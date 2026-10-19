%% Q3 - Stop-and-Wait ARQ Efficiency
clear; clc; close all;

frameBytes = 1000;
bw_Mbps    = 4;
prop_ms    = 20;        % one-way propagation delay

frameBits = frameBytes * 8;

% 1. Frame transmission time
Tf = frameBits / (bw_Mbps * 1e6);          % s

% 2. Round-trip propagation time
RTT = 2 * prop_ms * 1e-3;                  % s

% 3. Efficiency
eff = Tf / (Tf + RTT);

% 4. Effective throughput
thr_Mbps = eff * bw_Mbps;

fprintf('Frame transmission time : %.6f s = %.3f ms\n', Tf, Tf*1e3);
fprintf('Round-trip propagation  : %.3f ms\n', RTT*1e3);
fprintf('Efficiency              : %.3f %%\n', eff*100);
fprintf('Effective throughput    : %.4f Mbps\n\n', thr_Mbps);

% 5. Vary one-way propagation delay
propList = [5 10 20 40 80];                % ms
RTTs   = 2 * propList * 1e-3;
effs   = Tf ./ (Tf + RTTs);
thrs   = effs * bw_Mbps;

fprintf('%-18s %-16s %-16s %-20s\n', 'One-way prop (ms)', 'RTT (ms)', 'Efficiency (%)', 'Throughput (Mbps)');
for k = 1:numel(propList)
    fprintf('%-18d %-16.1f %-16.3f %-20.4f\n', propList(k), RTTs(k)*1e3, effs(k)*100, thrs(k));
end

% 6. Plot
figure;
plot(propList, effs*100, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
grid on;
title('Stop-and-Wait ARQ: Propagation Delay vs Efficiency');
xlabel('One-way propagation delay (ms)');
ylabel('Efficiency (%)');

fprintf('\nInterpretation: efficiency falls as propagation delay grows. The sender spends\n');
fprintf('only the short frame transmission time sending and the rest of each cycle idle,\n');
fprintf('waiting for the ACK. Long-delay links therefore waste most of their bandwidth.\n');
