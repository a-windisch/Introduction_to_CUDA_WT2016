#include<stdio.h>
#include<iostream>

__global__
void saxpy(int n, float a, float *x, float *y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i];
}

int main(void)
{

 using namespace std;

 int N=1<<20; //shift 20 bits to the left
 int num=100000; 
 float a=2.0;
 float *x;  //host array x
 float *y;  //host array y
 float *x_d;  //device array x
 float *y_d;  //device array y

 x = new (nothrow) float [N];
 y = new (nothrow) float [N];
 cudaMalloc(&x_d, N*sizeof(float)); //allocate memory for x on device
 cudaMalloc(&y_d, N*sizeof(float)); //allocate memory for y on device

 for (int i=0; i<N; i++ ) //fill host arrays 
 {
  x[i]=(float)i;
  y[i]=(float)2*i;
 }

 //transfer arrays to device
 cudaMemcpy(x_d, x, N*sizeof(float), cudaMemcpyHostToDevice);
 cudaMemcpy(y_d, y, N*sizeof(float), cudaMemcpyHostToDevice);

 cout <<"\n";
 cout <<"Performing "<<num<<" CUDA-C SAXPY on 2^20 elements.\n";

 for( int j=0; j<num; j++) 
 {
  saxpy<<<(N+255)/256, 256>>>(N, a, x_d, y_d); // Perform SAXPY on 1M elements
 }

 //transfer arrays to device
 cudaMemcpy(y, y_d, N*sizeof(float), cudaMemcpyDeviceToHost);

 cout <<"Done.\n";
 cout <<"y[213]="<<y[213]<<"\n";
 cout <<"\n";

 return 0;
}



