% Author: Lino Mediavilla

clc; close all; clear all
format short
sFile = 'datos.csv'; % NOMBRE ARCHIVO DE SALIDA
maxTime = 20; % DURACIÓN DEL EXPERIMENTO EN MINUTOS

delete(instrfindall);    
s1 = serial('COM6');  % TALVEZ CAMBIE DE COMPUTADORA A COMPUTADORA. REVISAR PUERTO DEL ARDUINO EN devmgmt (administrador de dispositivos)   
s1.BaudRate = 9600;      
fopen(s1); 
mData = [];
while (1)  
    sSerialData = fscanf(s1);  
    t = strsplit(sSerialData,'\t');  
    if( size(t,2) == 2)  
        mData = [mData; str2double(t)];
        fprintf('%.1f [s] - %.3f [V]\n', mData(end,1), mData(end,2)); %IMPRIME EN CONSOLA EL TIEMPO Y VOLTAJE MEDIDO
    end
    if(mData(end,1) >= maxTime*60*1000)
        break % SE DETENDRÁ CUANDO EL TIEMPO MÁXIMO SE ALCANCE
    end
end    

delete(instrfindall);     
mData = mData(1:end-1,:);
csvwrite(sFile,mData);    
ww
%%
figure(2)
plot((mData(:,1)/1000)/60,mData(:,2))
xlabel('Time [min]', 'Interpreter','latex','fontsize',20);
ylabel('Temperature [${}^{o}$C]', 'Interpreter','latex','fontsize',20);
title('Cooling System Performance (@ max. power, on 700mL H20)', 'Interpreter','latex','fontsize',20);
grid on
