%Part 1
clear; clc; close all;
% Create number of points to test
test_points = [10,100,1000,10000,100000,1000000,1e7];

% Create arrays to keep track of values
piApprox = zeros(size(test_points));
errors   = zeros(size(test_points));
times    = zeros(size(test_points));


for idx = 1:length(test_points)
    points = test_points(idx);
    
    tic; % Start the timer

    % Makes a random point by picking random x and y coordinates
    x = rand(points, 1);
    y = rand(points, 1);
    % Check the distance of the point
    distances = sqrt(x.^2 + y.^2);
    % The point is inside if the distance from the origin is <= 1.
    insideCircle = sum(distances <= 1);
    
    %Calculate the ratio and estimate pi
    ratio = insideCircle / points;
    piApprox(idx) = 4 * ratio;    
   %Calculate the absolute error
    errors(idx) = abs(pi - piApprox(idx));
    
    % Stops the timer
    times(idx) = toc;
    
    % Prints the results
    fprintf('N = %d:\tPi Approx = %.6f,\tError = %.6f,\tTime = %.4f s\n', ...
            points, piApprox(idx), errors(idx), times(idx));
end

figure;
% Plot of computed value of pi vs number of Points
subplot(1, 2, 1);
semilogx(test_points, piApprox, '-ob');
hold on;
yline(pi, '--r', 'True Value of π');
title('Estimate of π vs. Number of Points');
xlabel('Number of Points');
ylabel('Estimated π');
grid on;
legend('Estimate', 'True Value', 'Location', 'southeast');

% Plot 2 Error vs Number of Points
subplot(1, 2, 2); 
loglog(test_points, errors, '-or');
title('Error vs. Number of Points');
xlabel('Number of Points');
ylabel('Absolute Error');
grid on;

%Plot 3 Precision vs. Computational Cost
figure; 
loglog(times, errors, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('Precision vs. Computational Cost');
xlabel('Execution Time (seconds, log scale)');
ylabel('Absolute Error (log scale)');
grid on;





%Part 2

tolerance = .005 % Target precision


total_points = 0;
points_inside = 0;
pi_calc = 100;
iteration_count = 0;
Start = 1e8;

%Estimates Pi so we don't use the true value
x = rand(Start, 1);
y = rand(Start, 1);
new_points_inside = sum(x.^2 + y.^2 <= 1);
total_points = total_points + 1;
points_inside = points_inside + new_points_inside;
pi_estimate = 4 * new_points_inside / Start;
%rounds estimated pi to 3 sigfigs
roundedpi_est= round(pi_estimate, 2)

total_points = 0;
points_inside = 0;


fprintf('Estimated pi to be: %.6f\n', roundedpi_est);
tic; % Start timing the whole process


%Starts estimating a new value to pi, and will continue until it is close to
%the one generated above
while abs(roundedpi_est - pi_calc) > tolerance
    iteration_count = iteration_count + 1;
    
    
    % Generate a random point
    x = rand();
    y = rand();
    
    % Count how many new points fall inside the quarter circle
    new_points_inside = sum(x.^2 + y.^2 <= 1);
    
    % Update total counts
    total_points = total_points + 1;
    points_inside = points_inside + new_points_inside;
    pi_calc = 4 * points_inside / total_points;

end

total_time = toc; % Stop timer

% Display results
fprintf('Final Pi Calculated: %.6f\n', pi_calc);
fprintf('Total points generated: %d\n', total_points);
fprintf('Total execution time: %.4f seconds\n', total_time);



%Part 3

function q = final()

inputValue = input('Enter a level of precision: ');
sig = inputValue;
fprintf('you entered: %.2f\n', sig);
precision = 5 * 10^-(sig); % Store the precision value for further use
fprintf('number is: %.8f\n', precision);
%Round pi to the number of sigfigs we are looking for
%I'll use my estimated value for pi again so I'm not relying on the true
%value of pi

total_points = 0;
points_inside = 0;
pi_calc = 100;
iteration_count = 0;
Start = 1e8;
x = rand(Start, 1);
y = rand(Start, 1);
new_points_inside = sum(x.^2 + y.^2 <= 1);
total_points = total_points + 1;
points_inside = points_inside + new_points_inside;
pi_estimate = 4 * new_points_inside / Start;

roundedpi = round(pi_estimate, sig-1)
% Calculate the final rounded value of pi based on the specified precision
fprintf('Rounded Pi to %d significant figures: %.8f\n', sig, roundedpi);

total_points = 0;
points_inside = 0;

% Creating the plot
figure;       % Create a new figure window
hold on;      % Keep previous points when plotting new ones
axis equal;   % Ensure the circle arc looks correct
axis([0 1 0 1]); % Set plot limits
title('Generating points');
xlabel('x-coordinate');
ylabel('y-coordinate');
box on;


tic;
while abs(roundedpi - pi_calc) > precision
    iteration_count = iteration_count + 1;
    
    
    % Generate a new batch of random points
    x = rand();
    y = rand();
    
    % Count how many new points fall inside the quarter circle
    new_points_inside = sum(x.^2 + y.^2 <= 1);


    %Plot the points
    if new_points_inside == 1
        plot(x, y, '.r', 'MarkerSize', 5); % Plot red for inside the circle
    else
        plot(x, y, '.b', 'MarkerSize', 5); % Plot blue for outside the circle
    end

    
    % Update total counts
    total_points = total_points + 1;
    points_inside = points_inside + new_points_inside;
    pi_calc = 4 * points_inside / total_points;
    
    drawnow limitrate;
end
total_time = toc; % Stop timer

%Finalize the plot
roundedpi = round(pi_calc, sig-1);
final_title = sprintf('Final π ≈ %.*f', sig, roundedpi);
title(final_title);
legend('Inside', 'Outside', 'Location', 'northeast');
hold off;


% Display results
fprintf('Final Pi Calculated: %.6f\n', pi_calc);
% Calculate the final rounded value of pi based on the specified precision

fprintf('Rounded Final Calculated Pi to %d significant figures: %.8f\n', sig, roundedpi);
fprintf('Total points generated: %d\n', total_points);
fprintf('Total execution time: %.4f seconds\n', total_time);

end
% Call the final function to get precision input and display the result
final();
