function XYZ = spd2XYZE(spd,cmf)

k=683;

XYZ = k * (spd * cmf);

%XYZ = (XYZ ./ max(XYZ(:,2)))*100;

end
