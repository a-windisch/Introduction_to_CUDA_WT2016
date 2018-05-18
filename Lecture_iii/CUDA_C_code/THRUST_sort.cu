#define DIM 5000
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>

int main(void)
{ 

 using namespace std;


 thrust::host_vector<double> x_h(DIM);
 ifstream Input("5000_random_numbers.dat");
 
 for(int i=0; i<DIM; i++)
 {
  Input>>x_h[i];
 // cout << x_h[i] << "\n";
 }
 
 cout << "CUDA-C (Thrust) version\n";
 cout << "Allocate device vector and copy array to device.\n";
 thrust::device_vector<double> x_d = x_h;

 cout << "Sorting 5000 double elements for validity check on device...\n";
 thrust::sort(x_d.begin(), x_d.end());
 cout << "Done.\n";

 cout << "Copy array to host.\n";
 thrust::copy(x_d.begin(), x_d.end(), x_h.begin());
 cout << "Done.\n";
 cout << "Reference element:\n";
 cout <<"x(2344)="<<x_h[2344]<<"\n";
}
