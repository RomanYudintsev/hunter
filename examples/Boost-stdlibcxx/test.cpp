// Copyright (c) 2013, Ruslan Baratov
// All rights reserved.

#include <cstdlib> // EXIT_SUCCESS
#include <boost/filesystem.hpp>

int main() {
  std::cout << "cwd: " << boost::filesystem::current_path() << std::endl;
  return EXIT_SUCCESS;
}
