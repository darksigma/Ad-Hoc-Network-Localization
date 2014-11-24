function [ phase_diff ] = phase_diff_subcarrier( csi, subcarrier )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    temp = csi(:,:,subcarrier);
    signal_phase = angle(temp);
    phase1 = signal_phase(1);
    phase2 = signal_phase(2);
    phase3 = signal_phase(3);
    
    phase_diff21 = mod(phase2 - phase1, 2*pi());
    phase_diff32 = mod(phase3 - phase2, 2*pi());
    
    phase_diff = [phase_diff21, phase_diff32];

end

