function valid = isValidSoduko( soduko )
    soduko = soduko';
    valid = 1;
    [X Y] = size(soduko);
    for x = 1:X
        for y = 1:Y
            if soduko(x,y) ~=0
                if sum(soduko(x,:)==soduko(x,y)) > 1
                    valid = 0;
                    break;
                elseif sum(soduko(:,y)==soduko(x,y)) > 1
                    valid = 0;
                    break;
                elseif sum(sum(soduko(floor((x-1)/3)*3+1:(floor((x-1)/3)+1)*3,floor((y-1)/2)*2+1:(floor((y-1)/2)+1)*2)==soduko(x,y))) > 1
                    valid = 0;
                    break;
                end
            end
        end
    end
end
