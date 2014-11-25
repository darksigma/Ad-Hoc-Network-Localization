clear;
angles = [-1 15 65 105 105; 90 -1 0 40 20; 135 180 -1 86 45; 0 40 90 -1 180; 0 20 45 0 -1];
s = size(angles);
s = s(1);
b = zeros(6 * nchoosek(s,3), 1);
A = zeros(6* nchoosek(s,3), 2* nchoosek(s,2));
beq = zeros(nchoosek(s,3), 1);
Aeq = zeros(nchoosek(s,3), 2* nchoosek(s,2));
H = eye(2 * nchoosek(s,2));
f = zeros(2* nchoosek(s,2), 1);
c = containers.Map;
counter  = 1;
for i = 1:s
    for j = 1:s
        if i ~= j
            c(mat2str([i j])) = counter;
            counter = counter + 1;
        end
    end
end

counter = 1;
for i = 1:s
    for j = (i+1):s
        for k = (j+1):s
            beq(counter) = 180;
            
            angle_ij = angles(i, j);
            angle_ik = angles(i, k);
            
            A(6*counter-5, c(mat2str([i j]))) = 1;
            b(6*counter-5) = angle_ij;
            A(6*counter-4, c(mat2str([i k]))) = 1;
            b(6*counter-4) = angle_ik;
            
            if angle_ij > angle_ik
                if angle_ij - angle_ik > 180
                    Aeq(counter, c(mat2str([i j]))) = 1;
                    Aeq(counter, c(mat2str([i k]))) = -1;
                    beq(counter) = beq(counter) - 360 + angle_ij - angle_ik;
                else
                    Aeq(counter, c(mat2str([i j]))) = -1;
                    Aeq(counter, c(mat2str([i k]))) = 1;
                    beq(counter) = beq(counter) - angle_ij + angle_ik;
                end
            else
                if angle_ik - angle_ij > 180
                    Aeq(counter, c(mat2str([i j]))) = -1;
                    Aeq(counter, c(mat2str([i k]))) = 1;
                    beq(counter) = beq(counter) - 360 - angle_ij + angle_ik;
                else
                    Aeq(counter, c(mat2str([i j]))) = 1;
                    Aeq(counter, c(mat2str([i k]))) = -1;
                    beq(counter) = beq(counter) + angle_ij - angle_ik;
                end
            end
            
            angle_ji = angles(j, i);
            angle_jk = angles(j, k);
            
            A(6*counter-3, c(mat2str([j i]))) = 1;
            b(6*counter-3) = angle_ji;
            A(6*counter-2, c(mat2str([j k]))) = 1;
            b(6*counter-2) = angle_jk;
            
            if angle_ji > angle_jk
                if angle_ji - angle_jk > 180
                    Aeq(counter, c(mat2str([j i]))) = 1;
                    Aeq(counter, c(mat2str([j k]))) = -1;
                    beq(counter) = beq(counter) - 360 + angle_ji - angle_jk;
                else
                    Aeq(counter, c(mat2str([j i]))) = -1;
                    Aeq(counter, c(mat2str([j k]))) = 1;
                    beq(counter) = beq(counter) - angle_ji + angle_jk;
                end
            else
                if angle_jk - angle_ji > 180
                    Aeq(counter, c(mat2str([j i]))) = -1;
                    Aeq(counter, c(mat2str([j k]))) = 1;
                    beq(counter) = beq(counter) - 360 - angle_ji + angle_jk;
                else
                    Aeq(counter, c(mat2str([j i]))) = 1;
                    Aeq(counter, c(mat2str([j k]))) = -1;
                    beq(counter) = beq(counter) + angle_ji - angle_jk;
                end
            end
            
            angle_ki = angles(k, i);
            angle_kj = angles(k, j);
            
            A(6*counter-1, c(mat2str([k i]))) = 1;
            b(6*counter-1) = angle_ki;
            A(6*counter, c(mat2str([k j]))) = 1;
            b(6*counter) = angle_kj;
            
            if angle_ki > angle_kj
                if angle_ki - angle_kj > 180
                    Aeq(counter, c(mat2str([k i]))) = 1;
                    Aeq(counter, c(mat2str([k j]))) = -1;
                    beq(counter) = beq(counter) - 360 + angle_ki - angle_kj;
                else
                    Aeq(counter, c(mat2str([k i]))) = -1;
                    Aeq(counter, c(mat2str([k j]))) = 1;
                    beq(counter) = beq(counter) - angle_ki + angle_kj;
                end
            else
                if angle_kj - angle_ki > 180
                    Aeq(counter, c(mat2str([k i]))) = -1;
                    Aeq(counter, c(mat2str([k j]))) = 1;
                    beq(counter) = beq(counter) - 360 - angle_ki + angle_kj;
                else
                    Aeq(counter, c(mat2str([k i]))) = 1;
                    Aeq(counter, c(mat2str([k j]))) = -1;
                    beq(counter) = beq(counter) + angle_ki - angle_kj;
                end
            end
            
            counter = counter + 1;
        end
    end        
end

qp_errors = quadprog(H,f,A,b,Aeq,beq);

x0 = zeros(2* nchoosek(s,2), 1);

sparsity_errors = fmincon(@force_sparsity,x0,A,b,Aeq,beq);

corrected_angles = angles;

for i = 1:s
    for j = 1:s
        if i~=j
            corrected_angles(i,j) = corrected_angles(i,j) - sparsity_errors(c(mat2str([i j])));
        end
    end
end

x = zeros(1,s);
y = zeros(1,s);

x(2) = cosd(corrected_angles(1, 2));
y(2) = sind(corrected_angles(1, 2));

for i=3:s
    vec = [cosd(corrected_angles(1, i)) sind(corrected_angles(1, i))];
    
    theta1 = abs(corrected_angles(1, 2)- corrected_angles(1, i));
    if theta1 > 180
        theta1 =  360 - theta1;
    end
    
    theta2 = abs(corrected_angles(2, 1)- corrected_angles(2, i));
    if theta2 > 180
        theta2 =  360 - theta2;
    end
    
    mag = sind(theta2)/sind(180-theta1-theta2);
    vec = mag * vec;
    x(i) = vec(1);
    y(i) = vec(2);
end

dists = [0 2 2.8 2 6; 2 0 2 3 4.47; 2.8 2 0 2 3; 2 2.8 2 0 2; 4 5 2.8 2 0];
Aeq = zeros(2*nchoosek(s,2), 2* nchoosek(s,2) + 1);
beq = zeros(2*nchoosek(s,2), 1);
H = eye(2 * nchoosek(s,2) + 1);
H(2 * nchoosek(s,2) + 1, 2 * nchoosek(s,2) + 1) = 0;
f = zeros(2* nchoosek(s,2) + 1, 1);
counter  = 1;
for i = 1:s
    for j = 1:s
        if i ~=j
            %dists(i, j)^2 - e_ij = ((x_i - x_j)^2 + (y_i - y_j)^2) * k
            Aeq(counter, c(mat2str([i j]))) = 1;
            Aeq(counter, 2 * nchoosek(s,2) + 1) = (x(i) - x(j))^2 + (y(i) - y(j))^2;
            beq(counter) = dists(i, j)^2;
            counter = counter + 1;
        end
    end
end

f = zeros(2* nchoosek(s,2) + 1, 1);
dist_errors = quadprog(H,f,[],[],Aeq,beq);
scaling = sqrt(dist_errors(2 * nchoosek(s,2) + 1));

x =  scaling * x;
y =  scaling * y;

c = zeros(s, 3);
c(1,1) = 1;

figure
scatter([0 0 0 2 2], [0 2 4 0 2], 50, [0 0 0], 'filled')
axis([-0.2, 4.2, -0.2, 4.2])
pbaspect([1 1 1])

figure
scatter(x, y, 50, c, 'filled')
axis([-1.1 * max(max(abs(x)), max(abs(y))), 1.1 * max(max(abs(x)), max(abs(y))), -1.1 * max(max(abs(x)), max(abs(y))), 1.1 * max(max(abs(x)), max(abs(y)))])
pbaspect([1 1 1])