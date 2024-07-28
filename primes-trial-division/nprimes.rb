module Benchmark

  def self.primes(n)
    primes = [2]
    count = 3
    begin
      primes.push(count) if primes.each do |prime|
        break if count%prime == 0
        prime
      end
      count += 1
    end until primes.length == n
    primes
  end

end

puts Benchmark.primes(ARGV[0].to_i)

