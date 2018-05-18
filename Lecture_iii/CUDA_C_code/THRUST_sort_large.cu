#include <iostream>
#include <fstream>
#include <cstdlib>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>

int main(void)
{ 

 using namespace std;

 int DIM = 1 << 24;
 thrust::host_vector<double> x_h(DIM);

 cout << "CUDA-C (Thrust) version\n";
 cout << "Filling vector with random doubles (on host).\n";
 for(int i=0; i<DIM; i++)
 {
  x_h[i] = (double) (rand()) / (double) (RAND_MAX);
 }
 cout << "Done.\n"; 
 
 cout << "Allocate device vector and copy array to device.\n";
 thrust::device_vector<double> x_d = x_h;

 cout << "Sorting random array with " << DIM << " double elements using std::sort..."<<"\n";
 thrust::sort(x_d.begin(), x_d.end());
 cout << "Done.\n";

 cout << "Copy array to host.\n";
 thrust::copy(x_d.begin(), x_d.end(), x_h.begin());
 cout << "Done.\n";
}
