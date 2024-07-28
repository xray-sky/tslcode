// n Primes

import java.util.Arrays;
import java.util.ArrayList;

public class nPrimes {
  public static void main (String[] args) {
    Integer count = 2;
    Integer numPrimes = Integer.parseInt(args[0]);
    ArrayList<Integer> primes = new ArrayList<Integer>(1);

    do {
      primes.add(count);
      count++;
      for (int i = 0; i < primes.size(); i++) {
        if (count % primes.get(i) == 0) {
          count++;
          i=-1;
        }
      }
    } while (primes.size() < numPrimes);

    System.out.println(Arrays.toString(primes.toArray()));
  }
}

