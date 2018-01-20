function spec = damp(dem, cap, b_e, kappa, d_y, a_y, ...
                        t_e, mag, rRup)
    %%%%%% For DSF from Sanaz %%%%%
    load('damping.mat', 'T', 'a0','a1','b0', ...
            'b1','b2','b3','b4','b5','b6','b7','b8', 'se')
        
    b_eff = [];
    last_b_h = 0;
    b_eff(1, :) = [0 b_e*100];
    for i = 2:length(cap)
        t = 0;
        if cap(i,2) > 0
            t = sqrt(cap(i, 1) / (9.779738 * cap(i, 2)));
        end
        
        if cap(i,1) >= t_e
            b_h = 100*(kappa*(2*(cap(i,2) + cap(i-1,2))* ...
                        (cap(i,1)-(cap(i-1,1) + (d_y/a_y)*...
                        (cap(i,2)-cap(i-1,2))))+(((last_b_h/100)/kappa))*...
                        2*pi*cap(i-1,1)*cap(i-1,2))/(2*pi*cap(i,1)*cap(i,2)));
            last_b_h = b_h;
          
            b_eff(i, :) = [t max(b_h, b_e*100)];
        else
            b_eff(i, :) = [t (b_e*100)];
        end
    end
    
    % expand b_eff to include sanaz's periods
    beta = buildSpectrum(b_eff, T);
    
    dsf = [];
    for i = 1:length(beta)
        lnDSF = (b0(i) + b1(i)*log(beta(i,2)) + b2(i)*((log(beta(i,2)))^2)) ...
                        + (b3(i) + b4(i)*log(beta(i,2)) + b5(i)*((log(beta(i,2)))^2)) * mag ...
                        + ( b6(i) + b7(i)*log(beta(i,2)) + b8(i)*((log(beta(i,2)))^2)) * log(rRup+1);
        
        dsf(i,:) = [beta(i,1) round(exp(lnDSF), 3)];
    end
    
    % expand spectrum to match demand's periods
    dsf_exp = buildSpectrum(dsf, dem(:,3));
    
    % create damped demand spectrum
    for i = 1:length(dem)
        damp_disp = dem(i,1) * dsf_exp(i,2);
        damp_acc = damp_disp/(9.779738*dem(i,3)^2);
        
        dem(i, :) = [damp_disp damp_acc dem(i,3)];
    end
    
    spec = dem;
    
    
    
    
