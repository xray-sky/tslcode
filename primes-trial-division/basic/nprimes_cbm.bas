1 GOTO 10
5 C=C+1
6 GOTO 50
10 DIM P(99)
20 P(0)=2
25 PRINT P(0)
30 C=3
40 FOR F=1 TO 99
50 FOR I=0 TO (F-1)
60 V=C/P(I)
65 IF V=INT(V) GOTO 5
70 NEXT I
80 PRINT C
90 P(F)=C
100 C=C+1
110 NEXT F
120 END