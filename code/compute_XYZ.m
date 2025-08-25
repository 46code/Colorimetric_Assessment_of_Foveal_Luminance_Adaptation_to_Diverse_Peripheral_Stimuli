function XYZ = compute_XYZ(xy,Y)
    x=xy(1,1);
    y=xy(1,2);
    
    X = (x / y) * Y;
    Z = ((1 - x - y) / y) * Y;
    
    XYZ = [X, Y, Z];
end