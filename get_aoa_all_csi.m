function [ theta_array ] = get_aoa_all_csi(all_signal_csi)
%UNTITLED22 Summary of this function goes here
%   Detailed explanation goes here

    window = 80;
    freq=5825*10^6; %%
    c=3*10^8;
    lamda=c/freq;
    d =.019;

    %phase_array = NaN(30,3);
    phase_1_array = NaN(length(all_signal_csi),1); 
    phase_2_array = NaN(length(all_signal_csi), 1);
    phase_3_array = NaN(length(all_signal_csi), 1);
    phase_diff31_array = NaN(length(all_signal_csi),1);
    for i=1:length(all_signal_csi)
        if i < window
            phase_1_sum = 0;
            phase_2_sum = 0;
            phase_3_sum = 0;
            for j=1:i
                csi_data = all_signal_csi{j+i,1}.csi;
                phases = avg_phase(csi_data);
                phase_1_sum = phase_1_sum + phases(1);
                phase_2_sum = phase_2_sum + phases(2);
                phase_3_sum = phase_3_sum + phases(3);
            end
            phase_1_avg = phase_1_sum/i;
            phase_2_avg = phase_2_sum/i;
            phase_3_avg = phase_3_sum/i;
            phase_diff_31 = phase_3_avg - phase_1_avg;
        
        else
            phase_1_sum = 0;
            phase_2_sum = 0;
            phase_3_sum = 0;
            for j=0:window-1
                csi_data = all_signal_csi{i-j,1}.csi;
                phases = avg_phase(csi_data);
                phase_1_sum = phase_1_sum + phases(1);
                phase_2_sum = phase_2_sum + phases(2);
                phase_3_sum = phase_3_sum + phases(3);
            end
            phase_1_avg = phase_1_sum/window;
            phase_2_avg = phase_2_sum/window;
            phase_3_avg = phase_3_sum/window;
            phase_diff_31 = phase_3_avg - phase_1_avg;
        end
        phase_1_array(i) = phase_1_avg;
        phase_2_array(i) = phase_2_avg;
        phase_3_array(i) = phase_3_avg;
        phase_diff31_array(i) = phase_diff_31;
    end
    theta_array = NaN(length(csi_sliding'), 1);
    for z=1:length(csi_sliding')
        phase1 = phase_1_array(z);
        phase2 = phase_2_array(z);
        phase3 = phase_3_array(z);
        aoa = get_aoa_31(phase1,phase3, d, lamda);
        theta_array(z) = aoa;
    end
end

