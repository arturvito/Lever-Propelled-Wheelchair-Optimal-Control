function [alfa, betae,beta] = ang(gama,lax,lay,L3);
condition

L = sqrt(lax^2 + lay^2);
th6 = abs(atan(lay/lax));

A1 = sin(gama + th6);
B1 = (L./L3) + cos(gama + th6);
C1 = (L./B)*cos(gama + th6) + ((L3.^2 - A.^2 + B.^2 + L.^2)/(2.*L3.*B));
psi = 2*atan((A1 - sqrt(A1.^2 + B1.^2 - C1.^2))./(B1+C1));

alfa = pi/2 + psi - th6;

XL = cos(gama)*L3 + lax;
YL = sin(gama)*L3 - lay ; 

XB = sin(alfa)*B;
YB = -cos(alfa)*B;

ca = XL - XB;
co = YL - YB;

beta = atan(co./ca);

betae = pi/2 + beta - alfa;

end

