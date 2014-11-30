clear;
%%% Script to Analyze Outdoor Calibration Data - Anubhav Jain
%% Constants
% Distance between antennas - 0.75 inches = 1.9 cm
d = 0.038;

% Carrier Frequency 5.825 GHz
freq = 5825 * 10^6;

% Speed of Light
c = 3 * 10^8;
 
% Wavelength
lamda = c / freq;

%% Read in the Data File for Experiment 1.
% Left Stool: 00:21:6a:48:38:ca
left_stool = read_bf_file('experiment1/csi-00216a4838ca-experiment1.dat');
% Right Stool: 00:21:6a:6b:36:30
right_stool = read_bf_file('experiment1/csi-00216a6b3630-experiment1.dat');
% Wagon : 00:21:6a:02:55:0e
wagon = read_bf_file('experiment1/csi-00216a02550e-experiment1.dat');

left_stool_mac = ['00';'21'; '6A'; '48'; '38'; 'CA'];
right_stool_mac = ['00';'21'; '6A'; '6B'; '36'; '30'];
wagon_mac = ['00';'21'; '6A'; '02'; '55'; '0E'];

%% Get the separated csi_data for each sender
csi_data_from_right_stool = separate_senders(left_stool, hex2dec(right_stool_mac));
csi_data_from_wagon = separate_senders(right_stool, hex2dec(wagon_mac));
input_data = csi_data_from_wagon;
res_final=0;
res_1=0;
res_2=0;
for avg = 1:length(input_data)
     data=squeeze(input_data(avg).csi);
     timestamps(avg) = input_data(avg).timestamp_low;
 for ofdm_subcarrier=1:30
 
     delta_phase1=mod(angle(data(2,ofdm_subcarrier))-angle(data(1,ofdm_subcarrier)), 2*pi);
     phase_diffs(avg,ofdm_subcarrier) = delta_phase1;
     if (delta_phase1 > pi)
         delta_phase1=delta_phase1-2*pi; 
     end
     
     delta_phase2=mod(angle(data(3,ofdm_subcarrier))-angle(data(2,ofdm_subcarrier)),2*pi);
     if (delta_phase2 > pi)
         delta_phase2=delta_phase2-2*pi; 
     end
       
       
     theta_1 = acos(delta_phase1*lamda/(2*pi*d) )*180/pi;
     theta_2 = acos(delta_phase2*lamda/(2*pi*d) )*180/pi;
     
     res_1=res_1+theta_1;
     res_2=res_2+theta_2;
     

     
 end
 
   
     res_1 = res_1/30;
     final_res_1(1,avg)=res_1;

     res_2=res_2/30;
     final_res_2(1,avg) = res_2;
     res_final = res_final + res_1;
end

res_final = res_final / size(input_data,2)