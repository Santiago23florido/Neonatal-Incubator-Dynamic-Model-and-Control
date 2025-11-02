% Niveles de Qh a probar
Qh_levels = [50, 150, 250,350];

% Crear figura
figure; hold on; grid on;
colors = lines(length(Qh_levels));

% Configuración de la simulación
simTime = 3600;  % Duración de la simulación
modelName = 'incubator_sim';  % Nombre del modelo Simulink

xlabel('Time (s)');
ylabel('Temperature (K)');
title('Thermal response of the system to different Qh levels');

% Parámetros del sistema de primer orden
K = 0.0415;  % Ganancia
tau = 292.4485;  % Constante de tiempo

for i = 1:length(Qh_levels)
    Qh = Qh_levels(i);  % Nivel de Qh
    assignin('base', 'Qh', Qh);  % Enviar a workspace
    
    % Ejecutar simulación
    simOut = sim(modelName, 'StopTime', num2str(simTime));
    
    % Extraer datos de la simulación
    t = simOut.simout2.Time;
    Ta = simOut.simout2.Data(:,1);
    
    % Crear la respuesta del sistema de primer orden con step
    sys = tf(K, [tau 1]);  
    [y, tiempo] = step(sys, 3600);  % Respuesta al escalón unitario
    Ta_fo = Qh * y + 300;  % Ajuste de escala y temperatura base

    % Graficar resultados
    plot(t, Ta, 'Color', colors(i, :), 'LineWidth', 1.5, 'LineStyle', '-', 'DisplayName', sprintf('Ta (%d W)', Qh));
    plot(tiempo, Ta_fo, 'Color', colors(i, :), 'LineWidth', 1.5, 'LineStyle', '--', 'DisplayName', sprintf('Ta_fo (%d W)', Qh));
end

legend;
hold off;
