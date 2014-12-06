function [ theta_array ] = aoa_array_all_signals( csi_all_signals, d, lamda )
%UNTITLED24 Summary of this function goes here
%   Detailed explanation goes here

    
    
    csi_size = size(csi_all_signals);
    
    %phase_1_array = NaN(csi_size(4), 1);
    %phase_2_array = NaN(csi_size(4), 1);
    %phase_3_array = NaN(csi_size(4), 1);
    
    theta_array = NaN(csi_size(4), 2);
    for i=1:1:csi_size(4)
        csi_data = csi_all_signals(:,:,:,i);
        theta_array(i,:) = avg_angle(csi_data, d, lamda);
        %phase_1_array(i) = phases(1);
        %phase_2_array(i) = phases(2);
        %phase_3_array(i) = phases(3);
        %theta_array(i,:) = get_aoa(phases(1), phases(2), phases(3), d, lamda);
    end

