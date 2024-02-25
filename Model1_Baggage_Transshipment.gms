$Ontext
Optimizing Baggage Transportation from Terminal Gates to Baggage Claim Area with Consideration for Inspection Centers
$Offtext

Option optcr = 0.00;

*This command serves to include a list of options for the CPLEX optimisation package
File fcpx Cplex OPTION FILE /cplex.opt/;

Sets
i Terminal Gates               /G1,G2,G3,G4,G5/
j Baggage bays        /B1,B2,B3/
l Inspection centres     /I1,I2/
;

Parameter a(i) Baggage capacity at gates 
/
G1      484
G2      270
G3      334
G4      176
G5      528
/
;

Parameter b(j) capacity baggage bays can handle
/
B1   650
B2   600
B3   700
/
;

         
Table distance_a(i,l) distance in miles between gates i and inspection centres l
           I1         I2    
G1         2590.89    2400.35
G2         2350.93    2450.47
G3         2300.13    2350.05
G4         2210.41    2100.45
G5         2280.90    2400.70
;

Table distance_b(l,j) distance (lenght of conveyor belt) from inspection centre l to baggage bays j

            B1  B2  B3
I1          100 90  95
I2          85  95  90

;
       
Scalar vehicle_cost per meter cost in pounds from gates to inspection centre /0.0018/;
Scalar speed conveyor belt speed from inspection centre to baggage bay /1.12/;
Scalar belt_cost conveyor belt operational cost(inspection centre to baggage bay) /0.0033/;

Parameter c_a(i,l) cost between gates i and inspection centres l;
c_a(i,l) = distance_a(i,l)*vehicle_cost;

Parameter c_b(l,j) cost between inspection centres l and baggage bay j;
c_b(l,j) = (distance_b(l,j)*belt_cost)/speed;   


Variables
z      total cost
x(*,*) Number of bags being transferred between two points
Positive variables x;
* Notice that we will have x(i,l) between Terminal Gates and Inspection Center
* and x(l,j) between Inspection Center and Baggage Claim Area

Equations
of       objective function 
constr1  capacity constraint
constr2  demand constraint
constr3  conservation flow (Inspection Centers)
;

of..  z =e= sum((i,l), c_a(i,l)*x(i,l)) + sum((l,j), c_b(l,j)*x(l,j));

constr1(i)..  sum(l, x(i,l))  =g= a(i);
constr2(j)..  sum(l, x(l,j))  =l= b(j);
constr3(l)..  sum(i, x(i,l))  =e= sum(j, x(l,j));

Model BaggageTransshipment /of,constr1,constr2,constr3/;

Solve BaggageTransshipment using LP minimizing z;
Display x.l, x.m;
