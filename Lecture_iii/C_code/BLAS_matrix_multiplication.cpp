extern "C"			//use BLAS library in C
{
 #include <cblas.h>
}
#include <iostream>
#define N 7000

/*
This program multiplies two large 
double precision matrices using
the BLAS library (routine dgemm).
*/

//int main ( int argc, char* argv[] ) 
int main ( void) 
{

 using namespace std;

 cout << "CPP (cBLAS) version\n";  
 cout << "Allocating " << N << "x" << N << "-matrices MA, MB and MC.\n";

 //matrices (converted to 1dim arrays)
 double*  MA = new double[N*N];
 double*  MB = new double[N*N];
 double*  MC = new double[N*N];

 cout << "Done.\n";
 cout << "Filling matrices.\n";
 
 //Initialize the matrices MA and MB
 for(int i=0; i<N; i++)
 {
  for(int j=0; j<N; j++)
  {
   int pos = i*N + j;		//map indices to 1dim
   MA[pos] = (double)(i%10 + j%10 + 1);
   MB[pos] = (double)(i%8  + j%11 + 1);
  }
 }

 cout << "Done.\n";
 cout << "Performing matrix multiplication MC = MA.MB.\n";  
 cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1.0, MA, N, MB, N, 0.0, MC, N);


 cout << "Done.\n";
 cout << "Control element CM(122,455):\n";  
 int pos = 122*N + 455;		//map indices to 1dim
 cout << MC[pos]<<"\n";  

 //deallocate
 delete[] MA;
 delete[] MB;
 delete[] MC;
 return 0;
}
