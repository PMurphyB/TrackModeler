clc, clearvars, clear all

infile = "fsaetrack.xlsx";
outfile = "fsaetrack_fixed.xlsx";
step = 0.01;
interPoints = 2000;
jumpDetection = 5;
axisPadding = 25;

data = readtable(infile);
X = data.X;
Y = data.Y;

invalidMask = (X == 0 | Y == 0 | X == 1e20 | Y == 1e20 | X == -1e20 | Y == -1e20);
X(invalidMask) = [];
Y(invalidMask) = [];

coords = [X Y];
[coords_u, ~, ~] = unique(coords, 'rows', 'stable');
X = coords_u(:,1);
Y = coords_u(:,2);

cx = mean(X);
cy = mean(Y);

[~, startIdx] = min((X - cx).^2 - (Y - cy).^2);

n = length(X);
orderedX = zeros(n, 1);
orderedY = zeros(n, 1);
used = false(n, 1);

orderedX(1) = X(startIdx);
orderedY(1) = Y(startIdx);
used(startIdx) = true;

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

d = sqrt(diff(orderedX.^2) + diff(orderedY.^2));
s = [0; cumsum(d)];

if s(end) == 0

    xx = orderedX;
    yy = orderedY;

else
    tt = linspace(0, s(end), interPoints);
    xx = interp1(s, orderedX, tt, 'pchip');
    yy = interp1(s, orderedY, tt, 'pchip');
end

figure(1); 
clf;
plot(xx, yy, 'g-', 'LineWidth', 1.5);
hold on;
plot(orderedX, orderedY, 'ko', 'MarkerSize', 3);
axis equal;
xlim([min(xx) - axisPadding, max(xx + axisPadding)]);
ylim([min(yy) - axisPadding, max(yy + axisPadding)]);

d_consec = sqrt(diff(orderedX).^2 + diff(orderedY).^2);
th = median(d_consec) + jumpDetection * std(d_consec);
bigIdx = find(d_consec > th);

for k = bigIdx.'
    plot([orderedX(k), orderedX(k + 1)], [orderedY(k), orderedY(k + 1)], 'r-', 'LineWidth', 2);
    text(orderedX(k), orderedY(k), sprintf(' %d', k), 'Color', 'r', 'FontSize', 10);
end

tracer = plot(xx(1), yy(1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
for i = 1:length(xx)
    set(tracer, 'XData', xx(i), 'YData', yy(i));
    drawnow;
    pause(step);
end;

T = table(orderedX(1:end-1), orderedY(1:end-1), 'VariableNames', {'X', 'Y'});
writetable(T, outfile);
fprintf("Saved ordered points to %s\n", outfile);