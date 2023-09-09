
% Los bloques tienen posiciones relativas descritas en forma de filas y columnas.
1{solucion(X + X_r,Y + Y_r,V,B,F) : grid(X,Y)}1 :- bloque(B,F,X_r,Y_r,V).

% Debemos impedir que se salga de la grilla
:- solucion(X,Y,V,B,F), Y > (n-1).
:- solucion(X,Y,V,B,F), X > (n-1).
:- solucion(X,Y,V,B,F), Y < 0.
:- solucion(X,Y,V,B,F), X < 0.

% Debemos impedir que se superpongan bloques
:- solucion(X1,Y1,V1,B1,F1), solucion(X2,Y2,V2,B2,F2), X1 = X2, Y1 = Y2, B1 != B2.  

%Generamos la restricción de que no se repita la fila en valores
:- solucion(X,Y1,V,B1,F1), solucion(X,Y2,V,B2,F2), B1 != B2.
:- solucion(X1,Y,V,B1,F1), solucion(X2,Y,V,B2,F2), B1 != B2.

%Generamos la restricción de que los bloques no pueden separarse de su figura
% boxAdjacentToBox(B1, B2, F) :- solucion(X - 1, Y, V1, B1, F), solucion(X, Y, V2, B2, F).
% boxAdjacentToBox(B1, B2, F) :- solucion(X - 1, Y, V1, B1, F), solucion(X, Y, V2, B2, F).

% :- solucion(X1,Y1,V1,B1,F), solucion(X2,Y2,V2,B2,F), 
% bloque(B1,F,X_r,Y_r,V1), bloque(B2,F,X_r2,Y_r2,V2),
% X1 + Y_r2 != X2.

notCumpleModelo(X1,Y1, X2, Y2, F) :- solucion(X1,Y1,V1,B,F), solucion(X2,Y2,V2,B+1,F), not notCumpleModelo(X2,Y2,X1,Y1,F), 
bloque(B,F,X_r1,Y_r1,V1),bloque(B+1,F,X_r2,Y_r2,V2),
X1+X_r2-X_r1!=X2.

notCumpleModelo(X1,Y1, X2, Y2, F) :- solucion(X1,Y1,V1,B,F), solucion(X2,Y2,V2,B+1,F), not notCumpleModelo(X2,Y2,X1,Y1,F), 
bloque(B,F,X_r1,Y_r1,V1),bloque(B+1,F,X_r2,Y_r2,V2),
Y1+Y_r2-Y_r1!=Y2.
% notCumpleModelo(X1,Y1, X2, Y2, F) :- solucion(X1,Y1,V1,B,F), solucion(X2,Y2,V2,B+1,F), not notCumpleModelo(X2,Y2,X1,Y1,F), 
% bloque(B,F,X_r1,Y_r1,V1), bloque(B+1,F,X_r2,Y_r2,V2),
% X1-X2 != X_r1-X_r2, Y1-Y2 != Y_r1-Y_r2.

:- solucion(X1, Y1, V1, B1, F), solucion(X2,Y2,V2,B2,F), notCumpleModelo(X1,Y1,X2,Y2,F).

% #show solucion/5.
#show grid/2.
#show solucion/5.

% #show cumpleColumna/5.
% #show cumpleFila/5.


% #show boxAdjacentToBox/3.