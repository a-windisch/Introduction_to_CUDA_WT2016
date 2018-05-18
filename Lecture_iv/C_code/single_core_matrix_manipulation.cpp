#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <vector>

int main( void) 


{
using namespace std;
 int N = 2048;
 int Nwork = 100;
// double *M = new double[N*N];
 vector<double> M(N*N);
 cout << "C-code, single core version\n";
 cout << "Computing matrix ("<<N<<"x"<<N<<")\n";
 for(int i=0; i<N; i++)
 {
  for(int j=0; j<N; j++)
  {
   int pos = j*N + i;		//map indices to 1dim
   M[pos]=0.0;
   for(int k=0; k<Nwork; k++)
   {
    M[pos] += atan((double)((i+k+1)%10)*acos(-1.0) + double((j+k+1)%5)*acos(-1.0)*acos(-1.0));
   }
  }
 }
 cout << "Done.\n";
 cout << "Computing trace.\n";
 double trace=0.0;
 for(int i=0; i<N; i++)
 {
  int pos = i*N + i;		//map indices to 1dim
  trace += M[pos];
 }
 cout << "Done.\n";
 cout << "Trace: " << trace << "\n";
 return 0;
}
