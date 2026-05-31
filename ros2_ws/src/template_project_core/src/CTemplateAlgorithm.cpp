#include "template_project_core/CTemplateAlgorithm.h"

#include <numeric>
#include <stdexcept>

namespace template_project_core {

CTemplateAlgorithm::CTemplateAlgorithm(double gain, double bias) : gain_(gain), bias_(bias) {}

double CTemplateAlgorithm::gain() const noexcept { return gain_; }

double CTemplateAlgorithm::bias() const noexcept { return bias_; }

double CTemplateAlgorithm::evaluateScalar(double value) const noexcept { return gain_ * value + bias_; }

std::vector<double> CTemplateAlgorithm::evaluateBatch(const std::vector<double>& values) const {
  std::vector<double> outputs;
  outputs.reserve(values.size());
  for (const double value_ : values) {
    outputs.push_back(evaluateScalar(value_));
  }
  return outputs;
}

double CTemplateAlgorithm::accumulateBatch(const std::vector<double>& values) const {
  const std::vector<double> outputs_ = evaluateBatch(values);
  return std::accumulate(outputs_.begin(), outputs_.end(), 0.0);
}

std::vector<double> MakeInputSequence(std::size_t count, double step) {
  if (step <= 0.0) {
    throw std::invalid_argument("step must be positive");
  }

  std::vector<double> values;
  values.reserve(count);
  for (std::size_t idx_ = 0; idx_ < count; ++idx_) {
    values.push_back(static_cast<double>(idx_) * step);
  }
  return values;
}

}  // namespace template_project_core

