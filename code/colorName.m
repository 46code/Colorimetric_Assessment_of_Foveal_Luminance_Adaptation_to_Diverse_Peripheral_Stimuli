function [name,code,order] = colorName(digit)
    if digit==1 || digit==2
        name='White';
        code='k';
    elseif  digit==3 || digit==4
        name='Red';
        code='r';
    elseif  digit==5 || digit==6
        name='Green';
        code='g';
    elseif  digit==7 || digit==8
        name='Blue';
        code='b';
    elseif  digit==9 || digit==10
        name='Yellow';
        code='y';
    elseif  digit==11 || digit==12
        name='Magenta';
        code='m';
    else
        name='Cyan';
        code='c';

    end

    if mod(digit,2)==0
        order='2nd';
    else
        order='1st';

    end
end