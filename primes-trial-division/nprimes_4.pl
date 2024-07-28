$n = shift;
$count = 2;
while (scalar(@primes) < $n) {
	print("$count\n");
	push(@primes, $count);
	$count++;
	for ( $i = 0 ; $i < scalar(@primes) ; $i++ ) {
		if ($count % $primes[$i] == 0) {
			$count++;
			$i = 0;
			redo;
		}	
	}
}
