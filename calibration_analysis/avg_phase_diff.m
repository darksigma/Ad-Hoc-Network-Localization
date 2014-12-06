function [ avg_phase_diff ] = avg_phase_diff(csi_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    phase_diff_array = NaN(30,1);
    
    for j=1:30
        subcarrier_data = csi_data(:,:,j);
        phase1 = angle(subcarrier_data(1));
        phase2 = angle(subcarrier_data(2));
        phase_diff = mod((phase2-phase1 + pi), 2*pi) - pi;
        phase_diff_array(j) = phase_diff;
    end
    avg_phase_diff = mean(phase_diff_array);
end