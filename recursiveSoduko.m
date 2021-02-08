function ret = recursiveSoduko(x,y)
    global soduko;
    ret = 0;
    if y == 7
        ret = 1;
    elseif soduko(x,y) ~= 0
        newx = x+1;
        newy = y;
        if newx == 7
            newx = 1;
            newy = y+1;
        end
        ret = recursiveSoduko(newx,newy);
    else
        for i = 1:6
            soduko(x,y) = i;
            if isValidSoduko(soduko)
                newx = x+1;
                newy = y;
                if newx == 7
                    newx = 1;
                    newy = y+1;
                end
                if recursiveSoduko(newx,newy)
                    ret = 1;
                    break;
                end
            end
        end
        if ret == 0
            soduko(x,y) = 0;
        end
    end
end

