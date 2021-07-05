function [xs,ys]=do_fit_model(x,y)

models={'l','p','q1','q2','v1','v2','ln'};
imodel=1;

qfit=eq_fit(x,y,models{imodel});
[curve2,gof2] = fit(x,y,qfit);
coeff1   =   coeffvalues(curve2);
xs=sort(x);
ys=coeff1(1).*xs+coeff1(2);