// n Primes

public class nPrimes {
  public static void main (String[] args) {
    int found = 0;
    int numPrimes = Integer.parseInt(args[0]);

    long count = 2;
    long[] primes = new long[numPrimes];

    do {
      System.out.println(count);
      primes[found] = count;
      count++;
      for (int i = 0; i < found; i++) {
        if (count % primes[i] == 0) {
          count++;
          i=-1;
        }
      }
      found++;
    } while (found < numPrimes);
  }
}

