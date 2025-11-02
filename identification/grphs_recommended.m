clc;
% Qh levels to test
Qh_levels = linspace(50, 350, 20);

% Create figure
figure; hold on; grid on; grid minor;

% Estilos de línea diferenciables para impresión B/N
lineStyles = {'-', '--', ':', '-.', '-', '--', ':', '-.', '-', '--', ':', '-.', '-', '--', ':', '-.', '-', '--', ':', '-.'}; % Extend as needed

% Configuración del modelo y simulación
simTime = 3600;  % Simulation duration
modelName = 'incubator_sim';  % Your Simulink model name

% Inicializar para almacenar límites de tiempo
t_min = inf;
t_max = -inf;

% Configurar ejes y etiquetas
xlabel('$\dot{Q}_h$ [W]', 'Interpreter','latex', 'FontSize', 14); % Eje X con notación derivada
ax = gca;
ax.FontSize = 14;
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';

% Inicializar para almacenar los puntos finales
last_points_Ta = [];
last_points_Qht = [];

for i = 1:length(Qh_levels)
    Qh = Qh_levels(i);  % Set Qh level
    assignin('base', 'Qh', Qh);  % Send to workspace
    
    % Run simulation
    simOut = sim(modelName, 'StopTime', num2str(simTime));
    
    % Extract data
    t = simOut.simout.Time;
    Ta = simOut.simout.Data(:,1);
    Qht = simOut.simout.Data(:,2);
    
    t_min = min(t_min, min(t));
    t_max = max(t_max, max(t));
    
    % Almacenar los últimos valores de Ta y Qht
    last_points_Ta(i) = Ta(end);
    last_points_Qht(i) = Qht(end);
end

% Graficar los puntos finales
ylabel('Ta [K]', 'Color', 'k');
set(gca, 'YColor', 'k');
plot(Qh_levels, last_points_Ta, 'ko-', 'LineWidth', 1.5, ...
    'MarkerFaceColor', 'k', 'MarkerSize', 8, 'DisplayName', 'Ta SS');

% Establecer límites ajustados
margin_x = 0.01 * (max(Qh_levels) - min(Qh_levels));
xlim([min(Qh_levels) - margin_x, max(Qh_levels) + margin_x]);

% Añadir leyenda
legend('FontSize', 10, 'Location', 'best');

hold off;
