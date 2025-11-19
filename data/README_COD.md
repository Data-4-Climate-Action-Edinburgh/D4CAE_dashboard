# README - documentation of data from COD

Data was downloaded from the Cycling Open Data (COD) website, a usmart platform. 
https://usmart.io/org/cyclingscotland/

Slightly non-intuitive process: 
* Created a login. 
* Searched the COD datasets for 'Edinburgh', as the data from City of Edinburgh Council (CEC) is presented in its own datasets, some hourly, some daily. 
* Sent in the requests for the two datasets relevant to the current work, using the request access buttons, the City of Edinburgh daily walking counts and daily cycling counts respectively. These are both made available under an Open Govt Licence. 
* Once access confirmed, returned to the dataset page for the daily cycling. 
* Checked by filtering - all 215,000 records provided by CEC. 
* Clicked the dataset button to downloaded the CSV file, took under two minutes for the website to make the data ready. 
* Used the website download feature, top right-hand corner white download icon, then in the menu that opens, click blue download icon to actually get the file to download.  

Point to note: while the cycling and walking data are presented as totally separate datasets, on examining the columns in the two files, they have identical column headings (field names) and appear to be of the same data types. The files differ in the values in the column 'class' (class is "pedestrian" in the walking data, and "cyclist" in the cycling data). 

## WALKING: City of Edinburgh Council - Daily *WALKING* counts from automatic cycling counters
   
https://usmart.io/org/cyclingscotland/discovery/discovery-view-detail/fca2f5f0-6fdd-48cf-8325-778f1c4bb32a

### Description
A real-time daily upload from each pedestrian counter within City of Edinburgh Council's network
### Additional Information
The walking counts supplied is raw, uncleaned data. Extended counts of zero, or unusually high counts, may be due to a malfunctioning counter. Data consumers must decide whether counts are genuine and suitable for use. Managed by Paths for All.
### Themes
Transport / Mobility
### Point of Contact
Paths for All Data 
### Licence
Open Government Licence

The provider column in the data states "City of Edinburgh Council" for all rows. 

 1 Roseburn Path                           
 2 Cultins Road (Dial-Up CA)               
 3 Nicolson Street                         
 4 Inverleith Park                         
 5 Middle Meadow Walk (Dial-Up CA)         
 6 Fishwives Causeway                      
 7 A8 Corstorphine Road                    
 8 Raeburn Place                           
 9 Spylaw Park                             
10 Peffermill Road (Dial-Up CA)            
11 Inverleith Row                          
12 Shawfair                                
13 Wester Coates                           
14 Innocent Railway Bridge(Dial-Up CA)     
15 Mayfield Road Northbound                
16 Portobello Prom (Dial-Up CA)            
17 Straiton Path                           
18 Steadfast Gate                          
19 Blacket Avenue                          
20 A8 Wester Coates                        
21 Melville Drive Link                     
22 Little France ELGT                      
23 Crewe Road South                        
24 Silverknowes (Dial-Up CA)               
25 Portobello Promenade                    
26 Stenhouse Drive                         
27 Cramond Brigg                           
28 Dundee Street                           
29 Carrington Road Westbound               
30 North Edinburgh Access Road (Dial-Up CA)
31 Carrington Road Eastbound               
32 Hawkhill Avenue (Dial-Up CA)            
33 Seafield Street (Dial-Up CA)            
34 Dalry Road                              
35 Blackhall (Dial-Up CA)                  
36 Forth Road Bridge (Dial-Up CA)          
37 London Road                             
38 Harrison Park                           
39 Queensferry - Dalmeny (Dial-Up CA)      
40 RBS Gogar (Dial-Up CA)                  
41 Carrick Knowe Golf Course (Dial-Up CA)  
42 A90 Deans Bridge                        
43 Old Dalkeith Road                       
44 Union Canal - Wester Hailes             
45 Morrison Street                         
46 Water of Leith                          
47 Whitehouse Loan                         
48 Gilmerton Road                          
49 Melville Drive Main Path                
50 ELGT Little France South                
51 Gilmerton Station Road                  
52 Roseburn Park                           
53 Mayfield Road Southbound                
54 Melville Drive Northbound               
55 North Meadow Walk, Main Path            
56 Bruntsfield Place Northbound            
57 Melville Drive Southbound               
58 Bruntsfield Place Southbound            
59 North Meadow Walk, Link                 
60 Rodney Street Tunnel   


## CYCLING: City of Edinburgh Council - Daily cycling counts from automatic cycling counters

https://usmart.io/org/cyclingscotland/discovery/discovery-view-detail/b1f0bd42-e220-465e-99a3-c4f62824f21f 

### Description
A real-time daily upload from each cycling counter within City of Edinburgh Council's network.
### Additional Information
The cycling counts supplied is raw, uncleaned data. Extended counts of zero, or unusually high counts, may be due to a malfunctioning counter. Data consumers must decide whether counts are genuine and suitable for use.
### Themes
Transport / Mobility
### Point of Contact
Cycling Scotland Monitoring
### Licence
Open Government Licence

The sixty counters' locations are: 
> # Where are the counters? 
> unique(CEC_daily_cycling_COD_alldates[["location"]])
 [1] "Gilmerton Road"                           "Water of Leith"                          
 [3] "A8 Corstorphine Road"                     "Inverleith Row"                          
 [5] "Whitehouse Loan"                          "Carrington Road Eastbound"               
 [7] "Gilmerton Station Road"                   "Old Dalkeith Road"                       
 [9] "Dalry Road"                               "Dundee Street"                           
[11] "Shawfair"                                 "Portobello Promenade"                    
[13] "Raeburn Place"                            "Blacket Avenue"                          
[15] "A8 Wester Coates"                         "Little France ELGT"                      
[17] "London Road"                              "Nicolson Street"                         
[19] "A90 Deans Bridge"                         "Fishwives Causeway"                      
[21] "Carrington Road Westbound"                "Roseburn Path"                           
[23] "ELGT Little France South"                 "Crewe Road South"                        
[25] "North Meadow Walk, Link"                  "Morrison Street"                         
[27] "North Meadow Walk, Main Path"             "Rodney Street Tunnel"                    
[29] "Stenhouse Drive"                          "Roseburn Park"                           
[31] "Straiton Path"                            "Harrison Park"                           
[33] "Bruntsfield Place Northbound"             "Melville Drive Southbound"               
[35] "Mayfield Road Southbound"                 "Melville Drive Main Path"                
[37] "Melville Drive Link"                      "Mayfield Road Northbound"                
[39] "Bruntsfield Place Southbound"             "Melville Drive Northbound"               
[41] "Inverleith Park"                          "Peffermill Road (Dial-Up CA)"            
[43] "Steadfast Gate"                           "Hawkhill Avenue (Dial-Up CA)"            
[45] "Seafield Street (Dial-Up CA)"             "RBS Gogar (Dial-Up CA)"                  
[47] "Forth Road Bridge (Dial-Up CA)"           "Blackhall (Dial-Up CA)"                  
[49] "Silverknowes (Dial-Up CA)"                "Queensferry - Dalmeny (Dial-Up CA)"      
[51] "North Edinburgh Access Road (Dial-Up CA)" "Cultins Road (Dial-Up CA)"               
[53] "Middle Meadow Walk (Dial-Up CA)"          "Spylaw Park"                             
[55] "Cramond Brigg"                            "Carrick Knowe Golf Course (Dial-Up CA)"  
[57] "Innocent Railway Bridge(Dial-Up CA)"      "Union Canal - Wester Hailes"             
[59] "Portobello Prom (Dial-Up CA)"             "Wester Coates"   
