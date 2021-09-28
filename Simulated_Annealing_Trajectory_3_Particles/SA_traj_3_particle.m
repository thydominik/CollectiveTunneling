%Simulated Annealing -> Imaginary time trajectories for 3 particle
%collective tunneling.

clc
clear all
format long

%loading the equilibrium positions
eqpos   = load('eq_pos4_15');   %from file eq_pos.mat
eq_pos  = eqpos.eqpos;      %4 by 100 array with alpha and equilibrium values

%Paramteres and constant of the Simulation
r       = 1.3;                  %time reparametrization free parameter
eps     = 10^-10;               %z_time cutoff
N       = 200;                  %# of points in the curve
state   = 4;                   %Choosing a state inside eqpos variable
a       = eq_pos(4,state) ;     %a --> \alpha parameter of the potential
disp("alpha = " + num2str(a))

%THIS PARAMETER IS NEGATIVE!!!!
rs      = 20;               %dimensionless interaction strength 18.813;
iter    = 5 * 10^6;             %# of iterations

%time parameter
z_reduced   = linspace(-1 + eps, 1 - eps, N);     %eps reduced z imag time
z           = linspace(-1, 1, N);
dz_reduced  = z_reduced(2) - z_reduced(1);
dz          = z(2) - z(1);

%equilibrium positions
p1_in =  eq_pos(1,state);        %initial and final positions of the particles
p1_fi = -eq_pos(3,state);
p2_in =  eq_pos(2,state);
p2_fi = -eq_pos(2,state);
p3_in =  eq_pos(3,state);
p3_fi = -eq_pos(1,state);

T_init = 50;                     %starting temperature which is exponentially decreases
T = T_init * exp(-(linspace(0,30,iter)));

sigma = 0.1 * sqrt(T);          %new step deviance

%initializing the starting position & deteermining the energy shift
[position, shift]   = f_initpos(N,p1_in,p1_fi,p2_in,p2_fi,p3_in,p3_fi,rs,a);
E_0                 = f_actioncalc(position,r,a,rs,N,z,dz,shift);
disp("E_0 = " + num2str(E_0, 15))
disp("Shift = " + num2str(shift))

%Keeping track of the discarded moves & Energy/iteration:
discarded = zeros(iter,1);
E = zeros(iter,1);

%Simulated Annealing:
for i = 1:iter
    
    sig         = sigma(i);
    pos_new     = f_newstep(position,N,sig,p1_in,p1_fi,p2_in,p2_fi,p3_in,p3_fi);
    E_new       = f_actioncalc(pos_new,r,a,rs,N,z,dz,shift);
    E_diff      = E_0 - E_new;
    
    if E_diff > 0
        position    = pos_new;
        E_0         = E_new;
    elseif rand() <= exp(E_diff/T(i))
        position    = pos_new;
        E_0         = E_new;
    else
        discarded(i) = i;
    end
    E(i) = E_0;
    
    if rem(i,10000) == 0
        figure(1)
        clf(figure(1))
        hold on
        plot(z,position(1,:))
        plot(z,position(2,:))
        plot(z,position(3,:))
        hold off
        disp("iter= " + num2str(i) + "   "+ "E_0= " + num2str(E_0, 10))
    end   
end

%%
figure(2)
clf(figure(2))
hold on
z = linspace(-1,1,N);
scatter(z,position(2,:),'r','LineWidth',2)
scatter(z,position(1,:),'b','LineWidth',2)
plot(z,position(3,:),'k','LineWidth',2)
ylabel('\chi_i(z)','FontSize', 22)
xlabel('z','FontSize', 22)
ylim([-4.5 4.5])
hold off
disp('Done')

%%
figure(3)
clf(figure(3))
hold on
%positions = f_spline_fit(position, z);
plot3(position(1,:) - 1*min(position(1,:)),position(2,:) - 1*min(position(2,:)),position(3,:) - 1*min(position(3,:)), 'ro-')
%quiver3(0,0,0,0.4219,0.8025,0.4319)
%quiver3(0,0,0,-0.7071,0.0,0.7071)
%quiver3(0,0,0,-0.5675,-0.5966,0.5675)
hold off
%%
figure(4)
clf(figure(4))
hold on
title('discarded steps')
hist(nonzeros(discarded),iter/10000)
hold off

figure(5)
clf(figure(5))
hold on
set(gca, 'YScale', 'log')
plot(E-min(E))
hold off

figure(6)
clf(figure(6))
hold on
set(gca, 'YScale', 'log')
plot(E)
hold off
%%
figure(7)
clf(figure(7))
hold on
plot(z(1:end-1) + dz/2, diff(position(1,:)))
plot(z(1:end-1) + dz/2, diff(position(2,:)))
plot(z(1:end-1) + dz/2, diff(position(3,:)))
set(gca, 'YScale', 'log')
xlabel('z + dz/2 (két z érték közötti pontokon)1')
ylabel('d/dz \chi ')
hold off
%%
p = position;
z = linspace(-1,1,200);
pot1 = 0.25 .* (p(1, :).^2 + a).^2 + 0.5 * rs .* ( 1./abs(p(1, :) - p(2, :)) + 1./abs(p(1, :) - p(3, :)) );
pot2 = 0.25 .* (p(2, :).^2 + a).^2 + 0.5 * rs .* ( 1./abs(p(2, :) - p(1, :)) + 1./abs(p(2, :) - p(3, :)) );
pot3 = 0.25 .* (p(3, :).^2 + a).^2 + 0.5 * rs .* ( 1./abs(p(3, :) - p(1, :)) + 1./abs(p(3, :) - p(2, :)) );
pot = pot1 + pot2 + pot3 - shift;

x = linspace(0,1,100);
b = 0.65033;
a = -0.01307;

figure(8)
clf(figure(8))
hold on
plot(1 + z, pot)

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
hold off
