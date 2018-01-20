function demand = test()
    capacity = [];
    design_ = [];
    pref = [];
    t_e = 0;
    t_u = 0;
    load('capacity.mat', 'capacity', 't_e', 't_u', 'kappa', ...
                'b_e', 'd_y', 'a_y')
    load('event.mat', 'design_', 'rRup', 'mag', 'pref');
    
    % build an expanded spectrum to match a prefered period array
    expSpec = buildSpectrum(design_, pref, [t_e t_u]);
    
    % generate a demand spectrum
    undampedDemand = makeDemSpec(expSpec);
    
    demand = damp(undampedDemand, capacity, ...
                        b_e, kappa, d_y, a_y, ...
                        t_e, mag, rRup);
    
                    % find intersections
    ints = findIntersections(demand, capacity);
    
    plot(demand(:,1), demand(:,2), 'LineWidth', 2);
    hold on;
    plot(capacity(:,1), capacity(:,2), 'LineWidth', 2);
    scatter(ints(:,1), ints(:,2), 100, 'r', 'o', 'filled');
    hold off;
    
    legend('Demand', 'Capacity', 'Perf. Point');
    xlim([0 demand(length(demand), 1)])
    title('Example Performance Point Calculation')
    xlabel('Spectral Displacement')
    ylabel('Spectral Acceleration')
    load('check.mat', 'check')
    dif = abs((check - demand(:,1:2))./check);
    
    figure
    scatter(demand(:,3), dif(:,1));
    hold on;
    scatter(demand(:,3), dif(:,2));
    hold off;
    legend('Spectral Displacement','Spectral Acceleration')
    xlabel('Period')
    ylabel('% Difference')
    title('Validation Against Workbook')
    
