%csi_sliding = csi_sliding;
freq=5825*10^6; %%
c=3*10^8;
lamda=c/freq;
theta_1_array = NaN(length(csi_sliding'),1);
theta_2_array = NaN(length(csi_sliding'), 1);
phase_diff31_array = NaN(length(csi_sliding'),1);
window = 80;
for i=1:length(csi_sliding')
    csi_data = csi_sliding{i,1}.csi;
    phases = avg_phase(csi_data);
    phase1 = phases(1);
    phase2 = phases(2);
    phase3 = phases(3);
    theta_array = get_aoa(phase1, phase2, phase3, d, lamda);
    theta_1_array(i) = theta_array(1);
    theta_2_array(i) = theta_array(2);
end
%theta_1_array_smooth = smooth(theta_1_array, 'rloess');
x = 1:1:length(csi_sliding');
hold on
plot(x, theta_1_array);
plot(x, theta_2_array);
%plot(x, phase_2_array);
%plot(x, phase_3_array);