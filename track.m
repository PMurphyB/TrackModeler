clc, clearvars, clear all

data = readtable("spline_points.xlsx");

disp(data);

X = data.X;
Y = data.Y;

invalidMask = (X == 0 | Y == 0 | X == 1e20 | Y == 1e20 | X == -1e20 | Y == -1e20);

X(invalidMask) = [];
Y(invalidMask) = [];

n = length(X);
orderedX = zeros(n, 1);
orderedY = zeros(n, 1);
used = false(n, 1);

for k = 2:n
    dx = X - orderedX(k-1);
    dy = Y - orderedY(k-1);
    dist = sqrt(dx.^2 + dy.^2);
    dist(used) = inf;
    [~, idx] = min(dist);
    orderedX(k) = X(idx);
    orderedY(k) = Y(idx);
    used(idx) = true;

end

orderedX(end+1) = orderedX(1);
orderedY(end+1) = orderedY(1);

figure(1);
plot(X, Y, 'g');
xlabel("X");, ylabel("Y");, title("Track Map"), grid on;
xlim([min(X) - 25,max(X) + 25]), ylim([min(Y) - 25,max(Y) + 25]);
axis equal;