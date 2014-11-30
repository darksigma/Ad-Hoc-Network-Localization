%READ_BF_FILE Reads in a file of beamforming feedback logs.
%   This version uses the *C* version of read_bfee, compiled with
%   MATLAB's MEX utility.
%
% (c) 2008-2011 Daniel Halperin <dhalperi@cs.washington.edu>
%
function ret = read_bf_file(filename)
%% Input check
error(nargchk(1,1,nargin));

%% Open file
f = fopen(filename, 'rb');
if (f < 0)
    error('Couldn''t open file %s', filename);
    return;
end

status = fseek(f, 0, 'eof');
if status ~= 0
    [msg, errno] = ferror(f);
    error('Error %d seeking: %s', errno, msg);
    fclose(f);
    return;
end
len = ftell(f);

status = fseek(f, 0, 'bof');
if status ~= 0
    [msg, errno] = ferror(f);
    error('Error %d seeking: %s', errno, msg);
    fclose(f);
    return;
end

%% Initialize variables
ret = cell(ceil(len/95),2);     % Holds the return values - 1x1 CSI is 95 bytes big, so this should be upper bound
cur = 0;                        % Current offset into file
count = 0;                      % Number of records output
addr1 = '';                     % Address 1 recorded from most recent frame header
addr2 = '';                     % Address 2 recorded from most recent frame header
addr3 = '';                     % Address 3 recorded from most recent frame header
broken_perm = 0;                % Flag marking whether we've encountered a broken CSI yet
triangle = [1 3 6];             % What perm should sum to for 1,2,3 antennas

%% Process all entries in file
% Need 3 bytes -- 2 byte size field and 1 byte code
while cur < (len - 3)
    % Read size and code
    field_len = fread(f, 1, 'uint16', 0, 'ieee-be');
    code = fread(f,1);
    cur = cur+3;

    if (code == hex2dec('c1')) % Frame header -- record addresses
        fseek(f, 4, 'cof');
        addr1 = fread(f, 6, 'uint8');
        addr2 = fread(f, 6, 'uint8');
        addr3 = fread(f, 6, 'uint8');
        fseek(f, field_len - 23, 'cof');
    elseif (code == hex2dec('bb')) % Beamforming matrix -- output a record
        bytes = fread(f, field_len-1, 'uint8=>uint8');
        if (length(bytes) ~= field_len-1)
            fclose(f);
            return;
        end

        count = count + 1;
        ret{count} = read_bfee(bytes);
        
        perm = ret{count}.perm;
        Nrx = ret{count}.Nrx;
        if sum(perm) ~= triangle(Nrx) % matrix does not contain default values
            if broken_perm == 0
                broken_perm = 1;
                fprintf('WARN ONCE: Found CSI (%s) with Nrx=%d and invalid perm=[%s]\n', filename, Nrx, int2str(perm));
            end
        elseif Nrx ~= 1 % permuting only needed for multiple antennas
            ret{count}.csi(:,perm(1:Nrx),:) = ret{count}.csi(:,1:Nrx,:);
        end
        if length(addr1)
            ret{count}.addr1 = addr1;
            addr1 = '';
        end
        if length(addr2)
            ret{count}.addr2 = addr2;
            addr2 = '';
        end
        if length(addr3)
            ret{count}.addr3 = addr3;
            addr3 = '';
        end
    else % skip entry
        fseek(f, field_len - 1, 'cof');
    end

    cur = cur + field_len - 1;
end
ret = ret(1:count);

%% Close file
fclose(f);
end
