
ts_weekly = readmatrix('Data.xlsx', 'Sheet', 'Weekly', 'Range', 'A2:C1041');

USDSEK_w = ts_weekly(:,2);
EURSEK_w = ts_weekly(:,3);

%Calculate logaritmic returns

[r_USD, r_EUR] = calc_returns(ts_weekly);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 2a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%30 day rolling window
N = length(r_USD);
new_sigma_USD = 1:(N-30);
new_sigma_EUR = 1:(N-30);


for t=30:(N-1)

    r_square_USD = zeros(1, 30);
    r_square_EUR = zeros(1, 30);
 
    for tau = t:-1:(t-29)

       r_square_USD(t-tau+1) = r_USD(tau) ^ 2;
       r_square_EUR(t-tau+1) = r_EUR(tau) ^ 2;

    end

    new_sigma_USD(t-29) = mean(r_square_USD);
    new_sigma_EUR(t-29) = mean(r_square_EUR);
end


sigma_EUR_30 = sqrt(new_sigma_EUR(1,1:N-30) * 52) * 100;
sigma_USD_30 = sqrt(new_sigma_USD(1,1:N-30) * 52) * 100;



%90 day rolling window
new_sigma_USD = 1:(N-90);
new_sigma_EUR = 1:(N-90);

for t=90:(N-1)

    r_square_USD = zeros(1, 90);
    r_square_EUR = zeros(1, 90);
 
    for tau = t:-1:(t-89)

       r_square_USD(t-tau+1) = r_USD(tau) ^ 2;
       r_square_EUR(t-tau+1) = r_EUR(tau) ^ 2;

    end

    new_sigma_USD(t-89) = mean(r_square_USD);
    new_sigma_EUR(t-89) = mean(r_square_EUR);
end

sigma_EUR_90 = sqrt(new_sigma_EUR(1,1:N-90) * 52) * 100;
sigma_USD_90 = sqrt(new_sigma_USD(1,1:N-90) * 52) * 100;

figure;
subplot(2, 2, 1);
plot(ts_weekly(30:N-1,:), sigma_EUR_30)
title('EqWMA, EUR, 30day window') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

subplot(2, 2, 2);
plot(ts_weekly(30:N-1,:), sigma_USD_30)
title('EqWMA, USD, 30day window') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

subplot(2, 2, 3);
plot(ts_weekly(90:N-1,:), sigma_EUR_90)
title('EqWMA, EUR, 90day window') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

subplot(2, 2, 4);
plot(ts_weekly(90:N-1,:), sigma_USD_90)
title('EqWMA, USD, 90day window') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 2b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda = 0.94;
N = length(r_EUR);

[EWMA_USD, EWMA_EUR] = calc_EWMA_var(r_USD, r_EUR, lambda);

sigma_EUR = sqrt(EWMA_EUR(1,1:N) * 52) * 100;
sigma_USD = sqrt(EWMA_USD(1,1:N) * 52) * 100;

output.RIC = {'USDSEK', 'EURSEK'};
output.EWMA = {}; 

figure;
subplot(2, 1, 1);

plot(ts_weekly(1:N,:), sigma_USD)
title('EWMA-RiskMetrics, USD') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

subplot(2, 1, 2);

plot(ts_weekly(1:N,:), sigma_EUR)
title('EWMA-RiskMetrics, EUR') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 2c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Optimization of EWMA with fmincon
initial_params = [0.94]; % Initial guess for lambda

% Constraints: (0 <= lambda <= 1)
lb = [0];
ub = [1];
A = [];
b = [];
Aeq = [];
beq = [];
options = optimoptions('fmincon', 'Display', 'off');

% Perform optimization of EWMA
[params_opt_USD, neg_LL_USD] = fmincon(@(params) log_lik_EWMA(params, r_USD, r_EUR, "USD"), initial_params, A, b, Aeq, beq,  lb, ub, [], options);

[ll ,variance_USD] = log_lik_EWMA(params_opt_USD, r_USD, r_EUR, "USD");
sigma_USD = sqrt(variance_USD * 52) * 100;

[params_opt_EUR, neg_LL_EUR] = fmincon(@(params) log_lik_EWMA(params, r_USD, r_EUR, "EUR"), initial_params, A, b, Aeq, beq,  lb, ub, [], options);

[ll ,variance_EUR] = log_lik_EWMA(params_opt_EUR, r_USD, r_EUR, "EUR");
sigma_EUR = sqrt(variance_EUR * 52) * 100;

output.EWMA.obj = [neg_LL_USD, neg_LL_EUR];
output.EWMA.param = [params_opt_USD, params_opt_EUR];

% Plot EWMA

figure;
subplot(2, 1, 1);

plot(ts_weekly(1:N,:), sigma_USD)
title('EWMA, USD') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

subplot(2, 1, 2);

plot(ts_weekly(1:N,:), sigma_EUR)
title('EWMA, EUR') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

% Optimization of GARCH with fmincon, without variance targeting

% Initial parameter guesses
initial_params = [0.1, 0.1, 0.8];

% Constraints: (0 <= omega, alpha, beta <= 1 and alpha + beta <= 1)
lb = [0, 0, 0];
ub = [1, 1, 1];
A = [];
b = [];
Aeq = [];
beq = [];
nonlcon = @(params) deal([], params(1) + params(2) - 1); % alpha + beta <= 1

% Optimization options
options = optimoptions('fmincon', 'Display', 'off');

% Perform optimization
[params_opt_USD, neg_LL_USD] = fmincon(@(params) garch_likelihood(params, r_USD, r_EUR, "USD", "false"), initial_params, A, b, Aeq, beq, lb, ub, nonlcon, options);

[ll ,variance_USD_GARCH] = garch_likelihood(params_opt_USD, r_USD, r_EUR, "USD", "false");
sigma_USD_GARCH = sqrt(variance_USD_GARCH * 52) * 100;

[params_opt_EUR, neg_LL_EUR] = fmincon(@(params) garch_likelihood(params, r_USD, r_EUR, "EUR", "false"), initial_params, A, b, Aeq, beq, lb, ub, nonlcon, options);

output.GARCH.obj = [neg_LL_USD, neg_LL_EUR];
output.GARCH.param = [params_opt_USD, params_opt_EUR];

[ll ,variance_EUR_GARCH] = garch_likelihood(params_opt_EUR, r_USD, r_EUR, "EUR", "false");
sigma_EUR_GARCH = sqrt(variance_EUR_GARCH * 52) * 100;

% Optimization of GARCH with fmincon, with variance targeting

initial_params = [0.1, 0.1]; % Only alpha and beta
lb = [0, 0];
ub = [1, 1];
nonlcon = @(params) deal([], params(1) + params(2) - 1); % α + β ≤ 1


% Optimization options
options = optimoptions('fmincon', 'Display', 'off');

% Perform optimization
%params(3) is omega value
[params_opt_USD_tv, neg_LL_USD_tv] = fmincon(@(params) garch_likelihood(params, r_USD, r_EUR, "USD", "true"), initial_params, A, b, Aeq, beq, lb, ub, nonlcon, options);
[ll ,variance_USD_GARCH_tv] = garch_likelihood(params_opt_USD, r_USD, r_EUR, "EUR", "false");
sigma_USD_GARCH_tv = sqrt(variance_USD_GARCH_tv * 52);

[params_opt_EUR_tv, neg_LL_EUR_tv] = fmincon(@(params) garch_likelihood(params, r_USD, r_EUR, "EUR", "true"), initial_params, A, b, Aeq, beq, lb, ub, nonlcon, options);
[ll ,variance_EUR_GARCH_tv] = garch_likelihood(params_opt_EUR, r_USD, r_EUR, "EUR", "false");
sigma_EUR_GARCH_tv = sqrt(variance_EUR_GARCH_tv * 52);


output.GARCH.objVT = [neg_LL_USD_tv, neg_LL_EUR_tv];
output.GARCH.paramVT = [var(r_USD), params_opt_USD_tv, var(r_EUR), params_opt_EUR_tv];


% Plot GARCH

figure;
subplot(2, 1, 1);

plot(ts_weekly(1:N,:), sigma_USD_GARCH)
title('GARCH non variance targeting, USD') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

subplot(2, 1, 2);

plot(ts_weekly(1:N,:), sigma_EUR_GARCH)
title('GARCH non variance targeting, EUR') %Titel

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 2d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
standard_USD = 1:N;
standard_EUR = 1:N;

for i = 1:N
standard_USD(i) = r_USD(i,1) / sqrt(variance_USD_GARCH(i,1));
standard_EUR(i) = r_EUR(i,1) / sqrt(variance_EUR_GARCH(i,1));
end


save('standard_values.mat', 'standard_USD', 'standard_EUR');

%QQ-plots

figure;

% Subplot 1: USD
subplot(2, 1, 1); 
qqplot(standard_USD)
title('USD daily');

% Subplot 2: EUR
subplot(2, 1, 2); 
qqplot(standard_EUR)
title('EUR daily');

save('task2.mat', 'output');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate the returns

function [r_USD, r_EUR] = calc_returns(ts_weekly)
   

    % Calculate logarithmic returns
    N = length(ts_weekly);
    r_USD = zeros(N-1, 1);
    r_EUR = zeros(N-1, 1);

    for i = 2:N
        r_USD(i-1) = log(ts_weekly(i, 2) / ts_weekly(i-1, 2));
        r_EUR(i-1) = log(ts_weekly(i, 3) / ts_weekly(i-1, 3));
    end
end


%Calculate EMWA

function [EWMA_USD, EWMA_EUR] = calc_EWMA_var(r_USD, r_EUR, lambda)

    N = length(r_EUR);
    EWMA_USD = 1:N;
    EWMA_USD(1) = 0;
    
    EWMA_EUR = 1:N;
    EWMA_EUR(1) = 0;

   
    EWMA_EUR(2) = r_EUR(1)^2;
    EWMA_USD(2) = r_USD(1)^2;
    
    for t=1:(N-1)
        EWMA_EUR(t+1) = lambda * EWMA_EUR(t) + (1- lambda) * r_EUR(t)^2;
        EWMA_USD(t+1) = lambda * EWMA_USD(t) + (1- lambda) * r_USD(t)^2;
    end

end

%Calculate Loglikelihood for EWMA

function [sumLLH, variance] = log_lik_EWMA(params, r_USD, r_EUR, type)

    N = length(r_EUR);
    logLH_USD = 3:N;
    logLH_EUR = 3:N;
    
    lambda = params(1);
    [EWMA_USD, EWMA_EUR] = calc_EWMA_var(r_USD, r_EUR, lambda);

    for t=3:N
       logLH_USD(t-2) = -0.5 * log(2*pi * EWMA_USD(t-1)) - 0.5 * (r_USD(t-1) ^ 2) / EWMA_USD(t-1);
       logLH_EUR(t-2) = -0.5 * log(2*pi * EWMA_EUR(t-1)) - 0.5 * (r_EUR(t-1) ^ 2) / EWMA_EUR(t-1);
    end
    
    if type == "USD"
        sumLLH = -sum(logLH_USD(2:length(logLH_USD)));
        variance = EWMA_USD;
    elseif type == "EUR"
        sumLLH = -sum(logLH_EUR(2:length(logLH_EUR)));
        variance = EWMA_EUR;
    end
end

%Calculate Loglikelihood for EWMA

function [LL, variance] = garch_likelihood(params, r_USD, r_EUR, type, is_fixed)
    
    if type == "USD"
    returns = r_USD;
    elseif type == "EUR"
    returns = r_EUR;
    end
    


    if is_fixed == "true"
        omega = var(returns);
        alpha = params(1);
        beta = params(2);
    elseif is_fixed == "false"
        omega = params(1);
        alpha = params(2);
        beta = params(3);
    end
      
    % Initialize variables
    T = length(r_USD);
    variances = zeros(T,1);
    loglikelihoods = zeros(T,1);

    % Initial variance
    variances(1) = var(returns);
    % Calculate variances and log-likelihoods
    for t = 2:T
        variances(t) = omega * (1-alpha-beta) + alpha * returns(t-1)^2 + beta * variances(t-1);
        loglikelihoods(t) = -0.5 * (log(2*pi) + log(variances(t)) + returns(t)^2 / variances(t));
    end
    variance = variances(1:T,1);
    % Negative log-likelihood
    LL = -sum(loglikelihoods);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Answer to questions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%i)

%We can observe that the volatility of the timeseries depends on the time,
%when using all different methods of observing it. Therefore the time
%series are heteroskedastic

%ii) 

%EWMA has the largest -loglikelihood, GARCH with target variance the next
%largest -loglikelihood and GARCH without target variance is the smallest
%one. 

%This is reasonable beacuase GARCH captures heteroskedastic time series
%better than EWMA, because it can capture periods of high repectively low
%volatility better than EWMA. This is beacause omega can capture the long
%term variance, so the model does not only capture the most recent values.

%iii)

%.The GARCH model without variance targeting captures more pronounced peaks and valleys in volatility, 
% making it more sensitive to sudden changes in market conditions. 
% It reflects extreme changes in volatility more accurately.

%The EWMA model produces smoother volatility estimates, 
% with less pronounced spikes. 
% It adapts to changing volatility conditions but is generally less responsive to sudden shifts compared to the GARCH model.

%iv)

%Yes, the QQ-plots for this assignment follows a straight line better than
%in 1b).

