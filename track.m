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
hold on;
xlabel("X");, ylabel("Y");, title("Track Map"), grid on;
xlim([min(X) - 0.05,max(X) + 0.05]), ylim([min(Y) - 0.05,max(Y) + 0.05]);
axis equal;

tracer = plot(X(1), Y(1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

for i = 1:length(X)
    set(tracer, 'XData', X(i), 'YData', Y(i));
    drawnow;
    pause(0.1); % smaller pause = faster animation
end

%xx = linspace(min(X), max(X), 500);
%yy = spline(X, Y, xx);
%hold on;
%plot(xx, yy, 'r-', 'LineWidth', 2);
%legend('Control Points', 'Spline Fit');

% scatter(X, Y, 'filled');
% axis equal, grid on;