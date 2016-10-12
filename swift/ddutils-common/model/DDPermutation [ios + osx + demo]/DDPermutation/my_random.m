//
//  my_next_random.m
//  DDPermutation
//
//  Created by Dominik Pich on 10/5/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

#include <stdlib.h>
#include "my_random.h"

void seed_random(unsigned int seed) {
    return srandom(seed);
}

long next_random() {
    return random();
}
