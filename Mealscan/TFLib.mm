//
//  TFLib.m
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-14.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

using namespace std;

#import "tensorflow_experimental/tensorflow/core/public/session.h"
#import "tensorflow_experimental/tensorflow/cc/framework/scope.h"

using namespace tensorflow;

extern "C" int greetings(char * display, const void * data, const int size, const void * image_data_ref, const int image_size);

// convert RGBA to RGB
std::vector<unsigned char> stripe_alpha(const void * data, const size_t size)
{
  vector<unsigned char> target{};
  unsigned char * base = (unsigned char *)data;
  size_t i = 0;
  for (auto it = base; it < base + size; it++) {
    if (i++ % 4 == 3) continue;
    target.push_back(*it);
  }
  return target;
}

int greetings(char * display, const void * data, const int size, const void * image_data_ref, const int image_size)
{
  Session * session;
  SessionOptions options;
  auto statusSession = NewSession(options, &session);
  if (!statusSession.ok()) {
    strcpy(display, "session failure");
    return -1;
  }
  GraphDef * graph = new GraphDef();
  auto statusLoad = graph->ParseFromArray(data, size);

  if (!statusLoad) {
    strcpy(display, "protobuf loading failure");
    return -2;
  }

  auto status = session->Create(*graph);

  auto image = stripe_alpha(image_data_ref, image_size);

  uint8 * v = (uint8 * ) image.data();
  stringstream sout;
  sout << status << endl;
  sout
  << "status: " << status << endl
  << "size = " << size << endl
  << "address = " << data << endl;
  sout << "buffer ";
  for(int i = 0; i < 8; i++) {
    sout << (int)v[i] << " ";
  }
  sout << endl << "image = " << image_size << endl
  << "new size = " << image.size() << endl;
  auto output = sout.str();
  strcpy(display, output.c_str());

  delete graph;
  delete session;

  return 0;
}
