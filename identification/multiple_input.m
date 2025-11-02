clc;
% Niveles de Qh a probar
Qh_levels = linspace(50, 350, 4);

% Crear figura
figure; hold on; grid on; grid minor;

% Estilos de línea diferenciables para impresión B/N
lineStyles = {'-', '--', ':', '-.'};

% Configuración del modelo y simulación
simTime = 3600;
modelName = 'incubator_sim';

% Inicializar para almacenar límites de tiempo
t_min = inf;
t_max = -inf;

% Configurar ejes y etiquetas
xlabel('Time [s]', 'FontSize', 14);
ax = gca;
ax.FontSize = 14;
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';

for i = 1:length(Qh_levels)
    Qh = Qh_levels(i);
    assignin('base', 'Qh', Qh);

    simOut = sim(modelName, 'StopTime', num2str(simTime));

    t = simOut.simout.Time;
    Ta = simOut.simout.Data(:,1);
    Qht = simOut.simout.Data(:,2);

    t_min = min(t_min, min(t));
    t_max = max(t_max, max(t));

    % Graficar temperatura (izquierda)
    yyaxis left
    ylabel('Ta [K]', 'FontSize', 14, 'Color', 'k');
    set(gca, 'YColor', 'k');
    plot(t, Ta, 'k', 'LineWidth', 1.5, ...
        'LineStyle', lineStyles{i}, 'DisplayName', sprintf('Ta %d [W]', Qh));

    % Graficar Qht (derecha)
    yyaxis right
    ylabel('$\dot{Q}_h$ [W]', 'Interpreter','latex', 'FontSize', 14, 'Color','k');
    set(gca, 'YColor', 'k');
    plot(t, Qht, 'k', 'LineWidth', 1.2, ...
        'LineStyle', lineStyles{i}, 'HandleVisibility', 'off');

    % Establecer límites del eje derecho (Qht)
    ylim([25, 375]); % Ajusta según el rango esperado de Qht
end

% Establecer límites ajustados con margen
margin = 0.01 * (t_max - t_min);
xlim([0, 3000]);

% Volver al eje izquierdo para la leyenda
yyaxis left
legend('FontSize', 10, 'Location', 'best');
hold off;
