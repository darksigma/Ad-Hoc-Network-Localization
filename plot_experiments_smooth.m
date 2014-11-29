log_data = read_bf_file_transmitter('csi-00216a4838ca-experiment1.dat');

sender_1 = [0;33;106;107;54;48];
sender_2 = [0;33;106;2;85;14];

sender_1_csi = separate_senders(log_data, sender_1);
sender_2_csi = separate_senders(log_data, sender_2);

sender1_aoa_arrays = aoa_array_all_signals(sender_1_csi, .019);
sender2_aoa_arrays = aoa_array_all_signals(sender_2_csi, .019);

s1_aoa21 = sender1_aoa_arrays(:,1);
s1_aoa32 = sender1_aoa_arrays(:,2);

s2_aoa21 = sender2_aoa_arrays(:,1);
s2_aoa32 = sender2_aoa_arrays(:,2);

s1_aoa21_smooth = smooth(s1_aoa21, 'rlowess');
s1_aoa32_smooth = smooth(s1_aoa32, 'rlowess');

s2_aoa21_smooth = smooth(s2_aoa21, 'rlowess');
s2_aoa32_smooth = smooth(s2_aoa32, 'rlowess');

x1 = 1:1:length(s1_aoa21');
x2 = 1:1:length(s2_aoa32');
figure(1);
hold on;
plot(x1, s1_aoa21_smooth, 'red');
plot(x1, s1_aoa32_smooth, 'blue');
figure(2);
hold on;
plot(x2, s2_aoa21_smooth, 'red');
plot(x2, s2_aoa32_smooth, 'blue');