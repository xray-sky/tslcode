PROGRAM nPrimes;

(* CONST NumPrimes = 100; *)
CONST NumPrimes = 1000;
(* CONST NumPrimes = 10000; *)


VAR TTYout : TEXT;
    Count, Index, Found : INTEGER;
    Primes : ARRAY [1..NumPrimes] OF INTEGER;
    
BEGIN

	TermOut(TTYout);

	Found := 0;
	Count := 2;
	
	WHILE Found < NumPrimes DO
	BEGIN

		Found := Found + 1;
		Primes[Found] := Count;
		WriteLn(TTYout, Count);
		Count := Count + 1;
		
		Index := 1;
		REPEAT
			IF Count MOD Primes[Index] = 0 THEN
			BEGIN
				Count := Count + 1;
				Index := 0;
			END;
			Index := Index + 1;
		UNTIL Index > Found;
	
	END;
	
END.

