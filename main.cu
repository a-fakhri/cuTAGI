///////////////////////////////////////////////////////////////////////////////
// File:         main.cu
// Description:  API for c++
// Authors:      Luong-Ha Nguyen & James-A. Goulet
// Created:      January 23, 2022
// Updated:      December 11, 2022
// Contact:      luongha.nguyen@gmail.com & james.goulet@polymtl.ca
// Copyright (c) 2022 Luong-Ha Nguyen & James-A. Goulet. Some rights reserved.
///////////////////////////////////////////////////////////////////////////////

#include <stdio.h>

#include <iostream>
#include <string>

#include "include/feature_availability.h"
#include "include/struct_var.h"
#include "include/task.cuh"
#include "include/task_cpu.h"
#include "include/user_input.h"
#include "test/fnn/test_fnn.cuh"
#include "test/fnn/test_fnn_cpu.h"
#include "test/test_cpu.h"
#include "test/test_lstm_cpu.h"

int main(int argc, char* argv[]) {
    // User input file
    std::string user_input_file;
    std::vector<std::string> user_input_options;
    if (argc == 0) {
        throw std::invalid_argument(
            "User need to provide user input file -> see README");
    } else {
        user_input_file = argv[1];
        for (int i = 2; i < argc; i++) {
            user_input_options.push_back(argv[i]);
        }
    }
    auto user_input = load_userinput(user_input_file);

    // Default path
    SavePath path;
    path.curr_path = get_current_dir();
    path.saved_param_path = path.curr_path + "/saved_param/";
    path.debug_path = path.curr_path + "/debug_data/";
    path.saved_inference_path = path.curr_path + "/saved_results/";

    // Run task
    if (user_input_file.compare("test") == 0) {
        // auto a = test_lstm_cpu();
        test_cpu(user_input_options);
        // if (is_cuda_available())
        //     test_fnn();
        // else
        //     test_fnn_cpu();
    } else {
        if (user_input.device == "cuda" && is_cuda_available()) {
            std::cout << "Run on CUDA device "
                      << "\n";
            task_command(user_input, path);
        } else {
            task_command_cpu(user_input, path);
        }
    }
    return 0;
}
