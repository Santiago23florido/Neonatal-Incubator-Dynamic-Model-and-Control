K = 0.0415;           % Ganancia
tau = 292.4477;       % Constante de tiempo
%delay = 2.0988;       % Retardo

fo_sys = tf([K], [tau 1]);

% Discretización
%ts = 56.1537;
ts=5;
Hz = c2d(fo_sys, ts, 'zoh');
Hz2 = c2d(fo_sys, ts, 'tustin');


% Simulación de la respuesta escalón

tmax = 1500;
[y1,t1] = step(fo_sys, tmax);
[y2, t2] = step(Hz, tmax);
[y3, t3] = step(Hz2, tmax);

% Ajuste de valores de salida
y1 = 120 * y1 + 300;
y2 = 120 * y2 + 300;
y3 = 120 * y3 + 300;

% Graficar las respuestas
figure;
hold on;
plot(t1, y1, 'k-', 'LineWidth', 1.5);
plot(t2, y2, 'k--', 'LineWidth', 1.5);
plot(t3, y3, 'k:', 'LineWidth', 1.5);
hold off;
legend('Continuous', 'ZOH', 'Tustin','FontSize',12);
xlabel('Time (s)','FontSize',14);
ylabel('Temperature (K)','FontSize',14);
grid on;
grid minor;
%% controller
fo_d=tf([1],[980*0.95/5 1])
desired=c2d(fo_d,ts,'zoh').denominator{1}

[r,s,t]=incremental_rst(Hz,1,desired,ts)
%% Simulación PID RH
simData = out;  % Datos de simulación

% Extraer datos
t = simData.simout.Time;       % Vector de tiempo
y = simData.simout.Data(:,1);  % Señal: salida del sistema (RH)

% Set-point (constante en 100%)
sp = 100 * ones(length(y),1); 

% Crear la figura
figure;
hold on;

% Etiquetas de ejes
xlabel('Time [s]', 'FontSize', 14);
ylabel('RH [%]', 'FontSize', 14);

% Graficar señales
plot(t, y, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Air RH');
plot(t, sp, 'k:', 'LineWidth', 1.5, 'DisplayName', 'Set-point');
% plot(t, u, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Control signal'); % opcional

% Configuración del gráfico
legend('show', 'FontSize', 12, 'Location', 'best');
grid on;
grid minor;
xlim([0, 3000]);
ylim([0, 120]);

% Configuración de ejes
ax = gca;
ax.FontSize = 14;
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';

hold off;
