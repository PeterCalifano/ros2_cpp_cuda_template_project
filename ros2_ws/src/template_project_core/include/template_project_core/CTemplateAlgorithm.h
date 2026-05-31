#pragma once

#include <cstddef>
#include <vector>

namespace template_project_core {

/// Minimal deterministic core algorithm used by examples, tests, ROS nodes, and profilers.
class CTemplateAlgorithm {
 public:
  /// Creates an affine transform where output = gain * input + bias.
  CTemplateAlgorithm(double gain, double bias);

  /// Returns the configured multiplicative factor.
  [[nodiscard]] double gain() const noexcept;
  /// Returns the configured additive offset.
  [[nodiscard]] double bias() const noexcept;
  /// Evaluates one scalar sample.
  [[nodiscard]] double evaluateScalar(double value) const noexcept;
  /// Evaluates all samples and returns one output per input.
  [[nodiscard]] std::vector<double> evaluateBatch(const std::vector<double>& values) const;
  /// Evaluates all samples and returns the accumulated output.
  [[nodiscard]] double accumulateBatch(const std::vector<double>& values) const;

 private:
  double gain_;
  double bias_;
};

/// Builds a deterministic input sequence for examples and profiling smoke tests.
[[nodiscard]] std::vector<double> MakeInputSequence(std::size_t count, double step);

}  // namespace template_project_core
