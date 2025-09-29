port = "COM5";   % <-- ESP32 port
baud = 115200;
s = serialport(port, baud);

flush(s);

% Data buffers
maxPoints = 300;
accData = nan(maxPoints,3);
gyroData = nan(maxPoints,3);
tempData = nan(maxPoints,1);
timeData = nan(maxPoints,1);

% Plot setup
figure;
tiledlayout(3,1);

ax1 = nexttile;
hAcc = plot(ax1, nan, nan, 'r-', nan, nan, 'g-', nan, nan, 'b-');
title(ax1, 'Accelerometer (m/s^2)');
legend(ax1, 'Ax','Ay','Az'); grid on;

ax2 = nexttile;
hGyro = plot(ax2, nan, nan, 'r-', nan, nan, 'g-', nan, nan, 'b-');
title(ax2, 'Gyroscope (rad/s)');
legend(ax2, 'Gx','Gy','Gz'); grid on;

ax3 = nexttile;
hTemp = plot(ax3, nan, nan, 'k-');
title(ax3, 'Temperature (°C)'); grid on;

tic;
while ishandle(ax1)
    line = readline(s);
    values = str2double(split(line,","));

    if numel(values) == 7 && all(~isnan(values))
        accData = [accData(2:end,:); values(1:3)'];
        gyroData = [gyroData(2:end,:); values(4:6)'];
        tempData = [tempData(2:end); values(7)];
        timeData = [timeData(2:end); toc];

        % Update plots
        set(hAcc(1), 'XData', timeData, 'YData', accData(:,1));
        set(hAcc(2), 'XData', timeData, 'YData', accData(:,2));
        set(hAcc(3), 'XData', timeData, 'YData', accData(:,3));

        set(hGyro(1), 'XData', timeData, 'YData', gyroData(:,1));
        set(hGyro(2), 'XData', timeData, 'YData', gyroData(:,2));
        set(hGyro(3), 'XData', timeData, 'YData', gyroData(:,3));

        set(hTemp, 'XData', timeData, 'YData', tempData);

        drawnow limitrate;
    end
end

clear s;
