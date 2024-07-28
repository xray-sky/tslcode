// n Primes

import java.util.ArrayList;
import java.util.Iterator;

public class nPrimes {
  public static void main (String[] args) {
    int count = 2;
    int numPrimes = Integer.parseInt(args[0]);
    ArrayList primes = new ArrayList(1);

    do {
      primes.add(new Integer(count));
      count++;
      for (int i = 0; i < primes.size(); i++) {
        if (count % ((Integer)primes.get(i)).intValue() == 0) {
          count++;
          i=-1;
        }
      }
    } while (primes.size() < numPrimes);

    Iterator i = primes.iterator();
    while(i.hasNext()) {
      System.out.println(i.next());
    }
  }
}

