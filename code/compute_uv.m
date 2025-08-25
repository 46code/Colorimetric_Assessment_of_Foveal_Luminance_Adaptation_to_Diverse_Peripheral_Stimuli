function uv = compute_uv(xyz)
    X = xyz(:,1);
    Y = xyz(:,2);
    Z = xyz(:,3);
    denom = X + 15*Y + 3*Z;
    u = 4 * X ./ denom;
    v = 9 * Y ./ denom;
    uv = [u, v];
end
