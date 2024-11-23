% 定义数据
scatter_data_10 = [
    1, 130;
    5, 120;
    20, 110;
    50, 93.76;
    200, 91.78;
    500, 88.91;
    1000, 87.02;
    4000, 84.90;
    8000, 73.33
];
scatter_data_20 = [
    1, 120;
    5, 111;
    20, 103;
    50, 81.55;
    200, 80.39;
    500, 76.20;
    1000, 75.70;
    4000, 72.40;
    8000, 60.43
];

% 拆分数据
distance_10 = scatter_data_10(:, 1);
SPL_10 = scatter_data_10(:, 2);
distance_20 = scatter_data_20(:, 1);
SPL_20 = scatter_data_20(:, 2);

% 进行二次多项式拟合
p_10 = polyfit(log10(distance_10), SPL_10, 2); % 二次拟合
p_20 = polyfit(log10(distance_20), SPL_20, 2); % 二次拟合

% 输出拟合参数
disp('拟合公式 SPL_10 的参数:');
disp(['a1 = ', num2str(p_10(1))]);
disp(['b1 = ', num2str(p_10(2))]);
disp(['c1 = ', num2str(p_10(3))]);

disp('拟合公式 SPL_20 的参数:');
disp(['a2 = ', num2str(p_20(1))]);
disp(['b2 = ', num2str(p_20(2))]);
disp(['c2 = ', num2str(p_20(3))]);

% 生成拟合曲线
fit_distance = linspace(1, 8000, 100);
fit_SPL_10 = polyval(p_10, log10(fit_distance));
fit_SPL_20 = polyval(p_20, log10(fit_distance));

% 绘制拟合曲线和原始数据
figure('Name', '拟合曲线', 'NumberTitle', 'off', 'Position', [200, 300, 750, 300]);
plot(distance_10, SPL_10, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Data 10');
hold on;
plot(distance_20, SPL_20, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Data 20');
plot(fit_distance, fit_SPL_10, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Fit 10');
plot(fit_distance, fit_SPL_20, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Fit 20');

% 设置图形属性
xlabel('Distance (m)', 'FontName', 'Times New Roman', 'FontSize', 15, 'FontWeight', 'bold');
ylabel('SPL (dB re 1 \muPa)', 'FontName', 'Times New Roman', 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'FontSize', 15, 'Box', 'on', 'XScale', 'log', 'FontName', 'Times New Roman');
legend('show');
set(gcf, 'Color', 'w'); % 设置背景为白色

hold off;
