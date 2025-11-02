% Inicializar almacenamiento de RMSE
rmse_values = zeros(length(Qh_levels), 1);

% Calcular el RMSE para cada FT identificada
for i = 1:length(Qh_levels)
    % Obtener la función de transferencia
    po_tf = po_tf_list{i};
    
    % Obtener la respuesta al escalón
    [y, t_step] = step(po_tf, simTime);
    
    % Ajustar la respuesta: y = y * Qh + 300
    y_adj = y * Qh_levels(i) + 300;
    
    % Interpolar para que coincida con la simulación de Simulink
    Ta_interp = interp1(t_step, y_adj, t_new, 'linear', 'extrap');
    
    % Calcular el RMSE
    rmse_values(i) = sqrt(mean((Ta_interp - Ta_simulink).^2));
end

% Encontrar la función de transferencia con el menor RMSE
[~, best_index] = min(rmse_values);
best_tf = po_tf_list{best_index};
best_Qh = Qh_levels(best_index);
best_rmse = rmse_values(best_index);


% Mostrar resultados
fprintf('Mejor función de transferencia (menor RMSE):\n');
disp(best_tf);
fprintf('Qh = %.1f W, RMSE = %.4f\n', best_Qh, best_rmse);
