#include "template_project_core/CTemplateAlgorithm.h"

#include <chrono>
#include <cstdlib>
#include <iostream>

int main(int argc, char** argv) {
  std::size_t uiCount_ = 100000U;
  if (argc > 1) {
    uiCount_ = static_cast<std::size_t>(std::strtoull(argv[1], nullptr, 10));
  }

  const template_project_core::CTemplateAlgorithm objAlgorithm_(1.25, -0.5);
  const auto dValues_ = template_project_core::MakeInputSequence(uiCount_, 0.001);

  const auto objStart_ = std::chrono::steady_clock::now();
  const double dResult_ = objAlgorithm_.accumulateBatch(dValues_);
  const auto objStop_ = std::chrono::steady_clock::now();

  const auto iElapsedUs_ = std::chrono::duration_cast<std::chrono::microseconds>(objStop_ - objStart_).count();
  std::cout << "count=" << uiCount_ << '\n';
  std::cout << "result=" << dResult_ << '\n';
  std::cout << "elapsed_us=" << iElapsedUs_ << '\n';

  return 0;
}

