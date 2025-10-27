
# Underdamped Response Analysis

This repository contains a MATLAB and Simulink project for analyzing the underdamped response of a dynamic system. The project simulates a system using Simulink, processes the simulation output in MATLAB, and calculates key performance metrics such as damped frequency, settling time, peak time, and steady-state error. A graphical representation of the response is also generated.

## Table of Contents
- [Project Overview](#project-overview)
- [Files in the Repository](#files-in-the-repository)
- [Dependencies](#dependencies)
- [How to Use](#how-to-use)
- [Code Explanation](#code-explanation)
  - [startScript.m](#startscriptm)
  - [UnderdampedResponse.m](#underdampedresponsem)
- [Simulation Results](#simulation-results)
- [Contributing](#contributing)

## Project Overview
The project focuses on analyzing the underdamped response of a dynamic system modeled in Simulink. The system is simulated using a Simulink model (`untitled.slx`), and the output is processed in MATLAB to compute key metrics:
- **Damped Frequency (f_amort)**: The frequency of oscillation of the underdamped system.
- **Settling Time (t_est)**: The time it takes for the response to stay within ±5% of the final value.
- **Peak Time (t_pico)**: The time at which the maximum peak of the response occurs.
- **Steady-State Error (error_ss)**: The absolute difference between the reference input (step input of 1) and the final output value.

The results are displayed in the MATLAB command window and visualized in a plot showing the system's time response.

## Files in the Repository
- **`startScript.m`**: The main script that runs the Simulink model, retrieves the simulation output, and calls the `UnderdampedResponse` function for analysis.
- **`UnderdampedResponse.m`**: A MATLAB function that processes the simulation data, calculates performance metrics, and generates a plot of the underdamped response.
- **`untitled.slx`**: The Simulink model of the dynamic system.

## Dependencies
- **MATLAB**: Version R2019a or later (ensure the Signal Processing Toolbox is installed for the `findpeaks` function).
- **Simulink**: Required to run the `untitled.slx` model.
- A valid Simulink model file (`untitled.slx`) must be present in the working directory.

## How to Use
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/reguerbrvo/ARS.git
   cd ARS/Underdamped_Response_Analysis
   ```

2. **Ensure Dependencies**:
   - Install MATLAB and Simulink.
   - Verify that the `untitled.slx` Simulink model is in the same directory as the scripts.

3. **Run the Analysis**:
   - Open MATLAB and navigate to the repository directory.
   - Run the `startScript.m` script:
     ```matlab
     startScript
     ```
   - This will execute the Simulink simulation, process the results, and display the metrics and plot.

4. **Expected Output**:
   - The MATLAB command window will display:
     - Damped frequency (Hz)
     - Settling time (s)
     - Peak time (s)
     - Steady-state error
   - A figure window will show a plot of the system's underdamped response.

## Code Explanation

### startScript.m
This script serves as the entry point for the analysis:
- It runs the Simulink model `untitled.slx` twice (once to simulate, once to retrieve results, though the second call may be redundant).
- Extracts the time (`t`) and output signal (`y2`) from the simulation output (`simOut.salidaA`).
- Calls the `UnderdampedResponse` function to analyze the data and generate results.

```matlab
sim("untitled.slx");
% Retrieve simulation results
simOut = sim("untitled.slx");
% Extract relevant data from simulation output
t = simOut.salidaA.time;
y2 = simOut.salidaA.signals.values;

UnderdampedResponse(y2,t);
```

### UnderdampedResponse.m
This function processes the simulation data and computes the system performance metrics:
- **Inputs**:
  - `y2`: The output signal from the Simulink model.
  - `t`: The corresponding time vector.
- **Outputs**:
  - `f_amort`: Damped frequency (Hz).
  - `t_est`: Settling time (s).
  - `t_pico`: Peak time (s).
  - `error_ss`: Steady-state error.
- **Key Calculations**:
  - **Damped Frequency**: Calculated as the inverse of the pseudo-period between consecutive peaks, found using the `findpeaks` function.
  - **Settling Time**: Determined as the last time the signal exceeds ±5% of the final value.
  - **Peak Time**: The time at which the maximum response occurs.
  - **Steady-State Error**: The absolute difference between the reference input (1) and the final output value.
- **Visualization**: Plots the time response with labeled axes and a grid.

```matlab
function [f_amort, t_est, t_pico, error_ss] = UnderdampedResponse(y2, t)
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
    referencia = 1;
    error_ss = abs(referencia - y2(end));
    fprintf('Frecuencia amortiguada: %.4f Hz\n', f_amort);
    fprintf('Tiempo de establecimiento: %.4f s\n', t_est);
    fprintf('Tiempo de pico: %.4f s\n', t_pico);
    fprintf('Error en régimen permanente: %.4f\n', error_ss);
    figure;
    plot(t, y2);
    hold on;
    xlabel('Time (s)');
    ylabel('Response');
    title('Underdamped Response');
    grid on;
    hold off;
end
```

## Simulation Results
The project outputs the following metrics based on the simulation:
- **Damped Frequency**: Indicates how quickly the system oscillates as it settles.
- **Settling Time**: Reflects the time required for the system to stabilize within ±5% of the steady-state value.
- **Peak Time**: Shows the responsiveness of the system to the step input.
- **Steady-State Error**: Measures the accuracy of the system in tracking the reference input.

A plot is generated to visualize the underdamped response, showing the oscillatory behavior of the system over time.

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit (`git commit -m "Add feature"`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

Please ensure that any changes include appropriate documentation and maintain the existing code structure.
---

### Notes for Improvement
1. **Simulink Model**: The `untitled.slx` file is not included in the provided information. Consider adding a brief description of the system modeled (e.g., second-order system, transfer function) in the README or uploading the `.slx` file to the repository.

3. **Error Handling**: Add checks in `UnderdampedResponse.m` to handle cases where `findpeaks` returns fewer than two peaks or the simulation output is invalid.
4. **Plot Enhancements**: Consider adding markers for key points (e.g., peak time, settling time) on the plot for better visualization.
5. **Repository Structure**: Organize the repository with subfolders (e.g., `/scripts`, `/models`) for clarity, especially if additional files are added.

--- 




**AUTHOR**:

Raul Reguera Bravo
