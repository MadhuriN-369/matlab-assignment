%% Q11 - Router Queue and Waiting Time (FCFS, deterministic)
clear; clc; close all;

interArr = [0 3 2 5 1 4 2 3];       % ms
service  = [4 2 3 2 4 1 3 2];       % ms
n = numel(service);
pkt = 1:n;

% 1. Arrival times
arrival = cumsum(interArr);

% 2-3. Service start and departure
start  = zeros(1, n);
depart = zeros(1, n);
for k = 1:n
    if k == 1
        start(k) = arrival(k);
    else
        start(k) = max(arrival(k), depart(k-1));
    end
    depart(k) = start(k) + service(k);
end

% 4-5. Waiting time and time in system
waitT   = start  - arrival;
sysTime = depart - arrival;

% 6. Table
fprintf('%-8s %-10s %-14s %-12s %-12s %-14s\n', 'Packet', 'Arrival', 'Service start', 'Departure', 'Waiting', 'In system');
for k = 1:n
    fprintf('%-8d %-10d %-14d %-12d %-12d %-14d\n', pkt(k), arrival(k), start(k), depart(k), waitT(k), sysTime(k));
end
fprintf('(all times in ms)\n');

% 7. Plot
figure;
bar(pkt, waitT);
grid on;
title('Waiting Time per Packet in the Router Queue');
xlabel('Packet number');
ylabel('Waiting time (ms)');
xticks(pkt);
ylim([0, max(waitT) + 1]);

maxWait = max(waitT);
worst   = find(waitT == maxWait);
fprintf('\nLongest waiting time = %d ms, experienced by packet(s): %s\n', maxWait, num2str(worst));
fprintf('Average waiting time = %.3f ms, average time in system = %.3f ms\n', mean(waitT), mean(sysTime));
