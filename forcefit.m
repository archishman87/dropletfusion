function [Tau] = forcefit(Filename,datacolor,fitcolor)
% read hd5 file
info = h5info(Filename);
Force_Trap_2x = h5read(Filename,'/Force HF/Force 2x');
% fetch real time value from frequency
time=[0:1:length(Force_Trap_2x)-1];
time=time';
t=time./78125;
% normalize the force data for trap 2 on x axis
F2 = Force_Trap_2x;
F = F2 - min(F2(:));
Fnorm = F ./ max(F(:));
% fit the data to a stretched exponential funcion
options = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0],...
               'Upper',[Inf,Inf,Inf,Inf],...
               'Startpoint',[0.01 0.01 0.01 0.01],'algorithm','Trust-Region',...
               'DiffMinChange',(1.0E-8),'DiffMaxChange',(0.1),'MaxFunEvals',(600),'MaxIter',(400),...
               'TolFun',(1.0E-6),'TolX',(1.0E-6));

f = fittype('a + (b-a).*(1-exp(-((t-t0)./Tau).^1.5)).*heaviside(t-t0)',...
    'dependent',{'Fnorm'},'independent',{'t'},...
    'coefficients',{'a', 'b', 'Tau','t0'});
% obtain parameters
[c,gof,output] = fit(t,Fnorm,f,options); 
offset = c.a;
plateau = c.b;
Tau = c.Tau;
t0 = c.t0;
% offset the time axis and plot fitted curve and data
ts = t-t0;
Ffit = 0 + (1-0).*(1-exp(-((t-t0)./Tau).^1.5)).*heaviside(t-t0);
Foffset = (Fnorm-offset)./(plateau-offset);
figure
plot(ts,Foffset,datacolor,ts,Ffit,fitcolor)
grid on
xlabel('Time (s)')
ylabel('Normalized Force')

end