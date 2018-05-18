#include <stdio.h>
#include <math.h>

#define SIZE 1024
#define START_SCALE 1.5f
#define MAXIT 256
#define C_RE -0.8f
#define C_IM 0.156f

//======================================================================
/*This function checks whether a point
 belongs to the filled julia set. It 
 returns 0 if the value 'escaped', and
 one if the maximal numer of iterations
 has been reached. */
int julia( int i, int j, float scale) 
{ 
 
 //rescale grid to actual scale
 float x = scale * (float)(SIZE/2 - i)/(SIZE/2);
 float y = scale * (float)(SIZE/2 - j)/(SIZE/2);

 //real and imaginary part of point in question
 float z_re=x;
 float z_im=y;
 float z_re_old;

 //compute Z(n+1) = Zn^2 + C
 for (int k=0; k<MAXIT;k++) 
 {
  z_re_old = z_re;				//store old real value
  z_re =(z_re*z_re-z_im*z_im) + (C_RE); 	//compute Re(Z(n+1))
  z_im = 2.0f*z_re_old*z_im + (C_IM); 		//compute Im(Z(n+1))
  if ( sqrt(z_re*z_re+z_im*z_im) > SIZE)	//check if point escaped
  {
   return 0;					//point escaped
  }
 }
 return 1;					//point in set
}
//======================================================================
/* This function uses the one defined above to fill 
 an array called 'set' with ones and zeroes, 
 defining the elements of the julia set. */
void construct_julia_set( int *set, float scale)
{
 for (int i=0; i<SIZE; i++)			//loop through grid 
 {
  for (int j=0; j<SIZE; j++) 
  {
   int pos = i + j * SIZE;			//array index pos = i + j*SIZE
   set[pos] = julia( i, j, scale);		//fill the set
  }
 }
}
//======================================================================
/* This is the main function. Here we define 
 the variables used in the calculation, and perform
 a zoom into the julia set solution for a given
 value of C*/
int main( void ) 
{
 int set[SIZE*SIZE];			//the result array
 int written;				//aux variable for writing file
 int num;				//numbering of output file
 float x;				//Re part in complex Z plane
 float y;				//Im part in complez Z plane
 float scale;				//initial scale for zoom
 char buffer[32];			//buffer for filenames
 FILE *out;				//outpur file				

 /*The variable 'written' allows us to introduce a newline 
   after each row that has been written to the outpur file. 
   This allows for more freedom in printing the set using
   gnuplot.*/

 written=0;						//reset 'written' value
 for( int k=0; k<400; k++ )				//k...number of zoom slices to produce
 {							//variable scale for zoom
  scale = START_SCALE *(400.0f-(float)k)/400.0f + 0.01;
  construct_julia_set(set, scale);			//construct julia set
  num = k;						//out: 'julia_000.dat', 'julia_001.dat',...
  snprintf(buffer, sizeof(char)*32, "julia_%03i.dat", num);
  out = fopen( buffer, "wt" );				//write in text mode (wt)
  for (int i=0; i<SIZE; i++) 				//actual grid values x and y
  {
   x = scale * (float)(SIZE/2 - i)/(SIZE/2);
   for (int j=0; j<SIZE; j++) 
   {
    y = scale * (float)(SIZE/2 - j)/(SIZE/2);
    int pos = i + j * SIZE;				//position in  array
    if(set[pos]==1)					//write only if part of set
    {
     fprintf(out,"%f %f \n",x,y); 	 
     written = 1;					//set written to 1
    }
   }//end inner grid loop (j)
   if( written == 1 )
   {
    fprintf(out,"\n");					//add newline if row content not empty
   }
   written=0;						//reset written value
  }//end outer grid loop (i)
 fclose(out);						//close file
 }//end zoom loop (k)
}
