       IDENTIFICATION DIVISION.
       PROGRAM-ID.  NOTBOOL.
       DATA DIVISION. 
       WORKING-STORAGE SECTION. 
       01  FILLER.
           05  THE-ANSWER                     PIC X(40).


           05  EX2-FLAG                 PIC X VALUE SPACE.
           05  EX2-TRUE-VALUE           PIC X VALUE 'T'.

           05  EX3-FLAG                 PIC X VALUE 'N'.
           05  EX3-YES-VALUE            PIC X VALUE 'Y'.

           05  EX4-FLAG                  PIC X VALUE '1'.
           05  EX4-TRUE-VALUE            PIC X VALUE '1'.
           05  EX4-FALSE-VALUE           PIC X VALUE '0'.

           05  EX5-FIELD                 PIC X. 
               88  EX5-FLAG              VALUE 'T'. 

           05  FILLER                    PIC X. 
               88  EX6-FLAG              VALUE 'T', FALSE 'F'. 

           05  EX7-FLAG                  PIC S9 COMP-3 VALUE -1.
           05  EX7-TRUE                  PIC S9 COMP-3 VALUE 1.
           05  EX7-FALSE                 PIC S9 COMP-3 VALUE -1. 

       PROCEDURE DIVISION.




           MOVE EX2-TRUE-VALUE TO EX2-FLAG 

           IF EX2-FLAG EQUAL EX2-TRUE-VALUE 
               MOVE 'true' TO THE-ANSWER 
           ELSE 
               MOVE 'false' TO THE-ANSWER 
           END-IF         

           IF EX2-FLAG EQUAL EX2-TRUE-VALUE 
               MOVE SPACE TO EX2-FLAG 
           ELSE  
               MOVE EX2-TRUE-VALUE TO EX2-FLAG 
           END-IF         


           MOVE EX3-YES-VALUE TO EX3-FLAG 

           IF EX3-FLAG EQUAL EX3-YES-VALUE 
               MOVE 'yes' TO THE-ANSWER 
           ELSE 
               MOVE 'no' TO THE-ANSWER 
           END-IF         


           if ex3-flag not equal ex3-yes-value 
               move 'no' to the-answer.

           IF EX3-FLAG EQUAL EX3-YES-VALUE 
               MOVE 'N' TO EX3-FLAG 
           ELSE          
               MOVE EX3-YES-VALUE TO EX3-FLAG 
           END-IF 


           MOVE EX4-TRUE-VALUE TO EX4-FLAG 

           EVALUATE TRUE
               WHEN EX4-FLAG EQUAL EX4-TRUE-VALUE
                  MOVE 'true' TO THE-ANSWER 
               WHEN EX4-FLAG EQUAL EX4-FALSE-VALUE   
                  MOVE 'false' TO THE-ANSWER  
               WHEN OTHER
                  MOVE 'not set' TO THE-ANSWER
           END-EVALUATE

           IF EX4-FLAG EQUAL EX4-TRUE-VALUE 
               MOVE EX4-FALSE-VALUE TO EX4-FLAG 
           ELSE 
               MOVE EX4-TRUE-VALUE TO EX4-FLAG 
           END-IF 


           SET EX5-FLAG TO TRUE 

           if Ex5-Flag 
               move 'true' to The-Answer 
           end-if    
      
           IF EX5-FLAG  
               MOVE SPACE TO EX5-FIELD 
           ELSE     
               SET EX5-FLAG TO TRUE
           END-IF 


           SET EX6-FLAG TO TRUE 

           if Ex6-Flag 
               move 'true' to The-Answer 
           end-if    
      
           IF EX6-FLAG  
               SET EX6-FLAG TO FALSE 
           ELSE     
               SET EX5-FLAG TO TRUE
           END-IF 


           MOVE EX7-TRUE TO EX7-FLAG 

           if EX7-FLAG EQUAL EX7-TRUE 
               MOVE 'true' TO THE-ANSWER 
           END-IF     
      
           COMPUTE EX7-FLAG = EX7-FLAG * -EX7-FLAG

           GOBACK
           .
