clc;
% Niveles de Qh
Qh=150;
Qh_levels = linspace(50, 350, 20);
% Configuración de la simulación
simTime = 3600;
modelName = 'incubator_sim';
% Ejecutar la primera simulación para determinar el número de muestras
simOut = sim(modelName, 'StopTime', num2str(simTime));
t = simOut.simout.Time;
num_samples = length(t);
% Inicializar matrices y variables
po_tf_list = cell(length(Qh_levels), 1);
k_values = zeros(length(Qh_levels), 1);
tau_values = zeros(length(Qh_levels), 1);
Ta_matrix = zeros(num_samples, length(Qh_levels));
% Simular para cada nivel de Qh
for i = 1:length(Qh_levels)
    Qh = Qh_levels(i);
    assignin('base', 'Qh', Qh);
    % Ejecutar la simulación
    simOut = sim(modelName, 'StopTime', num2str(simTime));
    % Extraer datos de la simulación
    t_sim = simOut.simout.Time;
    Ta = simOut.simout.Data(:, 1);
    % Interpolar para asegurar el mismo tamaño
    Ta_interp = interp1(t_sim, Ta, t, 'linear', 'extrap');
    % Guardar en la matriz
    Ta_matrix(:, i) = Ta_interp;
    % Identificación del sistema de primer orden
    po_tf_list{i} = fo_aprox(Ta_interp, Qh * ones(size(t)), t);
    % Extraer parámetros del sistema identificado
    [num, den] = tfdata(po_tf_list{i}, 'v');
    k_values(i) = num(2);
    tau_values(i) = den(1);
    % Mostrar resultados
    fprintf('Función de transferencia identificada para Qh = %d W:\n', Qh);
    disp(po_tf_list{i});
    fprintf('k = %.4f, tau = %.4f\n\n', k_values(i), tau_values(i));
end

rmse = zeros(length(Qh_levels), 1);
best_index = 1;
min_rmse = inf;
for i = 1:length(Qh_levels)
    total_error = 0;
    for j = 1:length(Qh_levels)
        [y_r, t] = step(po_tf_list{i}, 3600);
        ta_j = Ta_matrix(:, j);
        min_length = min(length(y_r), length(ta_j));
        y_r = y_r(1:min_length);
        ta_j = ta_j(1:min_length);
        error_sq = (Qh_levels(j) * y_r + 300 - ta_j) .^ 2;
        total_error = total_error + sum(error_sq);
    end
    rmse(i) = total_error;
    if rmse(i) < min_rmse
        min_rmse = rmse(i);
        best_index = i;
    end
end
best_tf = po_tf_list{best_index};
disp("La mejor función de transferencia es:");
disp(best_tf);
last_Qh = Qh_levels(end);
assignin('base', 'Qh', last_Qh);
simOut = sim(modelName, 'StopTime', num2str(simTime));
t_sim = simOut.simout.Time;
Ta_simulink = simOut.simout.Data(:, 1);
% Verificar y corregir el vector de tiempo
if any(diff(t_sim) <= 0) || any(isnan(t_sim)) || any(isinf(t_sim))
    t_new = linspace(0, simTime, length(t_sim));
else
    t_new = t_sim;
end

% Crear figura
figure;
hold on;
grid on;
grid minor;

% Estilos de línea
planta_line_style = '-'; % Línea continua para la planta
tf_line_style = ':';     % Línea punteada para las FT
planta_color = 'k';
tf_color = 'k';

% Graficar la salida de Simulink
plot(t_new, Ta_simulink, 'Color', planta_color, 'LineWidth', 2, 'LineStyle', planta_line_style, 'DisplayName', 'Plant Output');
hold on;

% Graficar las respuestas escalón de los sistemas identificados
for i = 1:length(Qh_levels)
    po_tf = po_tf_list{i};
    [y, t_step] = step(po_tf, 3600);
    y_adj = y * Qh_levels(end) + 300;
    plot(t_step, y_adj, 'Color', tf_color, 'LineWidth', 1, 'LineStyle', tf_line_style, 'DisplayName', 'Transfer Functions');
end

% Configurar la gráfica
xlabel('Time [s]');
ylabel('Temperature [k]');

% Crear la leyenda
h_legend = legend('Location', 'best');
% Agrupar las entradas de la leyenda para las Transfer Functions
if isobject(h_legend)
    legend_entries = get(h_legend, 'String');
    tf_indices = find(contains(legend_entries, 'Transfer Functions'));
    if ~isempty(tf_indices)
        legend_entries{tf_indices(1)} = 'Transfer Functions';
        legend_entries(tf_indices(2:end)) = [];
        set(h_legend, 'String', legend_entries);
    end
end
xlim([0,3000])
grid on;
hold off;
