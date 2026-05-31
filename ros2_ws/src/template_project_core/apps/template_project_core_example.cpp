#include "template_project_core/CTemplateAlgorithm.h"

#include <iostream>

int main() {
  const template_project_core::CTemplateAlgorithm objAlgorithm_(2.0, 1.0);
  const auto dValues_ = template_project_core::MakeInputSequence(4U, 0.5);
  const auto dOutputs_ = objAlgorithm_.evaluateBatch(dValues_);

  for (const double dOutput_ : dOutputs_) {
    std::cout << dOutput_ << '\n';
  }

  return 0;
}

