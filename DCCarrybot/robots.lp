% Tiempo desde 1 hasta bound
time(1..bound).

% Acciones disponibles para el robot
action(up).
action(down).
action(left).
action(right).
action(wait).
action(liftBox).
action(rotateLeft).
action(rotateRight).

% Un robot puede desplazarse en las direcciones de: arriba, abajo, izquierda, derecha y esperar
robotOn(R, X, Y - 1, T + 1, D, E - 1) :- exec(R, up, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 1.
robotOn(R, X, Y + 1, T + 1, D, E - 1) :- exec(R, down, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 2.
robotOn(R, X - 1, Y, T + 1, D, E - 1) :- exec(R, left, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 3.
robotOn(R, X + 1, Y, T + 1, D, E - 1) :- exec(R, right, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 4.
robotOn(R, X, Y, T + 1, D, E) :- exec(R, wait, T), robotOn(R, X, Y, T, D, E), time(T + 1).

% Sistema de rotaciones a la izquierda
robotOn(R, X, Y, T + 1, 3, E - 1) :- exec(R, rotateLeft, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 1.
robotOn(R, X, Y, T + 1, 4, E - 1) :- exec(R, rotateLeft, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 2.
robotOn(R, X, Y, T + 1, 2, E - 1) :- exec(R, rotateLeft, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 3.
robotOn(R, X, Y, T + 1, 1, E - 1) :- exec(R, rotateLeft, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 4.
% Sistema de rotaciones a la derecha
robotOn(R, X, Y, T + 1, 4, E - 1) :- exec(R, rotateRight, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 1.
robotOn(R, X, Y, T + 1, 3, E - 1) :- exec(R, rotateRight, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 2.
robotOn(R, X, Y, T + 1, 1, E - 1) :- exec(R, rotateRight, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 3.
robotOn(R, X, Y, T + 1, 2, E - 1) :- exec(R, rotateRight, T), robotOn(R, X, Y, T, D, E), time(T + 1), D = 4.

% La caja pasa a estar en la posición del robot, levantada y este último mantiene su localización. Se indica que hay una caja encima del robot.
3{boxOn(B, X - 1, Y, 1, T + 1); robotOn(R, X - 1, Y, T + 1, D, E - 1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X - 1, Y, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0. 
3{boxOn(B, X + 1, Y, 1, T + 1); robotOn(R, X + 1, Y, T + 1, D, E - 1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X + 1, Y, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0.
3{boxOn(B, X, Y - 1, 1, T + 1); robotOn(R, X, Y - 1, T + 1, D, E - 1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X, Y - 1, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0. 
3{boxOn(B, X, Y + 1, 1, T + 1); robotOn(R, X, Y + 1, T + 1, D, E - 1); boxOnRobot(B, R, T + 1)}3 :- robotLiftBox(R, B, T), robotOn(R, X, Y + 1, T, D, E), time(T + 1), boxOn(B, X, Y, Z, T), robot(R), Z = 0. 

% Si hay una caja encima de un robot, hay una caja recogida. Si no está recogida la caja está en el piso
boxPickedUp(B, T) :- boxOnRobot(B, R, T). 
boxOn(B, X, Y, 0, T + 1) :- boxOn(B, X, Y, Z, T), Z = 0, not boxPickedUp(B, T + 1), time(T + 1), box(B).

% Si el robot se mueve, la caja también.
boxOn(B, X, Y, 1, T) :- robotOn(R, X, Y, T, D, E), boxOnRobot(B, R, T), time(T).
boxOnRobot(B, R, T + 1) :- boxOnRobot(B, R, T), time(T + 1).

% Un robot es capaz de levantar una caja, únicamente si está adyacente a él y además si está mirándola. Se define que es que esté adyacente.
% Caja a la derecha
boxAdjacentToRobot(B, R, T) :- robotOn(R, X - 1, Y, T, D, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0, D = 4.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X - 1, Y, 0, D, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0, D = 4.
% Caja a la izquierda
boxAdjacentToRobot(B, R, T) :- robotOn(R, X + 1, Y, T, D, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0, D = 3.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X + 1, Y, 0, D, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0, D = 3.
% Caja abajo
boxAdjacentToRobot(B, R, T) :- robotOn(R, X, Y - 1, T, D, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0, D = 2.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X, Y - 1, 0, D, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0, D = 2.
% Caja arriba
boxAdjacentToRobot(B, R, T) :- robotOn(R, X, Y + 1, T, D, E), boxOn(B, X, Y, Z, T), robot(R), time(T), box(B), Z = 0, D = 1.
boxAdjacentToRobot(B, R, 0) :- robotOn(R, X, Y + 1, 0, D, E), boxOn(B, X, Y, Z, 0), robot(R), box(B), Z = 0, D = 1.

% Cantidad de cajas adyacentes
boxesAdjactentToRobot(R, T, N) :- robot(R), N = #count{B : boxAdjacentToRobot(B, R, T)}, time(T).
boxesAdjactentToRobot(R, 0, N) :- robot(R), N = #count{B : boxAdjacentToRobot(B, R, 0)}.

% Un robot ejecuta una acción en cada tiempo.
1 {exec(R, A, T) : action(A)} 1 :- robot(R), time(T + 1).

% Se levanta la caja
1{robotLiftBox(R, B, T): boxAdjacentToRobot(B, R, T)}1 :- exec(R, liftBox, T), time(T + 1), robot(R).

% No se puede levantar la caja si el robot no esta adyacente
:- robotLiftBox(R, B, T), boxesAdjactentToRobot(R, T, N), N = 0.

% Un robot no puede llevar más de una caja al mismo tiempo
:- robotLiftBox(R1, B, T), robotLiftBox(R2, B, T), R1 != R2. 

% Una caja puede ser llevada por un único robot.
:- boxOnRobot(B1, R, T), boxOnRobot(B2, R, T), B1 != B2.

% Se evitan acciones innecesarias si el robot llega a la meta.
% :- exec(R, A, T), goal(X,Y), robotOn(R,X,Y,T,D,E), A != wait.

% Un robot no estar encima por un obstáculo, o afuera del mapa, al igual que la caja.
:- robotOn(R, X, Y, T, D, E), not rangeX(X).
:- robotOn(R, X, Y, T, D, E), not rangeY(Y).
:- boxOn(B, X, Y, Z, T), not rangeX(X).
:- boxOn(B, X, Y, Z, T), not rangeY(Y).
:- robotOn(R, X, Y, T, D, E), obstacle(X, Y).
:- boxOn(B, X, Y, Z, T), obstacle(X, Y).

% No puede haber más de un robot en la misma casilla y más de una caja en la misma casilla.
:- robotOn(R1, X, Y, T, D1, E1), robotOn(R2, X, Y, T, D2, E2), R1 != R2.
:- boxOn(B1, X, Y, Z, T), boxOn(B2, X, Y, Z, T), B1 != B2, Z = 0.

% No se pueden cruzar robots. No puede estar un robot y una caja sin levantar en la misma casilla.
:- robotOn(R1, X, Y, T, D1, E1), robotOn(R2, X + 1, Y, T, D2, E2), robotOn(R2, X, Y, T + 1, D2, E2), robotOn(R1, X + 1, Y, T + 1, D1, E1).
:- robotOn(R1, X, Y, T, D1, E1), robotOn(R2, X, Y + 1, T, D2, E2), robotOn(R2, X, Y, T + 1, D2, E2), robotOn(R1, X, Y + 1, T + 1, D1, E1).
:- robotOn(R, X, Y, T, D, E), boxOn(B, X, Y, Z, T), Z = 0, box(B), time(T).

%No pueden haber robots con energia negativa.
:- robotOn(R, X, Y, T, D, E), E < 0.

% Caja esta en un objetivo en el tiempo T.
at_goal(B, T) :- boxOn(B, X, Y, Z, T), goal(X, Y).
:- box(B), not at_goal(B, bound).

% --------------------- Visualizador -----------------------------------

% Mediante la siguiente línea de comandos se ejecutará el programa original con un test antiguo
% Si python3 no funciona, reemplazar por python
% clingo robots.lp tests/old.lp -c bound=14 | python3 process.py

% El resto de los tests deberán ser probados mediante la línea (con N el número máximo de pasos para resolver el problema)
% clingo FILENAME.lp tests/TESTNAME.lp -c bound=N | python3 process.py

% ------------------------- #show --------------------------------------

#show time/1.
#show robotOn/6.
#show boxOn/5.
#show obstacle/2.
#show rangeX/1.
#show rangeY/1.
#show goal/2.
