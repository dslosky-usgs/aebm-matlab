function intsect = findIntersections(line1, line2)
    % transpose if necessary
    size1 = size(line1);
    size2 = size(line2);
    if size1(1) == 2
        line1 = transpose(line1);
        size1 = size(line1);
    end
    
    if size2(1) == 2
        line2 = transpose(line2);
        size2 = size(line2);
    end
    
    if size1(2) < 2 || size2(2) < 2
        error('Input line has bad dimensions.')
    end
    
    intsect = [];
    line1Pos = 1;
    line2Pos = 1;
    while line1Pos < length(line1) && line2Pos < length(line2)
        seg1 = [line1(line1Pos,:); line1(line1Pos + 1,:)];
        seg2 = [line2(line2Pos,:); line2(line2Pos + 1,:)];
        
        if segsIntersect(seg1, seg2)
            int = getIntersection(seg1, seg2);
            if isempty(intsect) 
                intsect(1, :) = int;
            elseif ~ismember(int(1), intsect(:,1))
                intsect(length(intsect(:, 1)) + 1, :) = int;
            end
        end
        
        if seg1(2,1) == seg2(2,1)
            line1Pos = line1Pos + 1;
            line2Pos = line2Pos + 1;
        elseif seg1(2,1) < seg2(2,1)
            line1Pos = line1Pos + 1;
        else
            line2Pos = line2Pos + 1;
        end
    end
end


function segsInt = segsIntersect(seg1, seg2)
    % seg1 and seg2 are 2d arrays 
    % [ [x1 y1]; [x2 y2] ]
    dx1 = seg1(2,1) - seg1(1,1);
    dx2 = seg2(2,1) - seg2(1,1);
    dy1 = seg1(2,2) - seg1(1,2);
    dy2 = seg2(2,2) - seg2(1,2);
    
    % check for parallel segs
    if (dx2 * dy1 - dy2 * dx1) == 0 
        % The segments are parallel.
        segsInt = false;
        return
    end
    
    s = ((dx1 * (seg2(1,2) - seg1(1,2)) + dy1 * (seg1(1,1) - seg2(1,1))) /... 
                (dx2 * dy1 - dy2 * dx1));
    t = ((dx2 * (seg1(1,2) - seg2(1,2)) + dy2 * (seg2(1,1) - seg1(1,1))) /... 
                (dy2 * dx1 - dx2 * dy1));
        
    segsInt = (s >= 0 && s <= 1 && t >= 0 && t <= 1);
end


function intsect = getIntersection(seg1, seg2)
    % seg1 and seg2 are 2d arrays 
    % [ [x1 y1]; [x2 y2] ]
    
    dx1 = seg1(2,1) - seg1(1,1);
    dx2 = seg2(2,1) - seg2(1,1);
    dy1 = seg1(2,2) - seg1(1,2);
    dy2 = seg2(2,2) - seg2(1,2);
    
    % check for parallel segs
    if (dx2 * dy1 - dy2 * dx1) == 0 
        % The segments are parallel.
        segsInt = False;
        return
    end
    
    s = ((dx1 * (seg2(1,2) - seg1(1,2)) + dy1 * (seg1(1,1) - seg2(1,1))) /... 
                (dx2 * dy1 - dy2 * dx1));
    t = ((dx2 * (seg1(1,2) - seg2(1,2)) + dy2 * (seg2(1,1) - seg1(1,1))) /...
                (dy2 * dx1 - dx2 * dy1));
    
    intsect = [seg1(1,1) + t * dx1 seg1(1,2) + t * dy1];
end