clc, clearvars, clear all

data = readtable("fsaetrack.xlsx");

disp(data);

X = data.X;
Y = data.Y;

invalidMask = (X == 0 | Y == 0 | X == 1e20 | Y == 1e20 | X == -1e20 | Y == -1e20);

X(invalidMask) = [];
Y(invalidMask) = [];

%Start of new code

n = length(X);
orderedX = zeroes(n, 1);
orderedY = zeroes(n, 1);
used = false(n, 1);

orderedX(1) = X(1);
orderedY(1) = Y(1);
used(1) = true;

for k = 2:n
    dx = X - orderedX(k - 1);
    dy = Y - orderedY(k - 1);
    dist = sqrt(dx.^2 + dy.^2);
    dist(used) = inf;
    [~, idx] = min(dist);
    orderedX(k) = X(idx);
    orderedY(k) = Y(idx);
    used(idx) = true;
end

orderedX(end + 1) = orderedX(1);
orderedY(end + 1) = orderedY(1);

%End of new code

t = 1:length(orderedX);
tt = linspace(1, length(orderedX), 2000);
xx = interp1(t, orderedX, tt, 'pchip');
yy = interp1(t, orderedY, tt, 'pchip');

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