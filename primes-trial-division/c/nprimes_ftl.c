/* n primes */

isprime(n, primes)
int n;
int *primes;
$(
  int i;

  i=0;
  while(primes[i] > 0) $(
    if(n % primes[i] == 0) $(
      return(0);
    $)
    i++;
  $)

  return(1);
$)

main()
$(
  int f, n, p, *primes;
  char arg[16];

  f=0;
  p=2;
  getdos(arg);
  n=atoi(arg+3);
  primes=highmem()-(n*2);
  clear(primes, n*2)
  while(f < n) $(
    if(isprime(p, primes)) $(
      primes[f] = p;
      printf("%d\n", p);
      f++;
    $)
    p++;
  $)

  return(0);
$)

