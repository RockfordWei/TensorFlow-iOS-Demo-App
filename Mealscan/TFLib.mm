//
//  TFLib.m
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-14.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>
#include <cstdio>
#include <cstring>

using namespace std;

#import "tensorflow_experimental/tensorflow/core/framework/tensor.h"

using namespace tensorflow;

extern "C" int greetings(char * display, const void * data, const size_t size);

int greetings(char * display, const void * data, const size_t size)
{
  Tensor * placeholder = new Tensor();
  auto dim = placeholder->dims();
  delete placeholder;

  stringstream sout;
  sout << "dimension = " << dim << endl
  << "size = " << size << endl
  << "address = " << data << endl;
  auto output = sout.str();
  strcpy(display, output.c_str());
  return 0;
}
