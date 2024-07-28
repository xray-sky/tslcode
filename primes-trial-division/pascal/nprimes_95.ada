with Ada.Text_IO; use Ada.Text_IO;
-- with Text_IO; use Text_IO;

procedure nPrimes is

--	NumPrimes : constant Integer := 100;
--	NumPrimes : constant Integer := 1000;
	NumPrimes : constant Integer := 10000;
	Index : Integer;
	Found : Integer := 0;
	Count : Integer := 2;
	Primes : array (1 .. NumPrimes) of Integer;
    
begin
	
	while Found < NumPrimes loop
	
		Found := Found + 1;
		Primes(Found) := Count;
		Put_Line(Integer'Image(Count));
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
