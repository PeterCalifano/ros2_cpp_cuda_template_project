#pragma once

#include "template_project_core/CTemplateAlgorithm.h"
#include "template_project_interfaces/msg/algorithm_status.hpp"
#include "template_project_interfaces/srv/run_algorithm.hpp"

#include <rclcpp/rclcpp.hpp>
#include <rclcpp_lifecycle/lifecycle_node.hpp>

#include <cstdint>
#include <memory>

namespace template_project_nodes {

class CTemplateLifecycleNode final : public rclcpp_lifecycle::LifecycleNode {
 public:
  explicit CTemplateLifecycleNode(const rclcpp::NodeOptions& options = rclcpp::NodeOptions());

  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn on_configure(
      const rclcpp_lifecycle::State& previous_state) override;
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn on_activate(
      const rclcpp_lifecycle::State& previous_state) override;
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn on_deactivate(
      const rclcpp_lifecycle::State& previous_state) override;
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn on_cleanup(
      const rclcpp_lifecycle::State& previous_state) override;

 private:
  using RunAlgorithm = template_project_interfaces::srv::RunAlgorithm;
  using AlgorithmStatus = template_project_interfaces::msg::AlgorithmStatus;

  void handleRunAlgorithm(
      const std::shared_ptr<RunAlgorithm::Request> objRequest_,
      std::shared_ptr<RunAlgorithm::Response> objResponse_);
  void publishStatus(double dInput_, double dOutput_, const char* charState_);

  std::unique_ptr<template_project_core::CTemplateAlgorithm> objAlgorithm_;
  rclcpp_lifecycle::LifecyclePublisher<AlgorithmStatus>::SharedPtr objStatusPublisher_;
  rclcpp::Service<RunAlgorithm>::SharedPtr objService_;
  double dGain_;
  double dBias_;
  std::uint64_t uiEvaluationCount_;
};

}  // namespace template_project_nodes

