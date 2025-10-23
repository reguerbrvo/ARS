#  Underdamped Response Analysis in MATLAB

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

<img width="829" height="475" alt="sketch" src="https://github.com/user-attachments/assets/956328b7-0360-482d-8349-acf8ed46db2a" />


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

### 1️ **Final Value**
The value reached by the signal as time tends to infinity:

```matlab
valor_final = y2(end);
```

---

### 2️ **Peak Time**
The time at which the response reaches its first overshoot (local maximum):

```matlab
[maximo, idx_max] = max(y2);
t_pico = t(idx_max);
```

---

### 3️ **Damped Frequency**
The time difference between two consecutive peaks (pseudo-period \( T_d \)):

```matlab
[pks, locs] = findpeaks(y2, t);
pseudo_periodo = locs(2) - locs(1);
f_amort = 1 / pseudo_periodo;
```

---

### 4️ **Settling Time**
The time after which the signal remains within ±5% of its final value:

```matlab
margen_sup = 1.05 * valor_final;
margen_inf = 0.95 * valor_final;
idx_fuera = find(y2 > margen_sup | y2 < margen_inf);
t_est = t(idx_fuera(end));
```

---

### 5️ **Steady-State Error**
The difference between the desired reference value and the final value reached by the response:

```matlab
referencia = 1;                   % Input step reference value
error_ss = abs(referencia - y2(end));
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
| `NaN` in damped frequency | Only one peak detected | Ensure the signal contains at least two visible oscillations |

---

## 🧾 Author

- **Name:** *Raul Reguera Bravo*  
- **Course:** Autonomous Robotic Systems / Practice 1  
- **Date:** October 2025  
- **Software:** MATLAB R2023b or later  

---
