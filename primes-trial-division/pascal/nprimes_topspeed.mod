MODULE nPrimes;

FROM IO IMPORT WrCard, WrLn;

CONST NumPrimes = 100;
(* CONST NumPrimes = 1000; *)
(* CONST NumPrimes = 10000; *)

VAR Count, Index, Found : CARDINAL;
    Primes : ARRAY [1..NumPrimes] OF CARDINAL;
    
BEGIN

	Found := 0;
	Count := 2;
	
	WHILE Found < NumPrimes DO
	
		INC(Found);
		Primes[Found] := Count;
		WrCard(Count, 6);
		WrLn;
		INC(Count);
		
		Index := 1;
		REPEAT
			IF Count MOD Primes[Index] = 0 THEN
				INC(Count);
				Index := 0;
			END;
			INC(Index);
		UNTIL Index > Found;
	
	END;
	
END nPrimes.

