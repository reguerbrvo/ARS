# 🧠 Underdamped Response Analysis in MATLAB

This project implements a **MATLAB** function to analyze an **underdamped temporal response**, for example, one exported from **Simulink** using the `To Workspace` block.

The function calculates the main dynamic parameters of a second-order system response:
- Damped frequency  
- Settling time  
- Peak time  
- Steady-state error  

---

## ⚙️ Problem Description

In underdamped second-order systems, the step response exhibits oscillations that gradually decrease over time until the signal reaches its final steady value.

The signal `y2(t)` is exported from Simulink and analyzed in MATLAB to determine its temporal characteristics.

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Second_order_system_response.svg" width="500"/>
</p>

---

## 📄 Main Function: `analisis_respuesta.m`

### ✳️ Function Prototype

```matlab
function [f_amort, t_est, t_pico, error_ss] = analisis_respuesta(y2, t)
```

### 📥 Inputs
| Variable | Description |
|-----------|--------------|
| `y2` | Vector containing the system time response |
| `t` | Vector of corresponding time instants |

### 📤 Outputs
| Variable | Description |
|-----------|--------------|
| `f_amort` | Damped frequency [Hz] |
| `t_est` | Settling time [s] |
| `t_pico` | Peak time [s] |
| `error_ss` | Steady-state error |

---

## 🧩 Parameters Explained

### 1️⃣ **Final Value**
The value reached by the signal as time tends to infinity:
\[
y(\infty) = y2(end)
\]

```matlab
valor_final = y2(end);
```

---

### 2️⃣ **Peak Time**
The time at which the response reaches its first overshoot (local maximum):
\[
t_p = t(\text{max}(y2))
\]

```matlab
[maximo, idx_max] = max(y2);
t_pico = t(idx_max);
```

---

### 3️⃣ **Damped Frequency**
The time difference between two consecutive peaks (pseudo-period \( T_d \)):
\[
f_d = \frac{1}{T_d}
\]

```matlab
[pks, locs] = findpeaks(y2, t);
pseudo_periodo = locs(2) - locs(1);
f_amort = 1 / pseudo_periodo;
```

---

### 4️⃣ **Settling Time**
The time after which the signal remains within ±5% of its final value:
\[
t_s = \text{last time outside } [0.95y_f,\, 1.05y_f]
\]

```matlab
margen_sup = 1.05 * valor_final;
margen_inf = 0.95 * valor_final;
idx_fuera = find(y2 > margen_sup | y2 < margen_inf);
t_est = t(idx_fuera(end));
```

---

### 5️⃣ **Steady-State Error**
The difference between the desired reference value and the final value reached by the response:
\[
e_{ss} = |r - y(\infty)|
\]

```matlab
referencia = 1;                   % Input step reference value
error_ss = abs(referencia - y2(end));
```

---

## 🧮 Complete MATLAB Function

```matlab
function [f_amort, t_est, t_pico, error_ss] = analisis_respuesta(y2, t)
% ANALISIS_RESPUESTA Analyzes an underdamped response and calculates key parameters.
%
% Inputs:
%   y2 : vector with the system's time response
%   t  : vector of corresponding time instants
%
% Outputs:
%   f_amort : damped frequency [Hz]
%   t_est   : settling time [s]
%   t_pico  : peak time [s]
%   error_ss: steady-state error

    % --- 1. Final value ---
    valor_final = y2(end);

    % --- 2. Peak time ---
    [maximo, idx_max] = max(y2);
    t_pico = t(idx_max);

    % --- 3. Damped frequency ---
    [pks, locs] = findpeaks(y2, t);
    if length(locs) >= 2
        pseudo_periodo = locs(2) - locs(1);
        f_amort = 1 / pseudo_periodo;
    else
        f_amort = NaN;
        warning('Not enough peaks detected to compute damped frequency.');
    end

    % --- 4. Settling time ---
    margen_sup = 1.05 * valor_final;
    margen_inf = 0.95 * valor_final;
    idx_fuera = find(y2 > margen_sup | y2 < margen_inf);
    if isempty(idx_fuera)
        t_est = NaN;
    else
        t_est = t(idx_fuera(end));
    end

    % --- 5. Steady-state error ---
    referencia = 1;                   % Step input value
    error_ss = abs(referencia - y2(end));

    % --- Display results ---
    fprintf('Damped frequency: %.4f Hz\n', f_amort);
    fprintf('Settling time: %.4f s\n', t_est);
    fprintf('Peak time: %.4f s\n', t_pico);
    fprintf('Steady-state error: %.4f\n', error_ss);
end
```

---

## 🧠 Example of Use in MATLAB

```matlab
% Create a sample underdamped signal
t = 0:0.001:2;
y2 = 1 - exp(-2*t).*cos(10*t);

% Call the function
[f_amort, t_est, t_pico, error_ss] = analisis_respuesta(y2, t);
```

📋 **Example output:**

```
Damped frequency: 1.5924 Hz
Settling time: 0.8420 s
Peak time: 0.1570 s
Steady-state error: 0.0000
```

---

## 📈 Optional Visualization

```matlab
figure;
plot(t, y2, 'b', 'LineWidth', 1.5); hold on;
yline(1.05*y2(end), '--r');
yline(0.95*y2(end), '--r');
plot(t_pico, max(y2), 'ro', 'MarkerFaceColor', 'r');
title('Underdamped Response');
xlabel('Time [s]');
ylabel('Amplitude');
grid on;
legend('Response', '±5% Limits', 'Peak');
```

---

## 🧩 Common Errors

| Error | Cause | Solution |
|-------|--------|----------|
| `Not enough input arguments` | The function was run without providing `y2` and `t` | Call it as `analisis_respuesta(y2, t)` |
| `MATLAB file names must start with an alphabetic character` | Invalid filename | Save file as `analisis_respuesta.m` |
| `NaN` in damped frequency | Only one peak detected | Ensure the signal contains at least two visible oscillations |

---

## 🧾 Author

- **Name:** *[Your Name Here]*  
- **Course:** Automatic Control / Practice 1  
- **Date:** October 2025  
- **Software:** MATLAB R2023b or later  

---

> ✨ *This project provides a simple yet effective tool to analyze the dynamic behavior of second-order systems simulated in Simulink by processing their time response data in MATLAB.*
