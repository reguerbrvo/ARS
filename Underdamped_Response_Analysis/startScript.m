sim("untitled.slx");
% Retrieve simulation results
simOut = sim("untitled.slx");
% Extract relevant data from simulation output
t = simOut.salidaA.time;
y2 = simOut.salidaA.signals.values;

UnderdampedResponse(y2,t);

