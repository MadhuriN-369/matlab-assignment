%% Q6 - Routing with a Link-Cost Matrix (Dijkstra)
clear; clc; close all;

names = {'A','B','C','D','E'};
W = [0 2 5 0 0;
     2 0 1 3 0;
     5 1 0 2 6;
     0 3 2 0 1;
     0 0 6 1 0];
W = max(W, W');                 % make sure it is symmetric
src = 1;                        % Router A

% 1. Display matrix
disp('Cost matrix (router order A B C D E):'); disp(W);

% 2-3. Original network
[dist1, prev1] = dijkstra(W, src);
fprintf('=== Original network ===\n');
printTable(dist1, prev1, src, names);

% 4-5. Draw with A->E highlighted
drawNetwork(W, names, getPath(prev1, src, 5), 'Original network: lowest-cost route A to E');

% 6. Change link B-D from 3 to 8
W2 = W;  W2(2,4) = 8;  W2(4,2) = 8;
[dist2, prev2] = dijkstra(W2, src);
fprintf('\n=== After changing cost of B-D from 3 to 8 ===\n');
printTable(dist2, prev2, src, names);
drawNetwork(W2, names, getPath(prev2, src, 5), 'Modified network (B-D = 8): lowest-cost route A to E');

fprintf('\n=== Changes ===\n');
anyChange = false;
for d = 2:5
    p1 = getPath(prev1, src, d);  p2 = getPath(prev2, src, d);
    if dist1(d) ~= dist2(d) || ~isequal(p1, p2)
        anyChange = true;
        fprintf('Destination %s: cost %g -> %g, route [%s] -> [%s]\n', names{d}, ...
            dist1(d), dist2(d), strjoin(names(p1), '-'), strjoin(names(p2), '-'));
    end
end
if ~anyChange, fprintf('No route or cost changed.\n'); end
fprintf('\nNote: where two routes have equal cost (a tie), Dijkstra keeps the first one found,\n');
fprintf('so a route can change even when its total cost stays the same.\n');

% ---------- local functions ----------
function [dist, prev] = dijkstra(W, src)
    n = size(W,1);
    dist = inf(1,n);  prev = zeros(1,n);  visited = false(1,n);
    dist(src) = 0;
    for k = 1:n
        d = dist;  d(visited) = inf;
        [m, u] = min(d);
        if isinf(m), break; end
        visited(u) = true;
        for v = 1:n
            if W(u,v) > 0 && ~visited(v) && dist(u) + W(u,v) < dist(v)
                dist(v) = dist(u) + W(u,v);
                prev(v) = u;
            end
        end
    end
end

function p = getPath(prev, src, dst)
    p = dst;
    while p(1) ~= src
        p = [prev(p(1)) p];
    end
end

function printTable(dist, prev, src, names)
    fprintf('%-12s %-12s %-s\n', 'Destination', 'Total cost', 'Route');
    for d = 1:numel(names)
        if d == src, continue; end
        p = getPath(prev, src, d);
        fprintf('%-12s %-12g %-s\n', names{d}, dist(d), strjoin(names(p), ' -> '));
    end
end

function drawNetwork(W, names, path, ttl)
    G = graph(W, names);                       % weights come from the matrix
    figure;
    h = plot(G, 'EdgeLabel', G.Edges.Weight, 'LineWidth', 1.5, 'MarkerSize', 8, 'NodeFontSize', 12);
    highlight(h, path(1:end-1), path(2:end), 'EdgeColor', 'r', 'LineWidth', 3.5);
    highlight(h, path, 'NodeColor', 'r');
    title(ttl);
end
