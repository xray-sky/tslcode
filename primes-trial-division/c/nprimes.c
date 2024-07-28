/* n primes */

#include <stdio.h>
#ifndef _XCALLOC
#include <malloc.h>
#else
extern char* calloc();
#endif

#ifndef _V7
#define FORMAT "%lu\n"
#else
#define FORMAT "%D\n"
#endif

#ifdef _ANSI
unsigned int patoi(char *str) {
#else
unsigned int patoi(str)
char *str;
{
#endif
	int i; unsigned int res;
	i=0; res=0;

	while(str[i] != 0) {
		res=((res*10) + (str[i]-'0'));
		i++;
	}

	return(res);
}

#ifdef _ANSI
int isprime(unsigned long n, unsigned long *primes) {
#else
int isprime(n, primes)
unsigned long n; unsigned long *primes;
{
#endif
	int i; i=0;

	while(primes[i] > 0) {
		if(n % primes[i] == 0) {
			return(0);
		}
		i++;
	}

	return(1);
}

#ifdef _ANSI
int main(int argc, char *argv[]) {
#else
int main(argc, argv)
int argc; char **argv;
{
#endif
	unsigned int found, n;
	unsigned long count, *primes;

	found=0; count=2;
	n=patoi(argv[1]);
	primes=(unsigned long*)calloc(n, sizeof(long));

	while(found < n) {
		if(isprime(count, primes)) {
			primes[found] = count;
			printf(FORMAT, count);
			found++;
		}
		count++;
	}

	return(0);
}

