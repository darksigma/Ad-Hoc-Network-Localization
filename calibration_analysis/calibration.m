angles = [45, 50, 55, 60, 75, 90, 105, 120, 125, 130, 135];
%expected_values = [2.223, 1.57, 0.813, 0, 5.47, 4.71, 4.068];
phase_a = NaN(size(angles,2),1);
phase_b = NaN(size(angles,2),1);
for i=1:1:size(angles,2)
    experiment = angles(i);
    ab_a = read_bf_file(sprintf('../calibration_bc/%udegrees_bc_b.dat', experiment));
    ab_b = read_bf_file(sprintf('../calibration_bc/%udegrees_bc_c.dat', experiment));
    csi_ab_a_array = NaN(size(ab_a, 2),1);
    csi_ab_b_array = NaN(size(ab_b, 2),1);
    for j=1:1:size(ab_a, 2)
        csi_ab_a_array(j) = avg_phase_diff(ab_a{1,j}.csi);
    end
    for j=1:1:size(ab_b, 2)
        csi_ab_b_array(j) = avg_phase_diff(ab_b{1,j}.csi);
    end
%     figure('name', sprintf('%d degrees b', experiment));
%     plot(csi_ab_a_array, 'r+');
%     print('-dpng', sprintf('figures_bc/%d_deg_b.png', experiment));
%     figure('name', sprintf('%d degrees c', experiment));
%     plot(csi_ab_b_array, 'b*');
%     print('-dpng', sprintf('figures_bc/%d_deg_c.png', experiment));
    phase_a(i) = mean(csi_ab_a_array);
    phase_b(i) = mean(csi_ab_b_array);
end
phase_a_smooth = smooth(phase_a, 'rlowess');
phase_b_smooth = smooth(phase_b, 'rlowess');
% phase_a_smooth = phase_a;
% phase_b_smooth = phase_b;
clf;
hold;
% sfa = 1.75;
% sfb = -1.75;
% offset_a = 3;
% offset_b = 1.8;
sfa = 1;
sfb = -1;
offset_a = 0;
offset_b = 1.5;
expected_values = test_vector(angles);
modded_values_a = mod(sfa * phase_a_smooth + offset_a + pi, 2*pi) - pi;
modded_values_b = mod(sfb * phase_b_smooth + offset_b + pi, 2*pi) - pi;
modded_expected = mod(expected_values + pi, 2*pi) - pi;
plot(angles, modded_values_a, 'b+');
plot(angles, modded_values_b, 'r+');
original_angles = [45, 60, 75, 90, 105, 120, 135];
plot(angles, modded_expected, 'g*');