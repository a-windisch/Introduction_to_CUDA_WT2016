#include<stdio.h>
#include<stdlib.h>

void saxpy(int n, float a, float *x, float *y)
{
  int i;
  for (i = 0; i < n; ++i)
  {
    y[i] = a*x[i] + y[i];
  }
}


int main(void)
{

 int n=1<<20; //shift 20 bits to the left
 int i;
 float a=2.0;
 float *x;
 float *y;

 x = malloc(n*sizeof(float));
 y = malloc(n*sizeof(float));

 for (i=0; i<n; i++ )
 {
  x[i]=(float)i;
  y[i]=(float)2*i;
 }

 printf("\n");
 printf("Performing sequential SAXPY on 2^20 elements.\n");

 saxpy(n, a, x, y); // Perform SAXPY on 1M elements

 printf("Done.\n");
 printf("y[213]=%1f \n",y[213]);
 printf("\n");

 free(x);
 free(y);
 return 0;
}

