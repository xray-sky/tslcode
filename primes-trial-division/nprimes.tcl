set n $argv;
set found 0;
set count 2;

while {$found < $n} {

  set index 0;
  while {$index < $found} {
    if {$count % $primes($index) == 0} {
      set index 0;
      set count [expr {$count + 1}];
    } else {
      set index [expr {$index + 1}];
    }
  }

  puts $count;
  set primes($found) $count;
  set count [expr {$count + 1}];
  set found [expr {$found + 1}];

}

