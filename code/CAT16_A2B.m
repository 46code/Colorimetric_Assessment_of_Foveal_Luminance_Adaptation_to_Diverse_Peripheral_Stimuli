function XYZ_t = CAT16_A2B(XYZ_s, XYZ_ws, XYZ_wt, D)
    
    % Define the matrix
    M16 = [0.401288, 0.650173, -0.051461;
           -0.250268, 1.204414, 0.045854;
           -0.002079, 0.048952, 0.953127];

    Minv16 = [1.86206786, -1.01125463, 0.14918677;
              0.38752654, 0.62144744, -0.00897398;
             -0.01584150, -0.03412294, 1.04996444];
    
    % Cone responses
    RGB_s = M16 * XYZ_s;
    RGB_ws = M16 * XYZ_ws;
    RGB_wt = M16 * XYZ_wt;
    
    % Diagonal matrix
    Y_ws = XYZ_ws(2); 
    Y_wt = XYZ_wt(2);
    ratios = (Y_ws / Y_wt) * (RGB_wt ./ RGB_ws);
    Lambda = diag(D * ratios + (1 - D));
    
    % Adapt and convert
    RGB_c = Lambda * RGB_s;
    XYZ_t = Minv16 * RGB_c;
    
end