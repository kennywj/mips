#include <stdio.h>
int data = 123;
int sum;

int test(int i)
{
	int data = i * i;
	//printf("i=%d data = %d\n", i, data);
	return data;
}
int main()
{
	int i;
	for (i=0;i<10;i++)
		sum += test(i);
	data = data + sum;
	//printf("sum = %d\n", sum);
	return data;
}