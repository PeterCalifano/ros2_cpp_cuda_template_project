#include "template_project_core/CTemplateAlgorithm.h"

#include <catch2/catch_approx.hpp>
#include <catch2/catch_test_macros.hpp>

TEST_CASE("CTemplateAlgorithm evaluates scalar values", "[core]") {
  const template_project_core::CTemplateAlgorithm objAlgorithm_(2.0, 1.0);
  REQUIRE(objAlgorithm_.gain() == Catch::Approx(2.0));
  REQUIRE(objAlgorithm_.bias() == Catch::Approx(1.0));
  REQUIRE(objAlgorithm_.evaluateScalar(3.0) == Catch::Approx(7.0));
}

TEST_CASE("CTemplateAlgorithm evaluates deterministic batches", "[core]") {
  const template_project_core::CTemplateAlgorithm objAlgorithm_(2.0, 1.0);
  const auto dInputs_ = template_project_core::MakeInputSequence(3U, 0.5);
  const auto dOutputs_ = objAlgorithm_.evaluateBatch(dInputs_);

  REQUIRE(dOutputs_.size() == 3U);
  REQUIRE(dOutputs_[0] == Catch::Approx(1.0));
  REQUIRE(dOutputs_[1] == Catch::Approx(2.0));
  REQUIRE(dOutputs_[2] == Catch::Approx(3.0));
  REQUIRE(objAlgorithm_.accumulateBatch(dInputs_) == Catch::Approx(6.0));
}

TEST_CASE("MakeInputSequence rejects invalid steps", "[core]") {
  REQUIRE_THROWS_AS(template_project_core::MakeInputSequence(3U, 0.0), std::invalid_argument);
}
