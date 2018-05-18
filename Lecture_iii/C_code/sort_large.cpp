//#define DIM 1<<24
#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdlib>
#include <vector>

int main(void)
{ 
 int DIM = 1 << 24;

 using namespace std;

 vector<double> x(DIM);

  
 cout << "C++ version\n"; 
 cout << "Filling vector with random doubles.\n"; 
 for(int i=0; i<DIM; i++)
 {
  x[i] = (double) (rand()) / (double) (RAND_MAX);
 }
 cout << "Done.\n"; 

 cout << "Sorting random array with " << DIM << " double elements using std::sort..."<<"\n";
 sort(x.begin(), x.end());
 cout << "Done."<<"\n";
}
