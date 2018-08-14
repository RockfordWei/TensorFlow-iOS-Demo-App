//
//  TFLib.m
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-14.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>

using namespace std;

#import "tensorflow_experimental/tensorflow/core/framework/tensor.h"

using namespace tensorflow;

extern "C" char * greetings(void * data);

char * greetings(void * data)
{
  Tensor * placeholder = new Tensor();
  auto dim = placeholder->dims();
  delete placeholder;

  stringstream str;
  str << "dim = " << dim;
  auto hola = str.str();
  return (char *)hola.c_str();
}
