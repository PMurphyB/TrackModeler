clc, clearvars, clear all

data = readtable("spline_points.xlsx");

disp(data);

X = data.X;
Y = data.Y;

invalidMask = (X == 0 | Y == 0 | X == 1e20 | Y == 1e20 | X == -1e20 | Y == -1e20);

X(invalidMask) = [];
Y(invalidMask) = [];

figure(1);
plot(X, Y, 'g');
xlabel("X");, ylabel("Y");, title("Track Map"), grid on;
xlim([min(X) - 25,max(X) + 25]), ylim([min(Y) - 25,max(Y) + 25]);
axis equal;



%xx = linspace(min(X), max(X), 500);
%yy = spline(X, Y, xx);
%hold on;
%plot(xx, yy, 'r-', 'LineWidth', 2);
%legend('Control Points', 'Spline Fit');

% scatter(X, Y, 'filled');
% axis equal, grid on;