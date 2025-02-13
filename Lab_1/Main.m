
run('Ass1_Part2_Task1.m');
run('Ass1_Part2_Task2.m');
run('Ass1_Part2_Task3.m');

data1 = load('task1.mat', 'output');
data2 = load('task2.mat', 'output');
data3 = load('task3.mat', 'output');

combined_output = [data1.output, data2.output, data3.output];

% Save the combined output to a new file
save('combined_output.mat', 'output');

printResults(output, 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Answers to task 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%USD weekly seem to be fitted better to a log normal distribution than USD daily, this
%can be shown by the QQ-plot being closer to a straight line and the
%Histogram is closer to the normal distribution.

%The USD seem overall to be a better fit than EUR, the weekly EUR is better
%than the daily.

%It is reasonable that the weekly fits normal distribution better since on
%a daily basis there's more risk of deviation that can capture different
%relationships.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Answers to task 2
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Answers to task 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The scatter-plot is pretty similar, which indicates that the distribution
%describes the datas dependence well.

