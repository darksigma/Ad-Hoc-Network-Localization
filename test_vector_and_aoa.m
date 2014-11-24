%% Test Vector Code
 freq=5825*10^6; %%
 c=3*10^8;
 lamda=c/freq;
% d=18/100; %% 18 cm
d=lamda/2;
 theta=45*pi/180;
 
 delta_phase=2*22/7*d*cos(theta)/lamda;
 
 d1=3;
 
 for ofdm_subcarrier=1:30
    phi_1=2*pi*d1/lamda;
    phi_2=2*pi*(d1+d*cos(theta))/lamda;
    phi_3=2*pi*(d1+2*d*cos(theta))/lamda;
     
    test1=cos(phi_1) + j*sin(phi_1);
    test2=cos(phi_2)+j*sin(phi_2);
    
    test_res=mod((angle(test2) - angle(test1)),2*pi);
    
    test=acos(test_res*lamda/(2*pi*d))*180/pi;
    
     x(1,ofdm_subcarrier)=cos(phi_1)+sqrt(-1)*sin(phi_1) + 0.1*(randn+sqrt(-1)*randn);
     x(2,ofdm_subcarrier)=cos(phi_2)+sqrt(-1)*sin(phi_2)+ 0.1*(randn+sqrt(-1)*randn);
     x(3,ofdm_subcarrier)=cos(phi_3)+sqrt(-1)*sin(phi_3)+ 0.1*(randn+sqrt(-1)*randn);
 end
 
 %% calculate angle

 
 
 
 
input_data = read_bf_file('csi_new_angle.dat');

res_final=0;
d=0.03;
res_1=0;
res_2=0;
for avg = 1:size(input_data,1)
     data=squeeze(input_data{avg}.csi);
 for ofdm_subcarrier=1:30
 
     delta_phase1=mod(angle(data(2,ofdm_subcarrier))-angle(data(1,ofdm_subcarrier)), 2*pi);
     phase_diffs(avg,ofdm_subcarrier) = delta_phase1;
     if (delta_phase1 > pi)
         delta_phase1=delta_phase1-2*pi; 
     end
     
     delta_phase2=mod(angle(data(3,ofdm_subcarrier))-angle(data(2,ofdm_subcarrier)),2*pi);
     if (delta_phase2 > pi)
         delta_phase2=delta_phase2-2*pi; 
     end
       
       
     theta_1 = acos(delta_phase1*lamda/(2*pi*d) )*180/pi;
     theta_2 = acos(delta_phase2*lamda/(2*pi*d) )*180/pi;
     
     res_1=res_1+theta_1;
     res_2=res_2+theta_2;
     

     
 end
 
   
 res_1 = res_1/30;
 final_res_1(1,avg)=res_1;

 res_2=res_2/30;
 final_res_2(1,avg) = res_2;
 res_final = res_final + res_1;
end

res_final = res_final / size(input_data,1)