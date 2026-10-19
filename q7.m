%% Q7 - Pure ALOHA vs Slotted ALOHA
clear; clc; close all;

% 1. Offered load
G = 0:0.05:3;

% 2. Throughput
S_pure    = G .* exp(-2*G);
S_slotted = G .* exp(-G);

% 3. Plot
figure;
plot(G, S_pure, 'b-', G, S_slotted, 'r-', 'LineWidth', 1.8);
grid on;
legend('Pure ALOHA  S = G e^{-2G}', 'Slotted ALOHA  S = G e^{-G}', 'Location', 'northeast');
title('Normalized Throughput of Pure and Slotted ALOHA');
xlabel('Offered load G (attempts per frame time)');
ylabel('Normalized throughput S');

% 4. Maximum throughput
[maxP, iP] = max(S_pure);
[maxS, iS] = max(S_slotted);
fprintf('Pure ALOHA    : max S = %.4f at G = %.2f\n', maxP, G(iP));
fprintf('Slotted ALOHA : max S = %.4f at G = %.2f\n\n', maxS, G(iS));

% 5. Values at G = 0.5, 1.0, 2.0
Gq = [0.5 1.0 2.0];
fprintf('%-8s %-18s %-18s\n', 'G', 'Pure ALOHA (S)', 'Slotted ALOHA (S)');
for g = Gq
    k = find(abs(G - g) < 1e-9, 1);
    fprintf('%-8.1f %-18.4f %-18.4f\n', g, S_pure(k), S_slotted(k));
end

% 6. Interpretation
fprintf('\nInterpretation: Slotted ALOHA has the higher theoretical maximum (about twice\n');
fprintf('that of Pure ALOHA). In Pure ALOHA a frame can collide with others that start\n');
fprintf('within two frame times (a vulnerable period of 2T). Slotted ALOHA forces stations\n');
fprintf('to start only at slot boundaries, halving the vulnerable period to T.\n');
