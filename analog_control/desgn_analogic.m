% Parámetros del sistema de primer orden
K = 0.0415;  % Ganancia
tau = 292.4477;  % Constante de tiempo
ts = 980*0.95;  % Tiempo de establecimiento
%ts = 1200*0.95;
Mp = 0.05;  % Sobrepico permitido

% Cálculo de parámetros del controlador PI-F
xi_1 = -log(Mp) / sqrt(log(Mp)^2 + pi^2);

wn_1 = 4 / (ts * xi_1);

kd = 0.05;
ki = (wn_1^2 * (tau + K * kd)) / K;
kp = (2 * tau * wn_1 * xi_1 + 2 * K * kd * wn_1 * xi_1 - 1) / K;

%% Diseño PID
simData = out;

% Extraer datos de la simulación
t = simData.simout.Time;       % Vector de tiempo
y = simData.simout.Data(:,1);  % Señal 1: salida del sistema (RH)

% Definir set-point (ejemplo constante al 100%)
u = 100 * ones(length(y),1); 

% Si tu modelo ya entrega u o p, puedes descomentar:
% u = simData.simout.Data(:,2); % Señal de control
% p = simData.simout.Data(:,3); % Sistema perturbado

% Crear la figura
figure;
hold on;

% Etiquetas de ejes
xlabel('Time [s]', 'FontSize', 14);
ylabel('RH [%]', 'FontSize', 14);

% Graficar señales
plot(t, y, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Air RH');
plot(t, u, 'k:', 'LineWidth', 1.5, 'DisplayName', 'Set-point');
% plot(t, p, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Disturbed F.O. System');

% Configuración de gráfico
legend('show', 'FontSize', 14, 'Location', 'best');
grid on;
grid minor;
xlim([min(t), max(t)]);

% Configuración de ejes
ax = gca;
ax.FontSize = 14;
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';

hold off;
