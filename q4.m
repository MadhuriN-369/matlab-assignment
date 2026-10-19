%% Q4 - CRC Error Detection (modulo-2 division using XOR)
clear; clc;

% 1. Dataword and generator as 0/1 row vectors
dataword = [1 1 0 1 0 1 1 0 1 1];     % 1101011011
gen      = [1 0 0 1 1];               % 10011
r        = numel(gen) - 1;            % number of CRC bits

bs = @(v) sprintf('%d', v);           % helper: vector -> string

fprintf('Dataword  : %s\n', bs(dataword));
fprintf('Generator : %s\n', bs(gen));

% 2-3. Append r zeros and divide to get remainder
padded    = [dataword zeros(1, r)];
remainder = crcRemainder(padded, gen);
fprintf('Padded dataword (dataword + %d zeros) : %s\n', r, bs(padded));
fprintf('CRC remainder                         : %s\n', bs(remainder));

% 4. Transmitted codeword
codeword = [dataword remainder];
fprintf('Transmitted codeword                  : %s\n\n', bs(codeword));

% 5. Receiver check (no error)
rxRem = crcRemainder(codeword, gen);
fprintf('Receiver remainder (no error)         : %s\n', bs(rxRem));
if all(rxRem == 0)
    fprintf('Result: remainder is all zeros -> codeword accepted, no error detected.\n\n');
else
    fprintf('Result: non-zero remainder -> error detected.\n\n');
end

% 6. Flip the 5th bit from the left and re-check
corrupted = codeword;
corrupted(5) = 1 - corrupted(5);
rxRem2 = crcRemainder(corrupted, gen);
fprintf('Corrupted codeword (bit 5 flipped)    : %s\n', bs(corrupted));
fprintf('Receiver remainder (with error)       : %s\n', bs(rxRem2));
if any(rxRem2 ~= 0)
    fprintf('Result: non-zero remainder -> the error IS detected.\n');
else
    fprintf('Result: remainder is zero -> the error is NOT detected.\n');
end

% ---------- local function ----------
function rem = crcRemainder(bits, gen)
% Modulo-2 long division. Returns the last (numel(gen)-1) bits after division.
    g    = numel(gen);
    work = bits;
    for i = 1:(numel(bits) - g + 1)
        if work(i) == 1
            work(i:i+g-1) = xor(work(i:i+g-1), gen);   % XOR with aligned generator
        end                                            % leading bit 0 -> just move on
    end
    rem = double(work(end-g+2:end));
end
