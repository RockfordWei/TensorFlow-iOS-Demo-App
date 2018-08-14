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

#import "tensorflow_experimental/tensorflow/core/public/session.h"
#import "tensorflow_experimental/tensorflow/cc/framework/scope.h"

using namespace tensorflow;

extern "C" int greetings(char * display, const void * data, const int size);

int greetings(char * display, const void * data, const int size)
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

  delete graph;
  delete session;
  stringstream sout;
  cout << status << endl;
  sout
  << "status: " << status << endl
  << "size = " << size << endl
  << "address = " << data << endl;
  auto output = sout.str();
  strcpy(display, output.c_str());
  return 0;
}
