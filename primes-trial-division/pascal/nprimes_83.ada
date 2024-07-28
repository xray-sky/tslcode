with Ada_IO; use Ada_IO;

procedure nPrimes is

	NumPrimes : constant Integer := 100;
--	NumPrimes : constant Integer := 1000;
--	NumPrimes : constant Integer := 10000;
	Index : Integer;
	Found : Integer := 0;
	Count : Integer := 2;
	Primes : array (1 .. NumPrimes) of Integer;
    
begin
	
	while Found < NumPrimes loop
	
		Found := Found + 1;
		Primes(Found) := Count;
		put(Count);
		new_line;
		Count := Count + 1;
		
		Index := 1;
		loop
			exit when Index > Found;
			if Count mod Primes(Index) = 0 then
				Count := Count + 1;
				Index := 1;
			else
				Index := Index + 1;
			end if;
		end loop;
	
	end loop;
	
end nPrimes;

