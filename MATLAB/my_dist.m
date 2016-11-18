function d = my_dist( x, Z )
    s_x = size(x)
    s_Z = size(Z)
    d = sqrt(bsxfun(@plus,bsxfun(@minus, x, Z)) .^ 2);
end