clc, clearvars, clear all

data = readtable("fsaetrack.xlsx");

disp(data);

X = data.X;
Y = data.Y;

invalidMask = (X == 0 | Y == 0 | X == 1e20 | Y == 1e20 | X == -1e20 | Y == -1e20);

X(invalidMask) = [];
Y(invalidMask) = [];

t = 1:length(X);
tt = linspace(1, length(X), 2000);
xx = interp1(t, X, tt, 'pchip');
yy = interp1(t, Y, tt, 'pchip');

figure(1);
plot(xx, yy, 'g');
hold on;
xlabel("X");, ylabel("Y");, title("Track Map"), grid on;
xlim([min(X) - 25,max(X) + 25]), ylim([min(Y) - 25,max(Y) + 25]);
axis equal;

tracer = plot(X(1), Y(1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

for i = 1:length(X)
    set(tracer, 'XData', xx(i), 'YData', yy(i));
    drawnow;
    pause(0.1); % smaller pause = faster animation
end