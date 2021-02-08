im = imread('sudo.jpg');
[X, Y, P] = size(im);
gim = rgb2gray(im);
n = 6*6;
segments = cell(1,n);
empty = im(:,:,1)*0;


%Start end end of each row
lines = [];
for i = 1:X
    if(mean(gim(i,:))) < 30
        lines = [lines i];
    end
end
stendy = zeros(6,2);
stendy(1,1) = 1;
i = 1;
for j = 2:length(lines)-1
    if lines(j+1) - lines(j) > 30
        stendy(i,1) = lines(j);
        if i < 7
            stendy(i,2) = lines(j+1);
        end
        i = i+1;
    end
end

%Start end end of each column
cols = [];
for i = 1:Y
    if(mean(gim(:,i))) < 30
        cols = [cols i];
    end
end
stendx = zeros(6,2);
stendx(1,1) = 1;
i = 1;
for j = 2:length(cols)-1
    if cols(j+1) - cols(j) > 30
        stendx(i,1) = cols(j);
        if i < 7
            stendx(i,2) = cols(j+1);
        end
        i = i+1;
    end
end

%Feature extraction
n = 36;
classes = zeros(n,4);
for x=1:6
    for y = 1:6
        s = im(stendy(y,1):stendy(y,2),stendx(x,1):stendx(x,2),:);
        [a b c] = size(s);
        [A B] = meshgrid(1:b, 1:a);
        classes((x-1)*6+(y-1)+1,:) = [sum(sum(s(:,:,1))) sum(sum(s(:,:,2))) sum(sum(s(:,:,3))) sum(sum(sum(s(floor(end/3):floor(end*2/3),floor(end/3):floor(end*2/3),:))))];
    end
end
idx = kmeans(classes,7, 'Replicates', 10);
idx = reshape(idx,6,6);

%Figure out wich class is white
maxhist = 0;
maxclass = 0;
for j = 1:7
    hist = mean(classes(idx == j, 4));
    if hist>maxhist
        maxhist = hist;
        maxclass = j;
    end
    ot = im;
    for x = 1:6
        for y = 1:6
            if idx(x,y) ~= j
                ot(stendx(x,1):stendx(x,2),stendy(y,1):stendy(y,2),:) = 0;
            end
        end
    end
end
%now maxclass is white.

%Solve the soduko
global soduko;
soduko = idx;
soduko(soduko==maxclass) = 0;
if maxclass < 7
    soduko(soduko==7) = maxclass;
end
recursiveSoduko(1,1);
if maxclass < 7
    soduko(soduko==maxclass) = 7;
end


%Show the result
finim = im;
imshow(im)
figure
for x = 1:6
    for y = 1:6
        class = soduko(x,y);
        indexer = 1:36;
        classposxy = indexer(find(idx == class,1));
        classposy = floor((classposxy - 1)/6) + 1;
        classposx = classposxy-6*(classposy-1);
        classimg = im(stendx(classposx,1):stendx(classposx,2),stendy(classposy,1):stendy(classposy,2),:);
        [dx, dy, ~] = size(classimg);
        finim(stendx(x,1):stendx(x,1)+dx-1,stendy(y,1):stendy(y,1)+dy-1,:) = classimg;
    end
end
imshow(finim);
 