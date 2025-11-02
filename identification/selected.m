clc;

% Función de transferencia del sistema de primer orden
fo_system = tf([0.0416], [292.4485 1]);

% Niveles de Qh a probar
Qh_levels = [50, 125, 200, 275];

% Crear figura
figure;
hold on;
grid on;
grid minor; % Añadir líneas de cuadrícula menores para mejor legibilidad en B/N

% Estilos de línea para impresión en B/N
line_styles_Ta = {'-', '--', ':', '-.'}; % Estilos para Ta
line_styles_Ta_fo = {':', '-.', '-', '--'}; % Estilos diferentes para Ta_fo

% Configuración de la simulación
simTime = 3600; % Duración de la simulación (en segundos)
modelName = 'incubator_sim'; % Nombre del modelo de Simulink

% Etiquetas de los ejes y título
xlabel('Time [s]');
ylabel('Temperature [K]');
ax = gca;
ax.FontSize = 10;
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';

% Simular para cada nivel de Qh
for i = 1:length(Qh_levels)
    Qh = Qh_levels(i); % Establecer el nivel de Qh
    assignin('base', 'Qh', Qh); % Enviar al espacio de trabajo
    
    % Ejecutar la simulación
    simOut = sim(modelName, 'StopTime', num2str(simTime));
    
    % Extraer datos
    t = simOut.simout2.Time;
    Ta = simOut.simout2.Data(:, 1);
    [y, step_time] = step(fo_system, 3600);
    Ta_fo = Qh_levels(i) * y + 300;
    
    % Asegurar que los estilos de línea se repitan si hay más niveles de Qh que estilos
    current_style_Ta = line_styles_Ta{mod(i - 1, length(line_styles_Ta)) + 1};
    current_style_Ta_fo = line_styles_Ta_fo{mod(i - 1, length(line_styles_Ta_fo)) + 1};
    
    % Graficar temperatura y respuesta del sistema de primer orden
    plot(t, Ta, 'k', 'LineWidth', 1.5, 'LineStyle', current_style_Ta, 'DisplayName', sprintf('Ta %d [W]', Qh)); % Color negro
    plot(step_time, Ta_fo, 'k', 'LineWidth', 1.5, 'LineStyle', current_style_Ta_fo, 'DisplayName', sprintf('Ta_{fo} %d [W]', Qh)); % Color negro
end
xlim([0,3000])
% Aumentar tamaño de los ejes
set(gca, 'FontSize', 14);

% Leyenda
legend('FontSize', 10, 'Location', 'best');

% Finalizar la figura
hold off;
