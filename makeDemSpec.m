function outSpec = makeDemSpec(inSpec)
    % input: [period1 acc1; period2 acc2]
    % output: [spec_disp1 acc1 period1; spec_disp2 acc2 period2;]
    
    outSpec = [];
    
    % build initial demand spectrum S5:T54
    for i=1:length(inSpec)
        specDisp = inSpec(i,2) * inSpec(i,1)^2 * 9.779738;
        outSpec(i,:) = [specDisp inSpec(i,2) inSpec(i,1)];
    end
end