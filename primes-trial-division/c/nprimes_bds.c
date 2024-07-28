/* n primes */

#include "bdscio.h"
#define CHARV 48
#define sizeof(int) 2

int* calloc(n, siz)
int n;
int siz;
{
	int i, *p;

	p=alloc(n*siz);
	for(i=0; i<n*siz; i++) {
		p[i]=0;
	}

	return(p);
}

unsigned int patoi(str)
char* str;
{
	int i
	int result;

	i=0;
	result=0;
	while(str[i] != 0) {
		result = ((result * 10) + (str[i] - CHARV));
		i++;
	}

	return(result);
}

int isprime(n, primes)
int n;
int* primes;
{
	int i;

	i=0;
	while(primes[i] > 0) {
		if(n % primes[i] == 0) {
			return(0);
		}
		i++;
	}

	return(1);
}

int main(argc, argv)
int argc;
char** argv;
{
	int f, n, p, *primes;

	f=0;
	p=2;
	n=patoi(argv[1]);
	primes=calloc(n,sizeof(int));
	while(f < n) {
		if(isprime(p, primes)) {
			primes[f] = p;
			printf("%d\n", p);
			f++;
		}
		p++;
	}

	return(0);
}

