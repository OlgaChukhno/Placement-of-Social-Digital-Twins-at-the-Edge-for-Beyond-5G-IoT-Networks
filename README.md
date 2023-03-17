# Placement-of-Social-Digital-Twins-at-the-Edge-for-Beyond-5G-IoT-Networks
# optimal_SDT_placement

Simulation codes an optimal solution for the social-aware placement of IoT digital twins (DTs) at the network edge


The optimization problem is implemented using IBM ILOG CPLEX Optimization Studio 12.10.0 software suite.
For more details, see IBM ILOG CPLEX Optimization Studio Documentation (2021): https://www.ibm.com/support/knowledgecenter/SSSA5P_12.10.0/COS_KC_home.html
IBM ILOG CPLEX Optimization Studio, Version 12.10.0. (2021): http://www.ilog.com/products/cplex

The model can be called from external programs (https://www.linkedin.com/pulse/how-opl-alex-fleischer/).
For instance, from matlab it can be done as follows: 

command = 'oplrun modelOPL.mod data.dat';
[status, cmdout] = system(command); 

where the model is the name of the model file (i.e., SDT_model.mod), while data is the name od the data file (i.e., SDT_expample.dat)

Data can also be triggered from external files, e.g., from excel shits as follows":
SheetConnection sheet("data.xls");


nbServers= - number of edge servers;
nbSVES - number of DTs of IoT devices;
nbSlots- number of time slots;
aCPU - cpu capability;
aD - disk capability;
aRAM - RAM capability;
thrCPU - thr cpu;
thrD - thr disk;
thrRAM - thr ram;
nbTypes - number of device types;

DistCost[Slots][SVES][Servers] = ...; // Distances between devices and edge servers
DistSoc[SVES][SVES] = ...; //social connections
DistSoc_OOR[SVES][SVES] = ...; //social connections OOR
DistSoc_POR[SVES][SVES] = ...; //social connections POR
DistSoc_LOR[SVES][SVES] = ...; //social connections LOR
DistSoc_SOR[SVES][SVES] = ...; //social connections SOR
DistServ[Servers][Servers] = ...; // Distances among edge servers
