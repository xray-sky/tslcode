PROCEDURE primes
      DIM v,count,found,index,prime(100):INTEGER

      count := 2
      found := 0
      
      WHILE found < 100 DO
        found := found + 1
        PRINT count
        prime(found) := count
  10    count := count + 1
        index := 1
        REPEAT
          v := MOD(count,prime(index))
          index := index + 1
        UNTIL v = 0 OR index > found
        IF v = 0 THEN 10
      ENDWHILE
END
