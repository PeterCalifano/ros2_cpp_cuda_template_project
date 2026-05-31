#include "template_project_core/CTemplateAlgorithm.h"

#include <iostream>

int main() {
  const template_project_core::CTemplateAlgorithm objAlgorithm_(3.0, 2.0);
  std::cout << objAlgorithm_.evaluateScalar(4.0) << '\n';
  return 0;
}

