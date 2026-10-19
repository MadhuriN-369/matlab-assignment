%% Q5 - IPv4 Subnet Calculation
clear; clc;

baseIP     = '192.168.10.0';
basePrefix = 24;
numSubnets = 4;
minHosts   = 50;

% 1. Minimum host bits so that 2^h - 2 >= minHosts
h = 0;
while 2^h - 2 < minHosts
    h = h + 1;
end
fprintf('Minimum host bits needed for >= %d usable hosts : %d\n', minHosts, h);

% 2. Prefix length and address count per subnet
newPrefix  = 32 - h;
totalAddr  = 2^h;
usableAddr = totalAddr - 2;
fprintf('Subnet prefix length : /%d\n', newPrefix);
fprintf('Addresses per subnet : %d (usable hosts: %d)\n\n', totalAddr, usableAddr);

% 3. Does the /24 block hold four subnets of this size?
blockSize = 2^(32 - basePrefix);
if numSubnets * totalAddr <= blockSize
    fprintf('Check: %d x %d = %d addresses <= %d, so the /%d block CAN supply %d subnets.\n\n', ...
        numSubnets, totalAddr, numSubnets*totalAddr, blockSize, basePrefix, numSubnets);
else
    fprintf('Check: the /%d block can NOT supply %d subnets of /%d.\n\n', basePrefix, numSubnets, newPrefix);
end

% 4 & 6. Subnet allocation table
baseNum = ip2num(baseIP);
fprintf('%-8s %-18s %-18s %-18s %-18s\n', 'Subnet', 'Network', 'First usable', 'Last usable', 'Broadcast');
for k = 0:numSubnets-1
    netNum   = baseNum + k * totalAddr;
    bcastNum = netNum + totalAddr - 1;
    fprintf('%-8s %-18s %-18s %-18s %-18s\n', ...
        sprintf('Room %d', k+1), ...
        [num2ip(netNum)       '/' num2str(newPrefix)], ...
        num2ip(netNum + 1), num2ip(bcastNum - 1), num2ip(bcastNum));
end

% 5. Test the function
fprintf('\n--- Function test: 192.168.10.77/26 ---\n');
[netAddr, bcastAddr] = subnetAddresses('192.168.10.77', 26);
fprintf('Network address   : %s\n', netAddr);
fprintf('Broadcast address : %s\n', bcastAddr);

% ---------- local functions ----------
function [netAddr, bcastAddr] = subnetAddresses(ipStr, prefix)
% Returns the network and broadcast address of ipStr/prefix.
    ipNum = ip2num(ipStr);
    block = 2^(32 - prefix);
    netNum   = floor(ipNum / block) * block;
    bcastNum = netNum + block - 1;
    netAddr   = num2ip(netNum);
    bcastAddr = num2ip(bcastNum);
end

function n = ip2num(ipStr)
    o = sscanf(ipStr, '%d.%d.%d.%d')';
    n = o(1)*2^24 + o(2)*2^16 + o(3)*2^8 + o(4);
end

function s = num2ip(n)
    o = [floor(n/2^24), mod(floor(n/2^16),256), mod(floor(n/2^8),256), mod(n,256)];
    s = sprintf('%d.%d.%d.%d', o);
end
