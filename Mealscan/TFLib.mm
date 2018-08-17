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

extern "C" int greetings(char * display, const void * data, const int size,
                         const void * image_data_ref, const int image_size,
                         const int image_width, const int image_height);

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

int greetings(char * display, const void * data, const int size,
              const void * image_data_ref, const int image_size,
              const int image_width, const int image_height)
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

  auto statusSessionIni = session->Create(*graph);
  if (!statusSessionIni.ok()) {
    strcpy(display, "session initial failure");
    return -3;
  }

  auto image = stripe_alpha(image_data_ref, image_size);

  Tensor image_tensor(DT_UINT8, TensorShape({1, image_width, image_height, 3}));

  auto image_tensor_data = image_tensor.tensor_data();
  std::memcpy((char *)image_tensor_data.data(), image.data(), image.size());

  std::vector<std::pair<std::string, tensorflow::Tensor>> inputs = {
    {"image_tensor:0", image_tensor}
  };

  std::vector<string> output_names = {
    {"num_detections:0"}, {"detection_boxes:0"},
    {"detection_scores:0"}, {"detection_classes:0"}
  };

  std::vector<tensorflow::Tensor> outputs;

  auto status = session->Run(inputs, output_names, {}, &outputs);

  if (!status.ok()) {
    strcpy(display, "session run failure");
    return -4;
  }

  auto num_detections = outputs[0].tensor<float, 1>();
  auto boxes = outputs[1].flat<float>();
  auto scores = outputs[2].flat<float>();
  auto classes = outputs[3].flat<float>();
  stringstream sout;
  sout
  << "num_detections: " << num_detections << endl
  << "detection_boxes: " << boxes(0) << " " << boxes(1) << " " << boxes(2) << " " << boxes(3) << " " << endl
  << "detection_scores: " << scores(0) << " " << scores(1) << " " << scores(2) << " " << scores(3) << " " << endl
  << "detection_classes: " << classes(0) << " " << classes(1) << " " << classes(2) << " " << classes(3) << " " << endl
  ;
  auto output = sout.str();
  strcpy(display, output.c_str());

  delete graph;
  delete session;

  return 0;
}
