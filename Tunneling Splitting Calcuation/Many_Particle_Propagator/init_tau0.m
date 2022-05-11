function [ModVec1] = init_tau0(eq_pos, a)

x0  = eq_pos(1);
y0  = eq_pos(2);
z0  = eq_pos(3);

eta = 18.813;

xxV =  (a + 3*x0^2);
yyV =  (a + 3*y0^2);
zzV =  (a + 3*z0^2);

xxU = eta*2*(1/((y0 - x0)^3) + 1/((z0 - x0)^3));
yyU = eta*2*(1/((z0 - y0)^3) + 1/((y0 - x0)^3));
zzU = eta*2*(1/((z0 - x0)^3) + 1/((z0 - y0)^3));

xyU = -eta*(2/((y0 - x0)^3));
xzU = -eta*(2/((z0 - x0)^3));
yzU = -eta*(2/((z0 - y0)^3));

mtx =  [(xxV + xxU) xyU xzU;...
        xyU (yyV + yyU) yzU;...
        xzU yzU (zzV + zzU)]


                          
[ModVec1, EigVal] = eig(mtx);

disp('Eigenvectors (columns)')
disp(num2str(ModVec1))
disp('Frequency Eigevalues (dimles)')
disp(num2str(((EigVal))))
end

