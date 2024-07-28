use strict;
use vars qw(@primes);

my $n = shift;
my $count = 2;
while (scalar(@primes) < $n) {
	print("$count\n");
	push(@primes, $count);
	$count++;
	for ( my $i = 0 ; $i < scalar(@primes) ; $i++ ) {
		if ($count % $primes[$i] == 0) {
			$count++;
			$i = 0;
			redo;
		}	
	}
}
