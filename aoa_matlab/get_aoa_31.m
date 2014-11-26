function [ aoa ] = get_aoa_31( phase1, phase3, d, lamda)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
  
    delta_phase=mod(phase3-phase1, 2*pi);
    %phase_diffs(avg,ofdm_subcarrier) = delta_phase1;
    if (delta_phase > pi)
        delta_phase=delta_phase-2*pi; 
    end
    
    theta_1 = acos(delta_phase*lamda/(2*pi*d) )*180/pi;
    
    aoa = theta_1;


end

