experiment = 1;
address1 = hex2dec(['00'; '21'; '6A'; '48'; '38'; 'CA']);
address2 = hex2dec(['00'; '21'; '6A'; '6B'; '36'; '30']);
address3 = hex2dec(['00'; '21'; '6A'; '02'; '55'; '0E']);

addpath('~/linux-80211n-csitool-supplementary/matlab/');

bf1 = read_bf_file(sprintf("~/csi-%02x:%02x:%02x:%02x:%02x:%02x-experiment%u.dat", address1, experiment));
bf2 = read_bf_file(sprintf("~/csi-%02x:%02x:%02x:%02x:%02x:%02x-experiment%u.dat", address2, experiment));
bf3 = read_bf_file(sprintf("~/csi-%02x:%02x:%02x:%02x:%02x:%02x-experiment%u.dat", address3, experiment));

timestamps1to2 = [];
timestamps1to3 = [];
timestamps2to3 = [];
timestamps2to1 = [];
timestamps3to1 = [];
timestamps3to2 = [];
csi1to2 = [];
csi1to3 = [];
csi2to3 = [];
csi2to1 = [];
csi3to1 = [];
csi3to2 = [];
for i = 1:size(bf1)(1)
    if bf1{i,1}.addr2 == address2
        timestamps1to2 = [timestamps1to2; bf1{i,1}.timestamp_low];
        csi1to2 = [csi1to2; bf1{i,1}.csi(:,:,:)];
    elseif bf1{i,1}.addr2 == address3
        timestamps1to3 = [timestamps1to3; bf1{i,1}.timestamp_low];
        csi1to3 = [csi1to3; bf1{i,1}.csi(:,:,:)];
    end
end
for i = 1:size(bf2)(1)
    if bf2{i,1}.addr2 == address3
        timestamps2to3 = [timestamps2to3; bf2{i,1}.timestamp_low];
        csi2to3 = [csi2to3; bf2{i,1}.csi(:,:,:)];
    elseif bf2{i,1}.addr2 == address1
        timestamps2to1 = [timestamps2to1; bf2{i,1}.timestamp_low];
        csi2to1 = [csi2to1; bf2{i,1}.csi(:,:,:)];
    end
end
for i = 1:size(bf3)(1)
    if bf3{i,1}.addr2 == address1
        timestamps3to1 = [timestamps3to1; bf3{i,1}.timestamp_low];
        csi3to1 = [csi3to1; bf3{i,1}.csi(:,:,:)];
    elseif bf3{i,1}.addr2 == address2
        timestamps3to2 = [timestamps3to2; bf3{i,1}.timestamp_low];
        csi3to2 = [csi3to2; bf3{i,1}.csi(:,:,:)];
    end
end

phases1to2 = angle(csi1to2);
phases1to3 = angle(csi1to3);
phases2to3 = angle(csi2to3);
phases2to1 = angle(csi2to1);
phases3to1 = angle(csi3to1);
phases3to2 = angle(csi3to2);

offsets1to2 = [mod(phases1to2(:,2,:) - phases1to2(:,1,:) + pi, 2*pi) - pi, ...
               mod(phases1to2(:,3,:) - phases1to2(:,2,:) + pi, 2*pi) - pi, ...
               mod(phases1to2(:,1,:) - phases1to2(:,3,:) + pi, 2*pi) - pi];
offsets1to3 = [mod(phases1to3(:,2,:) - phases1to3(:,1,:) + pi, 2*pi) - pi, ...
               mod(phases1to3(:,3,:) - phases1to3(:,2,:) + pi, 2*pi) - pi, ...
               mod(phases1to3(:,1,:) - phases1to3(:,3,:) + pi, 2*pi) - pi];
offsets2to3 = [mod(phases2to3(:,2,:) - phases2to3(:,1,:) + pi, 2*pi) - pi, ...
               mod(phases2to3(:,3,:) - phases2to3(:,2,:) + pi, 2*pi) - pi, ...
               mod(phases2to3(:,1,:) - phases2to3(:,3,:) + pi, 2*pi) - pi];
offsets2to1 = [mod(phases2to1(:,2,:) - phases2to1(:,1,:) + pi, 2*pi) - pi, ...
               mod(phases2to1(:,3,:) - phases2to1(:,2,:) + pi, 2*pi) - pi, ...
               mod(phases2to1(:,1,:) - phases2to1(:,3,:) + pi, 2*pi) - pi];
offsets3to1 = [mod(phases3to1(:,2,:) - phases3to1(:,1,:) + pi, 2*pi) - pi, ...
               mod(phases3to1(:,3,:) - phases3to1(:,2,:) + pi, 2*pi) - pi, ...
               mod(phases3to1(:,1,:) - phases3to1(:,3,:) + pi, 2*pi) - pi];
offsets3to2 = [mod(phases3to2(:,2,:) - phases3to2(:,1,:) + pi, 2*pi) - pi, ...
               mod(phases3to2(:,3,:) - phases3to2(:,2,:) + pi, 2*pi) - pi, ...
               mod(phases3to2(:,1,:) - phases3to2(:,3,:) + pi, 2*pi) - pi];

figure("name", sprintf("%02x:%02x:%02x:%02x:%02x:%02x to %02x:%02x:%02x:%02x:%02x:%02x", address1, address2));
plot(timestamps1to2, offsets1to2(:,:,1), '+');
hold

figure("name", sprintf("%02x:%02x:%02x:%02x:%02x:%02x to %02x:%02x:%02x:%02x:%02x:%02x", address1, address3));
plot(timestamps1to3, offsets1to3(:,:,1), '+');
hold

figure("name", sprintf("%02x:%02x:%02x:%02x:%02x:%02x to %02x:%02x:%02x:%02x:%02x:%02x", address2, address3));
plot(timestamps2to3, offsets2to3(:,:,1), '+');
hold

figure("name", sprintf("%02x:%02x:%02x:%02x:%02x:%02x to %02x:%02x:%02x:%02x:%02x:%02x", address2, address1));
plot(timestamps2to1, offsets2to1(:,:,1), '+');
hold

figure("name", sprintf("%02x:%02x:%02x:%02x:%02x:%02x to %02x:%02x:%02x:%02x:%02x:%02x", address3, address1));
plot(timestamps3to1, offsets3to1(:,:,1), '+');
hold

figure("name", sprintf("%02x:%02x:%02x:%02x:%02x:%02x to %02x:%02x:%02x:%02x:%02x:%02x", address3, address2));
plot(timestamps3to2, offsets3to2(:,:,1), '+');
hold

pause
