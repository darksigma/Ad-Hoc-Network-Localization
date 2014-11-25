csi_sliding = read_bf_file('csi-sliding.dat');
window = 40;
phase_array = NaN(30,3);
phase_1_array = NaN(length(csi_sliding'),1);
phase_2_array = NaN(length(csi_sliding'), 1);
phase_3_array = NaN(length(csi_sliding'), 1);
phase_diff31_array = NaN(length(csi_sliding'),1);
for i=1:length(csi_sliding')
    %csi_data = csi_sliding{i,1}.csi;
    if i < window
        phase_1_sum = 0;
        phase_2_sum = 0;
        phase_3_sum = 0;
        for j=1:i
            % Get average phase for each antenna, for now let's just go
            % with the first phase
            csi_data = csi_sliding{j+i,1}.csi;
            phases = avg_phase(csi_data);
            phase_1_sum = phase_1_sum + phases(1);
            phase_2_sum = phase_2_sum + phases(2);
            phase_3_sum = phase_3_sum + phases(3);
            %phase_1_sum = phase_1_sum + angle(csi_data(1));
            %phase_2_sum = phase_2_sum + angle(csi_data(2));
            %phase_3_sum = phase_3_sum + angle(csi_data(3));
        end
        phase_1_avg = phase_1_sum/i;
        phase_2_avg = phase_2_sum/i;
        phase_3_avg = phase_3_sum/i;
        phase_diff_31 = phase_3_avg - phase_1_avg;
        % Append the 3 phase averages to some list
        
    else
        phase_1_sum = 0;
        phase_2_sum = 0;
        phase_3_sum = 0;
        for j=0:window-1
            csi_data = csi_sliding{i-j,1}.csi;
            phases = avg_phase(csi_data);
            phase_1_sum = phase_1_sum + phases(1);
            phase_2_sum = phase_2_sum + phases(2);
            phase_3_sum = phase_3_sum + phases(3);
            %phase_1_sum = phase_1_sum + angle(csi_data(1));
            %phase_2_sum = phase_2_sum + angle(csi_data(2));
            %phase_3_sum = phase_3_sum + angle(csi_data(3));
        end
        phase_1_avg = phase_1_sum/window;
        phase_2_avg = phase_2_sum/window;
        phase_3_avg = phase_3_sum/window;
        % Again, append the three phase averages to some array
        phase_diff_31 = phase_3_avg - phase_1_avg;
    end
    phase_1_array(i) = phase_1_avg;
    phase_2_array(i) = phase_2_avg;
    phase_3_array(i) = phase_3_avg;
    phase_diff31_array(i) = phase_diff_31;
end
x = 1:1:length(csi_sliding');
y = phase_1_array;
plot(x, phase_diff31_array);
%plot(x, phase_2_array);
%plot(x, phase_3_array);