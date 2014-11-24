function [ phase_diff ] = get_phase_diffs( csi_data )
% Get the phase diffs between different each pair
% of antennas

range = (1:1:30);
phase_diff = NaN(30, 2);
for i=range
    temp = csi_data(:,:,i);
    
    % phases of three antennas
    signal_phase = angle(temp);
    phase1 = signal_phase(1);
    phase2 = signal_phase(2);
    phase3 = signal_phase(3);
    
    phase_diff21 = mod(phase2 - phase1, 2*pi());
    phase_diff32 = mod(phase3 - phase2, 2*pi());
    
    phase_diff_array = [phase_diff21, phase_diff32];
    
    phase_diff(i, :) = phase_diff_array;
    
end

