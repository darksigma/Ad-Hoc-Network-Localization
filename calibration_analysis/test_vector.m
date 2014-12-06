%% Test Vector Code
function [ delta_phase ] = test_vector(aoa)
freq=5825*10^6; %%
c=3*10^8;
lamda=c/freq;
d=lamda/2;
theta=aoa*pi/180;
 
delta_phase=2*22/7*d*cos(theta)/lamda;
delta_phase = mod(delta_phase, 2*pi);