clear;

%%% Start constants
log_data_wagon = read_bf_file_transmitter('csi-00216a02550e-experiment1.dat');
log_data_right_stool = read_bf_file_transmitter('csi-00216a6b3630-experiment1.dat');
log_data_left_stool = read_bf_file_transmitter('csi-00216a4838ca-experiment1.dat');

left_stool_dec = [0;33;106;72;56;202];
right_stool_dec = [0;33;106;107;54;48];
wagon_dec = [0;33;106;2;85;14];

d = .025;
freq=5825*10^6;
c=3*10^8;
lamda=c/freq;

sender_1 = wagon_dec;
sender_2 = left_stool_dec;
%%% End Constants

%%% Differentiate senders in log data
sender_1_csi = separate_senders(log_data_right_stool, sender_1);
sender_2_csi = separate_senders(log_data_right_stool, sender_2);

%%% Get average angle of arrival for different senders
sender1_aoa_arrays = aoa_array_all_signals(sender_1_csi, d, lamda);
sender2_aoa_arrays = aoa_array_all_signals(sender_2_csi, d, lamda);

%%% Isolate different aoa's from 
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
clf('reset');
hold on;
plot(x1, s1_aoa21_smooth, 'red');
plot(x1, s1_aoa32_smooth, 'blue');
figure(2);
clf('reset');
hold on;
plot(x2, s2_aoa21_smooth, 'red');
plot(x2, s2_aoa32_smooth, 'blue');