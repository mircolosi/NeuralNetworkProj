function [ k ] = k_dist( p1, p2, x, y )
%K_DIST Summary of this function goes here
%   Detailed explanation goes here
    fid1 = fopen(p1);
    fid2 = fopen(p2);
    
    x1 = fread(fid1, Inf, '*char'); %cambiare nomi
    y1 = fread(fid2, Inf, '*char'); %cambiare nomi
    
    fclose(fid1);
    fclose(fid2);
    xy = vertcat(x1,y1);
    yx = vertcat(y1,x1);
    
    K_x = x;
    K_y = y;
    K_xy = length(xy);
    K_yx = length(yx);
    
    k = (K_xy-K_y+K_yx-K_x)/K_xy;
    
end

