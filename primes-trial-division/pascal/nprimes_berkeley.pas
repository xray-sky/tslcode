program nPrimes (output);

(* const NumPrimes = 100; *)
const NumPrimes = 1000;
(* const NumPrimes = 10000; *)

var Count, Index, Found : integer;
    Primes : array [1..NumPrimes] of integer;
    
begin

	Found := 0;
	Count := 2;
	
	while Found < NumPrimes do
	begin

		Found := Found + 1;
		Primes[Found] := Count;
		writeln(Count);
		Count := Count + 1;
		
		Index := 1;
		repeat
			if Count mod Primes[Index] = 0 then
			begin
				Count := Count + 1;
				Index := 0;
			end;
			Index := Index + 1;
		until Index > Found;
	
	end;
	
end.
