function [R, L, C, short_med] = RLC_calc
%R: reistance, L: inductance, C: capacitance
%short_med = 0 if short line, = 1 if medium
%R, L and C parameters are the total values.

resistivity = input('Please, enter the conductor resistivity (in Ohm-m): ');
length = input('Please, enter the length of the conductor (in Km): ');
diameter = input('Please, enter the diameter of the conductor (in cm): ');
diameter = diameter/100; 
radius = diameter / 2;
area = (pi * diameter^2) / 4;
GMR = .7788 * radius;
if length <= 80
    short_med = 0;  %short line
elseif length > 80 && length < 250
    short_med = 1;  %medium line
else
    short_med = 2; %long line
end

resistance_dc = (resistivity * length * 1000) / area;   %the dc resistance of the T.L
R = 1.1 * resistance_dc;    %the ac resistance

flag = 0;
while flag == 0      %stay inside the loop if the user chooses an invalid value
    flag = 1;   %assuming that the user will choose a valid vlaue from the first time
    fprintf('The transmission system is:\n1- symmetrical\n2- unsymmetrical\n')
    sym_or_not = input('   Your choice: '); %choosing either symmetric or not
    if sym_or_not == 1  %if symmetric
       spacing = input('Please, enter the spacing between the phases (in m): ');
       GMD = spacing;   
    elseif sym_or_not == 2  %if not symmetric
        ab_dis = input('Please, enter the distance between phases a and b (in m): '); ...
            %distance between phase a and phase b
        bc_dis = input('Please, enter the distance between phases b and c (in m): '); ...
            %distance between phase a and phase b
        ac_dis = input('Please, enter the distance between phases a and c (in m): '); ...
            %distance between phase a and phase c
        GMD = nthroot(ab_dis*bc_dis*ac_dis, 3); %finding the third root
    else 
        clc  %clear the screen
        flag = 0;  %an invalid value is entered..stay inside the loop
        fprintf('Please, choose a valid value from the list\n')
    end
end
clc    %clear the screen

L = 2*10^(-7) * log(GMD/GMR) * length * 1000;     %the total inductance per phase
C = (2 * pi * 8.85*10^(-12)) / log(GMD/radius);  %the capacitance/m
C = C * length * 1000;  %total C per phase
end

