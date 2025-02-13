
ts_daily = readmatrix('Data.xlsx', 'Sheet', 'Daily', 'Range', 'A2:C5196');
ts_weekly = readmatrix('Data.xlsx', 'Sheet', 'Weekly', 'Range', 'A2:C1041');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 3 a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

USDSEK_w = ts_weekly(:,2);
EURSEK_w = ts_weekly(:,3);

[r_USD_w, r_EUR_w] = calc_returns(ts_weekly);

corr_return = corr(r_USD_w, r_EUR_w);
output.stat.corr = corr_return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 3 b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
autoCorrUSD = zeros(1, 5);
autoCorrEUR = zeros(1, 5);

for i = 1:5
    autoCorrArrayUSD = autocorr(r_USD_w, i);
    autoCorrArrayEUR = autocorr(r_EUR_w, i);
    
    % Store the i-th autocorrelation value (corresponding to lag i)
    autoCorrUSD(i) = autoCorrArrayUSD(i+1); %Lag 0 is at index 1
    autoCorrEUR(i) = autoCorrArrayEUR(i+1);
end

output.RIC = {'USD', 'EUR'};
output.stat.acorr = [autoCorrUSD(1), autoCorrEUR(1);
                     autoCorrUSD(2), autoCorrEUR(2);
                     autoCorrUSD(3), autoCorrEUR(3);
                     autoCorrUSD(4), autoCorrEUR(4);
                     autoCorrUSD(5), autoCorrEUR(5);];


%printResults(output, 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 3 c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('standard_values.mat', 'standard_USD', 'standard_EUR'); %Values from task 2

% Now you can use the variables standard_USD and standard_EUR
u1 = normcdf(standard_USD);
u2 = normcdf(standard_EUR);

U = [u1', u2'];

copulaTypes = {'Gaussian', 't', 'Gumbel', 'Clayton', 'Frank'};
logLik = zeros(length(copulaTypes), 1);

for i = 1:length(copulaTypes)

    if copulaTypes{i} == 't'
         [Rho_t, df] = copulafit(copulaTypes{i}, U);
         logLik(i) = sum(log(copulapdf(copulaTypes{i}, U, Rho, df))) ;
    else
        Rho = copulafit(copulaTypes{i}, U);
        logLik(i) = sum(log(copulapdf(copulaTypes{i}, U, Rho))) ;

    end
end


output.copulaLogL = logLik; %The model with largest log-likelihood is t. Therefore choose it for the random number generation.
save('task3.mat', 'output');

rand_data = copularnd("t", Rho_t, df, 1039);

figure;
subplot(2,1,1);
scatter(rand_data(:,1), rand_data(:,2), '.');
title('Simulated Student-t data');
xlabel('USD');
ylabel('EUR');
xlim([0, 1]);
ylim([0, 1]);

subplot(2,1,2);
scatter(u1, u2, '.');
title('Original Data');
xlabel('USD');
ylabel('EUR');
xlim([0, 1]);
ylim([0, 1]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
