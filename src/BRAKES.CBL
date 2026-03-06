       IDENTIFICATION DIVISION.
       PROGRAM-ID.  BRAKES.
       DATA DIVISION. 
       WORKING-STORAGE SECTION. 
       01  GIVEN-VALUES.
           05  m                           COMP-2 VALUE 100. 
           05  sh                          COMP-2 VALUE 800.
           05  w                           COMP-2 VALUE 10000.
           05  d                           COMP-2 VALUE 75.0.
           05  a                           COMP-2 VALUE 9.8.     

       01  CALCULATED-VALUES.
           05  Mgh                         COMP-2.
           05  deltaT-Celsius              COMP-2.
           05  mc                          COMP-2.     
           05  deltaT-Celsius-Formatted    PIC Z,ZZ9.99.     

       PROCEDURE DIVISION.


           COMPUTE Mgh =  w * a * d


           COMPUTE mc = m * sh     
           COMPUTE deltaT-Celsius = 
               Mgh / mc 
           END-COMPUTE     

           MOVE deltaT-Celsius TO deltaT-Celsius-Formatted
           DISPLAY 'deltaT-Celsius: ' deltaT-Celsius-Formatted    

           GOBACK
           .
