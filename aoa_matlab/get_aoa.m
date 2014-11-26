function [ aoa ] = get_aoa( phase1, phase2, phase3, d, lamda)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
  
    delta_phase1=mod(phase2-phase1, 2*pi);
    %phase_diffs(avg,ofdm_subcarrier) = delta_phase1;
    if (delta_phase1 > pi)
        delta_phase1=delta_phase1-2*pi; 
    end
    
    delta_phase2=mod(phase3-phase2,2*pi);
    if (delta_phase2 > pi)
        delta_phase2=delta_phase2-2*pi; 
    end
    
    theta_1 = acos(delta_phase1*lamda/(2*pi*d) )*180/pi;
    theta_2 = acos(delta_phase2*lamda/(2*pi*d) )*180/pi;
    
    aoa = [theta_1, theta_2];


end

