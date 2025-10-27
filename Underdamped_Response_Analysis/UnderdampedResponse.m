function [f_amort, t_est, t_pico, error_ss] = analisis_respuesta(y2, t)

valor_final = y2(end);

[maximo, idx_max] = max(y2);
t_pico = t(idx_max);

[pks, locs] = findpeaks(y2, t);

pseudo_periodo = locs(2) - locs(1);
f_amort = 1 / pseudo_periodo;

margen_sup = 1.05 * valor_final;
margen_inf = 0.95 * valor_final;

idx_fuera = find(y2 > margen_sup | y2 < margen_inf);
t_est = t(idx_fuera(end));

referencia = 1;                         % Valor del escalón aplicado
error_ss = abs(referencia - y2(end));   % Error en régimen permanente

fprintf('Frecuencia amortiguada: %.4f Hz\n', f_amort);
fprintf('Tiempo de establecimiento: %.4f s\n', t_est);
fprintf('Tiempo de pico: %.4f s\n', t_pico);
fprintf('Error en régimen permanente: %.4f\n', error_ss);
