function [ avg_angle ] = avg_angle( csi_data, d, lamda )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %phase_1_array = NaN(30,1);
    %phase_2_array = NaN(30,1);
    %phase_3_array = NaN(30,1);
    
    theta_1_array = NaN(30,1);
    theta_2_array = NaN(30,1);
    
    for j=1:30
        subcarrier_data = csi_data(:,:,j);
        phase1 = angle(subcarrier_data(1));
        phase2 = angle(subcarrier_data(2));
        phase3 = angle(subcarrier_data(3));
        
        aoa = get_aoa(phase1, phase2, phase3, d, lamda);
        theta_1_array(j) = aoa(1);
        theta_2_array(j) = aoa(2);
       % phase_1_sum = abs(phase1) + phase_1_sum;
       % phase_2_sum = abs(phase2) + phase_2_sum;
       % phase_3_sum = abs(phase3) + phase_3_sum;
    end
    %phase_1_avg = phase_1_sum/30;
    %phase_2_avg = phase_2_sum/30;
    %phase_3_avg = phase_3_sum/30;
    theta_1_avg = mean(theta_1_array);
    theta_2_avg = mean(theta_2_array);
    %phase_3_avg = mean(phase_3_array);
    avg_angle = [theta_1_avg, theta_2_avg];
end
