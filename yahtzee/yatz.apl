  ∇ SCORE←YATZ;B;BOX;C;EMPTY;HEADER;REROLL;TURN;SCORES;Y
[1]   BOX←13 3⍴'1  2  3  4  5  6  3K 4K FH SS LS Y  C  '
[2]   SCORES←13⍴0
[3]   EMPTY←1+SCORES
[4]   HEADER←2 9⍴'1 2 3 4 5- - - - -'
[5]  PLAY:TURN←1
[6]   Y←REROLL←⍳5
[7]  NEXT:Y[REROLL]←?(⍴REROLL)⍴6
[8]   Y←Y[⍋Y]
[9]   →(TURN>2)/RECORD
[10]  ⎕←'TURN ',⍕TURN
[11]  ⎕←HEADER
[12]  ⎕←Y
[13] REDO:REROLL←⎕
[14]  →(0<+/5<REROLL)/REDO
[15]  →(1>+/REROLL)/RECORD
[16]  TURN←TURN+1
[17]  →NEXT
[18] RECORD:⎕←'SCORES:'
[19]  ⎕←' ',,BOX
[20]  ⎕←3 0⍕SCORES
[21]  ⎕←'SCORE ',(⍕Y),' AS: (',(⍕,EMPTY⌿BOX),')'
[22]  B←⍞
[23]  →('X'=B)/0
[24]  B←(BOX∧.=3↑B)⍳1
[25]  →(B>13)/RECORD
[26]  →(0=EMPTY[B])/RECORD
[27]  C←+⌿Y∘.=⍳6
[28]  →(TOP,TK,FK,FH,SS,LS,YA,CH)[⌈/1,B-5]
[29] TOP:SCORES[B]←B×C[B]
[30]  →CONT
[31] TK:SCORES[B]←(+/Y)×2<⌈/C
[32]  →CONT
[33] FK:SCORES[B]←(+/Y)×3<⌈/C
[34]  →CONT
[35] FH:SCORES[B]←25×7>⌈/C⍳2 3
[36]  →CONT
[37] SS:SCORES[B]←30×3<⌈/((1-⍳3)⌽3 6⍴(5>⍳6))+.×0<C
[38]  →CONT
[39] LS:SCORES[B]←40×4<⌈/((1-⍳2)⌽2 6⍴(6>⍳6))+.×C
[40]  →CONT
[41] YA:SCORES[B]←50×1=+/4<C
[42]  →CONT
[43] CH:SCORES[B]←+/Y
[44] CONT:EMPTY[B]←0
[45]  ⎕←'SCORED ',(⍕SCORES[B]),' IN ',⍕BOX[B;]
[46]  →(1∊EMPTY)/PLAY
[47]  SCORE←(+/SCORES)+35×62<+/SCORES[⍳6]
[48]  ⎕←'FINAL SCORE: ',⍕SCORE
    ∇
