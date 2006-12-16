
#include <stdlib.h>
#include <stdio.h>
#include "bits.h"


/**************************************************************************/

void Radix_exchange_sort_array (unsigned int *keys,
				long int begin, long int end,
				int bits)
{
  /* See R. Sedgewick, 1990, Algorithms in C, Addison-Wesley:
     Reading, MA, chapt. 10 for a discussion of this sort 
     algorithm */
 
  long int upper, lower;
  unsigned int old_key;


  if (end > begin && bits >= 0)
    {
      lower = begin;
      upper = end;

      while (lower != upper)
	{
	  while ((Bits (keys [lower], bits, 1) == 0) 
		 && (lower < upper))
	    lower ++;

	  while ((Bits (keys [upper], bits, 1) != 0)
		 && (upper > lower))
	    upper --;

 	  old_key = keys [lower];
	  keys [lower] = keys [upper];
	  keys [upper] = old_key;
	}

      if (Bits (keys [end], bits, 1) == 0)
	upper ++;
      
      Radix_exchange_sort_array (keys, begin, upper - 1, bits - 1);
      Radix_exchange_sort_array (keys, upper, end, bits - 1);
    }
}
