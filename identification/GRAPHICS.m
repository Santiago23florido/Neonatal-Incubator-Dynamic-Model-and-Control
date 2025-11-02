Qh = 120;
simData = out;
t = simData.simout.Time;        % Vector de tiempo
y1 = simData.simout.Data(:,1);  % Temperatura
y2 = simData.simout.Data(:,2);  % Qht

% Crear figura
figure;
hold on;

yyaxis left
plot(t, y1, 'k', 'LineWidth', 1.5);         
ylabel('Ta [K]', 'Color', 'k');             
set(gca, 'YColor', 'k');                    

yyaxis right
plot(t, y2, 'k--', 'LineWidth', 1.5);       
ylabel('$\dot{Q}_h$[W]', 'Color', 'k');            
set(gca, 'YColor', 'k');                    

legend('Temperature','Input','FontSize',10);
grid on;
grid minor;
xlim([min(t), max(t)]);

ax = gca;
ax.FontSize = 10;
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';
xlabel('Time [s]');


