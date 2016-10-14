function [ d ] = kolmogorov_dist( fname1, fname2, fname3, distance)
%KOLMOGOROV_DIST Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(fname1);
A = fread(fid, Inf, 'ubit1');
fclose(fid);
fid = fopen(fname2);
B = fread(fid, Inf, 'ubit1');
fclose(fid);
fid = fopen(fname3);
C = fread(fid, Inf, 'ubit1');
fclose(fid);

K_A = length(A);

K_B = length(B);
 
K_AB = length(C);

estK_AB = K_AB - K_B;
estK_BA = K_AB - K_A;

    if distance == 1
        %first distance, less accurate
        d = (estK_AB + estK_BA)/K_AconcB;
    elseif distance == 2
        %second distance, more accurate
        d = max (estK_AB, estK_BA)/max(K_A, K_B);
    else
        disp('distanza sbagliata scegli 1 o 2');
    end 
end


