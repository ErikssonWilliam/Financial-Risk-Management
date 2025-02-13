
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 1 a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ts_daily = readmatrix('Data.xlsx', 'Sheet', 'Daily', 'Range', 'A2:C5196');
ts_weekly = readmatrix('Data.xlsx', 'Sheet', 'Weekly', 'Range', 'A2:C1041');

USDSEK_w = ts_weekly(:,2);
EURSEK_w = ts_weekly(:,3);

figure;
plot(ts_weekly,USDSEK_w)
ylabel('USD/SEK')
yyaxis right %Aktivera den hogra y-axeln
plot(ts_weekly,EURSEK_w);
ylabel('EUR/SEK') %Beskrivning y-axel
xlabel('Datum')
title('Tidsserier') %Titel
legend('USD/SEK','EUR/SEK')

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');

%Calculate logaritmic returns

N = length(ts_weekly);
r_USD = 1:(N-1);
r_EUR = 1:(N-1);

for i=2:N

r_USD(i-1) = log(ts_weekly(i,2)/ts_weekly(i-1,2));
r_EUR(i-1) = log(ts_weekly(i,3)/ts_weekly(i-1,3));

end

figure;
plot(ts_weekly(2:end,:),r_USD)
ylabel('Return USD')
yyaxis right %Aktivera den hogra y-axeln
plot(ts_weekly(2:end,:), r_EUR);
ylabel('Return EUR') %Beskrivning y-axel
xlabel('Datum')
title('Tidsserier') %Titel
legend('USD','EUR')

xlim([min(ts_weekly(:,1)) max(ts_weekly(:,1))]);
datetick('x', 'yy', 'keeplimits');


output.RIC = {'USDSEK', 'EURSEK'};
%%Average Returns
mu_USD = mean(r_USD);
mu_EUR = mean(r_EUR);
mu_year_USD = mean(r_USD, 'omitnan') * 52 *100;
mu_year_EUR = mean(r_EUR, 'omitnan') * 52 *100;
output.stat.mu = [mu_year_USD mu_year_EUR];

%%Calculate volatility

new_sum_USD = 1:(N-1);
new_sum_EUR = 1:(N-1);

for i=2:N

 new_sum_USD(i-1) = ((r_USD(i-1) - mu_USD)^2);
 new_sum_EUR(i-1) = ((r_EUR(i-1) - mu_EUR)^2);

end

sigma_USD = sqrt(sum(new_sum_USD) * 52 / (N-1)) * 100;
sigma_EUR = sqrt(sum(new_sum_EUR) * 52 / (N-1)) * 100;
output.stat.sigma = [sigma_USD sigma_EUR];

vol_usd_yearly = std(r_USD) * sqrt(52) * 100 / sqrt(length(r_USD));
vol_eur_yearly = std(r_EUR) * sqrt(52) * 100 / sqrt(length(r_EUR));

%Calculate confidence interval

CI_USD = [mu_year_USD - 1.96 * vol_usd_yearly, mu_year_USD + 1.96 * vol_usd_yearly];
CI_EUR = [mu_year_EUR - 1.96 * vol_eur_yearly, mu_year_EUR + 1.96 * vol_eur_yearly];
output.stat.CI = [CI_USD; CI_EUR];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Task 1 b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate logaritmic returns for daily

N = length(ts_daily);
r_USD_d = 1:(N-1);
r_EUR_d = 1:(N-1);

for i=2:N

r_USD_d(i-1) = log(ts_daily(i,2)/ts_daily(i-1,2));
r_EUR_d(i-1) = log(ts_daily(i,3)/ts_daily(i-1,3));

end

mu_USD_d = mean(r_USD_d);
mu_EUR_d= mean(r_EUR_d);

new_sum_USD_d = 1:(N-1);
new_sum_EUR_d = 1:(N-1);

for i=2:N

 new_sum_USD_d(i-1) = ((r_USD_d(i-1) - mu_USD_d)^2);
 new_sum_EUR_d(i-1) = ((r_EUR_d(i-1) - mu_EUR_d)^2);

end

sigma_USD_d = sqrt(sum(new_sum_USD)/ (N-1));
sigma_EUR_d = sqrt(sum(new_sum_EUR)/ (N-1));

skew_daily_USD = skewness(r_USD_d);
skew_daily_EUR = skewness(r_EUR_d);

skew_weekly_USD = skewness(r_USD);
skew_weekly_EUR = skewness(r_EUR);

output.stat.skew = [skew_daily_USD, skew_daily_EUR, skew_weekly_USD, skew_weekly_EUR];

kurt_daily_USD = kurtosis(r_USD_d) - 3; %Excessive kurtosis
kurt_daily_EUR = kurtosis(r_EUR_d) - 3; 

kurt_weekly_USD = kurtosis(r_USD) - 3;
kurt_weekly_EUR = kurtosis(r_EUR) - 3;

output.stat.kurt = [kurt_daily_USD, kurt_daily_EUR, kurt_weekly_USD, kurt_weekly_EUR];

%Construct histograms

figure;

% Subplot 1: USD daily
subplot(2, 2, 1); % 2 rows, 2 columns, first cell
histfit(r_USD_d, 20, 'normal');
title('USD daily');

% Subplot 2: EUR daily
subplot(2, 2, 2); % 2 rows, 2 columns, second cell
histfit(r_EUR_d, 20, 'normal');
title('EUR daily');

% Subplot 3: USD weekly
subplot(2, 2, 3); % 2 rows, 2 columns, third cell
histfit(r_USD, 20, 'normal');
title('USD weekly');

% Subplot 4: EUR weekly
subplot(2, 2, 4); % 2 rows, 2 columns, fourth cell
histfit(r_EUR, 20, 'normal');
title('EUR weekly');

%Contruct quantiles

Q_1th_usd_d = quantile(r_USD_d, 0.01);
Q_5th_usd_d = quantile(r_USD_d, 0.05);
Q_95th_usd_d = quantile(r_USD_d, 0.95);
Q_99th_usd_d = quantile(r_USD_d, 0.99);

Q_1th_usd = quantile(r_USD, 0.01);
Q_5th_usd = quantile(r_USD, 0.05);
Q_95th_usd = quantile(r_USD, 0.95);
Q_99th_usd = quantile(r_USD, 0.99);


Q_1th_eur_d = quantile(r_EUR_d, 0.01);
Q_5th_eur_d = quantile(r_EUR_d, 0.05);
Q_95th_eur_d = quantile(r_EUR_d, 0.95);
Q_99th_eur_d = quantile(r_EUR_d, 0.99);

Q_1th_eur = quantile(r_EUR, 0.01);
Q_5th_eur = quantile(r_EUR, 0.05);
Q_95th_eur = quantile(r_EUR, 0.95);
Q_99th_eur = quantile(r_EUR, 0.99);

output.stat.perc = [Q_1th_usd_d, Q_5th_usd_d, Q_95th_usd_d, Q_99th_usd_d;
                    Q_1th_eur_d, Q_5th_eur_d, Q_95th_eur_d, Q_99th_eur_d;  
                    Q_1th_usd, Q_5th_usd, Q_95th_usd, Q_99th_usd;
                    Q_1th_eur, Q_5th_eur, Q_95th_eur, Q_99th_eur];

%Create QQ-plot


figure;

% Subplot 1: USD daily
subplot(2, 2, 1); % 2 rows, 2 columns, first cell
qqplot(r_USD_d/sigma_USD_d)
title('USD daily');

% Subplot 2: EUR daily
subplot(2, 2, 2); % 2 rows, 2 columns, second cell
qqplot(r_EUR_d/sigma_EUR_d)
title('EUR daily');

% Subplot 3: USD weekly
subplot(2, 2, 3); % 2 rows, 2 columns, third cell
qqplot(r_USD/(sigma_USD*100/52))
title('USD weekly');

% Subplot 4: EUR weekly
subplot(2, 2, 4); % 2 rows, 2 columns, fourth cell
qqplot(r_EUR/(sigma_EUR*100/52))
title('EUR weekly');

%USD weekly seem to be fitted better to a log normal distribution than USD daily, this
%can be shown by the QQ-plot being closer to a straight line and the
%Histogram is closer to the normal distribution.

%The USD seem overall to be a better fit than EUR, the weekly EUR is better
%than the daily.

%It is reasonable that the weekly fits normal distribution better since on
%a daily basis there's more risk of deviation that can capture different
%relationships.

save('task1.mat', 'output');
