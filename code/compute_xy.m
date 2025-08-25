function xy = compute_xy(XYZ)
    x=XYZ(:,1)./sum(XYZ,2);
    y=XYZ(:,2)./sum(XYZ,2);
    xy=[x,y];
end