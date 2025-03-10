<<<<<<< HEAD

timeSeries = readmatrix('Data_Quiz.xlsx', 'Sheet', 'Data', 'Range', 'A1:A253');

%Task 1
N = length(timeSeries)
r = 1:(N-1);

for i=2:N

r(i-1) = log(timeSeries(i)/timeSeries(i-1));

end
r;
mu = mean(r)
mu_year = mean(r) * 252

%Task 2

new_sum = 1:(N-1);

for i=2:N

 new_sum(i-1) = ((r(i-1) - mu)^2);

end
sqrt(sum(new_sum) * 252/(N-1))
sigma = sqrt(sum(new_sum) * 252 / (N-1)) * 100

%Task 4

quad = 1:(N-1);
third = 1:(N-1);

for i=2:N
 
  quad(i-1) = ((r(i-1) - mu)^2);
  third(i-1) = ((r(i-1) - mu)^3);

end

gamma = mean(third)/((sqrt(mean(quad))^3))

%Task 5

quad = 1:(N-1);
fourth = 1:(N-1);

for i=2:N
 
  quad(i-1) = ((r(i-1) - mu)^2);
  fourth(i-1) = ((r(i-1) - mu)^4);

end

gamma2 = mean(fourth)/((sqrt(mean(quad))^4))

%Task 6

new_sigma = 1:(N-30);


for t=30:(N-1)

    r_square = zeros(1, 30);
 
    for tau = t:-1:(t-29)

       r_square(t-tau+1) = r(tau) ^ 2;

    end

    new_sigma(t-29) = mean(r_square);
end

sqrt(new_sigma(1,223) * 252) * 100

%Task 7

plot(sqrt(new_sigma * 252) * 100)

%Task 8

sigma_sqr = 1:N;
sigma_sqr(1) = 0;
lambda = 0.94;

for t=1:(N-1)

    if t == 1
    sigma_sqr(t+1) = r(t)^2;
    end

    sigma_sqr(t+1) = lambda * sigma_sqr(t) + (1- lambda) * r(t)^2;
end
sigma_sqr(N)

sigma = sqrt(sigma_sqr(N) * 252) * 100
=======

timeSeries = readmatrix('Data_Quiz.xlsx', 'Sheet', 'Data', 'Range', 'A1:A253');

%Task 1
N = length(timeSeries)
r = 1:(N-1);

for i=2:N

r(i-1) = log(timeSeries(i)/timeSeries(i-1));

end
r;
mu = mean(r)
mu_year = mean(r) * 252

%Task 2

new_sum = 1:(N-1);

for i=2:N

 new_sum(i-1) = ((r(i-1) - mu)^2);

end
sqrt(sum(new_sum) * 252/(N-1))
sigma = sqrt(sum(new_sum) * 252 / (N-1)) * 100

%Task 4

quad = 1:(N-1);
third = 1:(N-1);

for i=2:N
 
  quad(i-1) = ((r(i-1) - mu)^2);
  third(i-1) = ((r(i-1) - mu)^3);

end

gamma = mean(third)/((sqrt(mean(quad))^3))

%Task 5

quad = 1:(N-1);
fourth = 1:(N-1);

for i=2:N
 
  quad(i-1) = ((r(i-1) - mu)^2);
  fourth(i-1) = ((r(i-1) - mu)^4);

end

gamma2 = mean(fourth)/((sqrt(mean(quad))^4))

%Task 6

new_sigma = 1:(N-30);


for t=30:(N-1)

    r_square = zeros(1, 30);
 
    for tau = t:-1:(t-29)

       r_square(t-tau+1) = r(tau) ^ 2;

    end

    new_sigma(t-29) = mean(r_square);
end

sqrt(new_sigma(1,223) * 252) * 100

%Task 7

plot(sqrt(new_sigma * 252) * 100)

%Task 8

sigma_sqr = 1:N;
sigma_sqr(1) = 0;
lambda = 0.94;

for t=1:(N-1)

    if t == 1
    sigma_sqr(t+1) = r(t)^2;
    end

    sigma_sqr(t+1) = lambda * sigma_sqr(t) + (1- lambda) * r(t)^2;
end
sigma_sqr(N)

sigma = sqrt(sigma_sqr(N) * 252) * 100
>>>>>>> 8ae8e4f14569d7774749d657b1a7dba9695f69eb
