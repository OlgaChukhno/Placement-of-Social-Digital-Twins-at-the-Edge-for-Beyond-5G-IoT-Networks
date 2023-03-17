/*********************************************
 * Author: olga Chukhno
 *********************************************/
 
// Number of Servers
int nbServers = ...;
range Servers = 1..nbServers;

// Number of SVES
int nbSVES = ...;
range SVES = 1..nbSVES;
range SVES2 = 1..nbSVES-1;

// Number of Slots
int nbSlots = ...;
range Slots = 1..nbSlots;

// Number of Device Types
int nbTypes = ...;
range Types_D = 1..nbTypes;

float Lmax[SVES] = ...; // maximum latency for every device
float aCPU = ...; //CPU capability 
float aD = ...; //DISK capability 
float aRAM = ...; //RAM capability 
float thrCPU = ...; //CPU threshold
float thrD = ...; //DISK threshold
float thrRAM = ...; //RAM threshold
float CPU[SVES]= ...; //CPU requirement 
float D[SVES]= ...; //DISK requirement  
float RAM[SVES]= ...; //RAM requirement 

float DistCost[Slots][SVES][Servers] = ...; // Distances between devices and edge servers
float DistSoc[SVES][SVES] = ...; //social connections
float DistSoc_OOR[SVES][SVES] = ...; //social connections OOR
float DistSoc_POR[SVES][SVES] = ...; //social connections POR
float DistSoc_LOR[SVES][SVES] = ...; //social connections LOR
float DistSoc_SOR[SVES][SVES] = ...; //social connections SOR

float  DistServ[Servers][Servers] = ...; // Distances among edge servers


dvar boolean Assign[Slots][SVES][Servers]; // bynary variables

dvar boolean Assign2[Slots][SVES][Servers][SVES][Servers]; // bynary variables


dexpr float Total1Cost[t in Slots] =  sum(w in Servers , s in SVES) Assign[t][s][w] * DistCost[t][s][w];
dexpr float Total2Cost[t in Slots] = sum(w in Servers , v in Servers, s in SVES2, r in SVES:r>s)  Assign2[t][s][w][r][v] *( DistSoc[s][r] * DistServ[w][v]+DistSoc[r][s] * DistServ[v][w]); 


 execute CPX_PARAM{
  cplex.tilim =4000;
  //cplex.lbheur =true;
 // cplex.rinsheur=10;
  //cplex.nodefileind = 3;
} 

minimize sum (t in Slots) (Total1Cost[t] + Total2Cost[t]); //optimization function

subject to{
  //number of SVES (only 1)
   forall(t in Slots, s in SVES ) sum( w in  Servers ) 
        Assign[t][s][w] == 1;  //Allocation constraint
//Distance from Server to psysical device  
  forall(t in Slots, w in Servers, s in SVES) 
        Assign[t][s][w]* DistCost[t][s][w] <= Lmax[s]; // Latency constraint
//number of SVES per Server (no more that Capacity of Server)
forall( t in Slots, w in Servers ) sum( s in SVES ) 
        Assign[t][s][w]*CPU[s]/aCPU<= thrCPU;  //Resource utilization constraint CPU
 forall( t in Slots, w in Servers ) sum( s in SVES ) 
        Assign[t][s][w]*D[s]/aD<= thrD;         //Resource utilization constraint DISK
 forall( t in Slots, w in Servers ) sum( s in SVES ) 
        Assign[t][s][w]*RAM[s]/aRAM<= thrRAM;  //Resource utilization constraint RAM
//aditional                    
forall(t in Slots,w in Servers, s in SVES2, r in SVES:r>s) sum( v in  Servers ) 
        Assign2[t][s][w][r][v]== Assign[t][s][w];
 forall(t in Slots, v in Servers, s in SVES2, r in SVES:r>s) sum( w in  Servers ) 
        Assign2[t][s][w][r][v] == Assign[t][r][v];     
}

{int} SVEof[t in Slots, w in Servers] = { s | s in SVES : Assign[t][s][w] == 1 };
execute DISPLAY_RESULTS{
  	writeln("SVEof=",SVEof);
    writeln("Total1Cost=",Total1Cost);
    writeln("Total2Cost=",Total2Cost);
   	 	    
}

/***
main {
    var mod = thisOplModel.modelDefinition;
    var dat = thisOplModel.dataElements;
    for (var size=10; size<=110; size+=10){
        var MyCplex = new IloCplex();
        var opl = new IloOplModel(mod,MyCplex);
        dat.nbSVES=size;
        opl.addDataSource(dat);  
        opl.generate();
        if (MyCplex.solve()){
           writeln("solution: ",MyCplex.getObjValue(),
           "/ size: ", size,
           " / time: ",MyCplex.getCplexTime());
        }  
        opl.end();
        MyCplex.end();    
    }
}
//*********************************************/
