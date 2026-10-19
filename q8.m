%% Q8 - Simplified TCP Congestion Window
clear; clc; close all;

initCwnd  = 1;      % segments
ssInit    = 8;      % segments
N         = 15;     % rounds
lossRound = 10;     % loss occurs at the end of this round

% 1. Storage
rounds   = 1:N;
cwnd     = zeros(1, N);
phase    = zeros(1, N);       % 1 = slow start, 2 = congestion avoidance
ssLog    = zeros(1, N);       % ssthresh in effect for each round
cwnd(1)  = initCwnd;  phase(1) = 1;
ss       = ssInit;  ssLog(1) = ss;

% 2-4. Simulation
for r = 2:N
    if r == lossRound + 1                  % loss at end of round 10
        ss      = max(floor(cwnd(r-1)/2), 2);
        cwnd(r) = 1;
        phase(r) = 1;                      % restart in slow start
    elseif cwnd(r-1) < ss                  % slow start: double, but do not overshoot ssthresh
        cwnd(r)  = min(2*cwnd(r-1), ss);
        phase(r) = 1;
    else                                   % congestion avoidance: +1 per round
        cwnd(r)  = cwnd(r-1) + 1;
        phase(r) = 2;
    end
    ssLog(r) = ss;
end

% 5. Table
phaseName = {'Slow start', 'Congestion avoidance'};
fprintf('%-8s %-12s %-12s %-22s\n', 'Round', 'cwnd (seg)', 'ssthresh', 'Phase');
for r = 1:N
    fprintf('%-8d %-12d %-12d %-22s\n', r, cwnd(r), ssLog(r), phaseName{phase(r)});
end

% 6. Plot
figure; hold on;
plot(rounds, cwnd, 'k-', 'LineWidth', 1);
hSS = plot(rounds(phase==1), cwnd(phase==1), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
hCA = plot(rounds(phase==2), cwnd(phase==2), 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 7);
yl = [0, max(cwnd) + 2];
ylim(yl);
hLoss = plot([lossRound lossRound], yl, 'r--', 'LineWidth', 1.5);
text(lossRound + 0.15, yl(2) - 1, 'Loss event (end of round 10)', 'Color', 'r');
grid on;
legend([hSS hCA hLoss], 'Slow start', 'Congestion avoidance', 'Loss event', 'Location', 'northwest');
title('TCP Congestion Window vs Round');
xlabel('Round number');
ylabel('Congestion window (segments)');
xticks(1:N);
hold off;

fprintf('\nInterpretation: cwnd grows exponentially in slow start until it reaches ssthresh,\n');
fprintf('then grows linearly in congestion avoidance. After the loss, ssthresh is halved,\n');
fprintf('cwnd restarts at 1, and growth switches to linear earlier because ssthresh is lower.\n');
fprintf('(Assumption: in slow start cwnd is capped at ssthresh so it does not overshoot it.)\n');
