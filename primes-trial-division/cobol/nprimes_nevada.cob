     IDENTIFICATION DIVISION.
     PROGRAM-ID.   NPRIMES.
     AUTHOR.       BEAR.
     DATE-WRITTEN. JANUARY 30, 2018.

     ENVIRONMENT DIVISION.
     CONFIGURATION SECTION.
     SOURCE-COMPUTER. 8080-CPU.
     OBJECT-COMPUTER. 8080-CPU.
     
     DATA DIVISION.
     WORKING-STORAGE SECTION.
     01  WS-NUM   PIC 9(4) USAGE IS COMP VALUE 100.
    *01  WS-NUM   PIC 9(4) USAGE IS COMP VALUE 1000.
     01  WS-FOUND PIC 9(4) USAGE IS COMP VALUE ZERO.
     01  WS-COUNT PIC 9(4) USAGE IS DISPLAY VALUE 2.
     01  WS-DIV   PIC 9(4) USAGE IS COMP.
     01  WS-REM   PIC 9(4) USAGE IS COMP.
     01  WS-PRIMES USAGE IS COMP.
         05  WS-PRIME PIC 9(4) OCCURS 100 TIMES.
    *    05  WS-PRIME PIC 9(4) OCCURS 1000 TIMES.
     01  SUBSCRIPTS USAGE IS COMP.
         05  I PIC 9(4) VALUE 1.

     PROCEDURE DIVISION.
     A000-MAIN.
         PERFORM C000-ISPRIME.
         PERFORM B000-CHECKPRIME THRU C000-ISPRIME 
           UNTIL WS-FOUND IS EQUAL TO WS-NUM.
         STOP RUN.

     B000-CHECKPRIME.
         PERFORM D000-DIVIDES UNTIL I IS GREATER THAN WS-FOUND.

     C000-ISPRIME.
         ADD 1 TO WS-FOUND.
         DISPLAY WS-COUNT.
         MOVE WS-COUNT TO WS-PRIME (WS-FOUND).
         ADD 1 TO WS-COUNT.
         MOVE 1 TO I.

     D000-DIVIDES.
         PERFORM R000-REMAINDER.
         IF WS-REM IS EQUAL TO ZERO PERFORM D001-NEXTNUM 
           ELSE ADD 1 TO I.

     D001-NEXTNUM.
         ADD 1 TO WS-COUNT.
         MOVE 1 TO I.

     R000-REMAINDER.
         DIVIDE WS-PRIME (I) INTO WS-COUNT GIVING WS-DIV.
         MULTIPLY WS-DIV BY WS-PRIME (I) GIVING WS-DIV.
         SUBTRACT WS-DIV FROM WS-COUNT GIVING WS-REM.
