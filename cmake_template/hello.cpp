#include "hello.hpp"

double hello_cpp(int number, double real_number) {

  std::cout << "Hello from C++" << std::endl;
  std::cout << "You gave me the integer: " << number << std::endl;
  std::cout << "You gave me the double: " << real_number << std::endl;

  return number + real_number;
}
