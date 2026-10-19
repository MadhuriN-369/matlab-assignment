%% Q2 - Transmission, Propagation and Total Delay
clear; clc; close all;

pktBytes   = 1500;
bw_Mbps    = 10;
dist_km    = 1200;
propSpeed  = 2e8;       % m/s
procDelay  = 2e-3;      % s (sender + receiver combined)

% 1. Packet size in bits
pktBits = pktBytes * 8;

% 2. Transmission delay
Ttrans = pktBits / (bw_Mbps * 1e6);

% 3. Propagation delay
dist_m = dist_km * 1000;
Tprop  = dist_m / propSpeed;

% 4. Total one-way delay
Ttotal = Ttrans + Tprop + procDelay;

fprintf('Packet size         : %d bytes = %d bits\n', pktBytes, pktBits);
fprintf('Transmission delay  : %.6f s = %.3f ms\n', Ttrans, Ttrans*1e3);
fprintf('Link distance       : %.0f km = %.0f m\n', dist_km, dist_m);
fprintf('Propagation delay   : %.6f s = %.3f ms\n', Tprop, Tprop*1e3);
fprintf('Processing delay    : %.3f ms\n', procDelay*1e3);
fprintf('Total one-way delay : %.3f ms\n\n', Ttotal*1e3);

% 5. Vary bandwidth
bwList = [5 10 20 50];
Tt = pktBits ./ (bwList * 1e6);
Tot = Tt + Tprop + procDelay;

fprintf('%-16s %-18s %-18s %-18s %-18s\n', 'Bandwidth(Mbps)', 'Transmission(ms)', 'Propagation(ms)', 'Processing(ms)', 'Total(ms)');
for k = 1:numel(bwList)
    fprintf('%-16d %-18.3f %-18.3f %-18.3f %-18.3f\n', bwList(k), Tt(k)*1e3, Tprop*1e3, procDelay*1e3, Tot(k)*1e3);
end

% 6. Plot
figure;
plot(bwList, Tot*1e3, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
grid on;
title('Bandwidth vs Total One-Way Delay');
xlabel('Link bandwidth (Mbps)');
ylabel('Total one-way delay (ms)');
ylim([0, max(Tot*1e3)*1.2]);

fprintf('\nInterpretation: raising bandwidth only shrinks the transmission delay.\n');
fprintf('Propagation delay (distance / signal speed) and processing delay do not depend\n');
fprintf('on bandwidth, so the total delay levels off at their sum and never reaches zero.\n');
