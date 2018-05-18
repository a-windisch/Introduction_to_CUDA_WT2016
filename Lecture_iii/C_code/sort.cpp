#define DIM 5000
#include <iostream>
#include <algorithm>
#include <fstream>
#include <cstdlib>
#include <vector>

int main(void)
{ 

 using namespace std;

 vector<double> x(DIM);
 ifstream Input("5000_random_numbers.dat");
 
 for(int i=0; i<DIM; i++)
 {
  Input>>x[i];
 }
 
 cout << "C++ version\n";
 cout << "Sorting array of 5000 double elements for validity check...\n";
 sort(x.begin(), x.end()); // sort data on the device
 cout << "Done.\n";
 cout << "Reference element:\n"; 
 cout << "x(2344)="<<x[2344]<<"\n";
}
