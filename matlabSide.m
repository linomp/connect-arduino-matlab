% Author: Lino Mediavilla

clc; close all; clear all
format short

outputFile = 'datos'; % Nombre del archivo de salida (sin extensión)
maxTime = 20; % Duración del experimento en minutos
dataColumns = 2; % Nro. de datos enviados por arduino en cada loop.

delete(instrfindall); 
% Config. del puerto serial
% Revisar puerto del arduino en devmgmt (administrador de dispositivos)   
s1 = serial('COM6');  
s1.BaudRate = 9600;      
fopen(s1);  
mData = []; 

hold on
while (1)  
    incomingSerialData = fscanf(s1);   
    dataRow = strsplit(incomingSerialData,'\t');  
    if( size(dataRow,2) == dataColumns ) 
        % Guardar nuevo dato
        dataRow = str2double(dataRow);
        mData = [mData; dataRow];
        
        % Plot en tiempo real  
        
        % ** Punto x punto **
        % plot((dataRow(1)/1000)/60, dataRow(2), 'ro', 'markerfacecolor', 'r', 'markersize', 3);
        
        % ** Interpolando linealmente **
        if(size(mData, 1) > 1)
            plot((mData(end-1:end,1)/1000)/60,mData(end-1:end,2), 'r')
            xlabel('Time [min]');
            ylabel('V'); 
            drawnow
        end
        
        % Imprimir lecturas a consola
        %fprintf('%.1f [s] - %.3f [V]\n', mData(end,1), mData(end,2)); 
    end
    
    % Detener loop cuando el timepo máximo se alcance
    % (se asume que la 1era columna de datos contiene los tiempos en ms)
    if(mData(end,1) >= maxTime*60*1000)
        break 
    end
end    

delete(instrfindall);     
mData = mData(1:end-1,:);

% Guardar en .csv y en .mat
csvwrite(strcat(outputFile, '.csv'), mData);    
save(outputFile, 'mData');

%% Plot aparte con mejor formato una vez que ha terminado el experimento

figure(2)
plot((mData(:,1)/1000)/60,mData(:,2))
xlabel('Time [min]', 'Interpreter','latex','fontsize',20);
ylabel('Temperature [${}^{o}$C]', 'Interpreter','latex','fontsize',20);
title('Cooling System Performance (@ max. power, on 700mL H20)', 'Interpreter','latex','fontsize',20);
grid on
