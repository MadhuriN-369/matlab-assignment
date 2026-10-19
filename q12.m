%% Q12 - Multi-Hop Delay and Bottleneck Link
clear; clc; close all;

cap_Mbps  = [10 8 4];
prop_ms   = [3 5 4];
payload   = 1000;       % bytes
header    = 40;         % bytes

% 1. Total packet size
pktBytes = payload + header;
pktBits  = pktBytes * 8;
fprintf('Total packet size : %d bytes = %d bits\n\n', pktBytes, pktBits);

% 2. Transmission time on each link
Ttx = pktBits ./ (cap_Mbps * 1e6);             % s
fprintf('%-8s %-16s %-20s %-20s\n', 'Link', 'Capacity (Mbps)', 'Transmission (s)', 'Transmission (ms)');
for k = 1:3
    fprintf('%-8d %-16d %-20.6f %-20.4f\n', k, cap_Mbps(k), Ttx(k), Ttx(k)*1e3);
end

% 3. First-packet one-way delay
Tfirst = sum(Ttx) + sum(prop_ms)*1e-3;
fprintf('\nTotal transmission delay : %.4f ms\n', sum(Ttx)*1e3);
fprintf('Total propagation delay  : %.4f ms\n', sum(prop_ms));
fprintf('First-packet one-way delay: %.4f ms\n\n', Tfirst*1e3);

% 4. Bottleneck and steady-state throughput
[bn, bnIdx] = min(cap_Mbps);
thr = bn * payload / (payload + header);
fprintf('Bottleneck link: link %d (%d Mbps)\n', bnIdx, bn);
fprintf('Steady-state payload throughput: %.4f Mbps\n\n', thr);

% 5. Vary payload size
payloads = [500 1000 1500 3000];
eff      = payloads ./ (payloads + header);        % fraction
thrs     = bn * eff;                               % Mbps
fprintf('%-16s %-18s %-24s\n', 'Payload (bytes)', 'Efficiency (%)', 'Payload throughput (Mbps)');
for k = 1:numel(payloads)
    fprintf('%-16d %-18.3f %-24.4f\n', payloads(k), eff(k)*100, thrs(k));
end

% 6. Plots
figure;
subplot(2,1,1);
plot(payloads, eff*100, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
grid on;
title('Payload Size vs Payload Efficiency');
xlabel('Payload size (bytes)');
ylabel('Payload efficiency (%)');

subplot(2,1,2);
plot(payloads, thrs, '-s', 'LineWidth', 1.5, 'MarkerFaceColor', 'r', 'Color', 'r');
grid on;
title('Payload Size vs Steady-State Payload Throughput');
xlabel('Payload size (bytes)');
ylabel('Payload throughput (Mbps)');

fprintf('\nInterpretation: the first packet must be fully received and re-transmitted at every\n');
fprintf('store-and-forward hop, so its delay is the SUM of all transmission and propagation\n');
fprintf('delays. In a long stream the hops work in parallel (pipelining), so the rate is limited\n');
fprintf('by the slowest (bottleneck) link, reduced by header overhead.\n');
