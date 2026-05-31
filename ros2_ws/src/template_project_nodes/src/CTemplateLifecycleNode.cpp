#include "template_project_nodes/CTemplateLifecycleNode.h"

#include <rclcpp_components/register_node_macro.hpp>

#include <utility>

namespace template_project_nodes {

namespace {
using CallbackReturn = rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn;
}  // namespace

CTemplateLifecycleNode::CTemplateLifecycleNode(const rclcpp::NodeOptions& options)
    : rclcpp_lifecycle::LifecycleNode("template_algorithm", options),
      dGain_(1.0),
      dBias_(0.0),
      uiEvaluationCount_(0U) {
  declare_parameter<double>("gain", dGain_);
  declare_parameter<double>("bias", dBias_);
}

CallbackReturn CTemplateLifecycleNode::on_configure(const rclcpp_lifecycle::State&) {
  dGain_ = get_parameter("gain").as_double();
  dBias_ = get_parameter("bias").as_double();
  objAlgorithm_ = std::make_unique<template_project_core::CTemplateAlgorithm>(dGain_, dBias_);
  uiEvaluationCount_ = 0U;

  objStatusPublisher_ = create_publisher<AlgorithmStatus>("~/status", rclcpp::QoS(10));
  objService_ = create_service<RunAlgorithm>(
      "~/run_algorithm",
      [this](const std::shared_ptr<RunAlgorithm::Request> objRequest_,
             std::shared_ptr<RunAlgorithm::Response> objResponse_) {
        handleRunAlgorithm(objRequest_, std::move(objResponse_));
      });

  RCLCPP_INFO(get_logger(), "Configured template algorithm with gain=%f bias=%f", dGain_, dBias_);
  return CallbackReturn::SUCCESS;
}

CallbackReturn CTemplateLifecycleNode::on_activate(const rclcpp_lifecycle::State&) {
  if (objStatusPublisher_) {
    objStatusPublisher_->on_activate();
  }
  RCLCPP_INFO(get_logger(), "Activated template algorithm node");
  return CallbackReturn::SUCCESS;
}

CallbackReturn CTemplateLifecycleNode::on_deactivate(const rclcpp_lifecycle::State&) {
  if (objStatusPublisher_) {
    objStatusPublisher_->on_deactivate();
  }
  RCLCPP_INFO(get_logger(), "Deactivated template algorithm node");
  return CallbackReturn::SUCCESS;
}

CallbackReturn CTemplateLifecycleNode::on_cleanup(const rclcpp_lifecycle::State&) {
  objService_.reset();
  objStatusPublisher_.reset();
  objAlgorithm_.reset();
  uiEvaluationCount_ = 0U;
  RCLCPP_INFO(get_logger(), "Cleaned up template algorithm node");
  return CallbackReturn::SUCCESS;
}

void CTemplateLifecycleNode::handleRunAlgorithm(
    const std::shared_ptr<RunAlgorithm::Request> objRequest_,
    std::shared_ptr<RunAlgorithm::Response> objResponse_) {
  if (!objAlgorithm_) {
    objResponse_->output = 0.0;
    objResponse_->status = "not_configured";
    return;
  }

  const double dOutput_ = objAlgorithm_->evaluateScalar(objRequest_->input);
  ++uiEvaluationCount_;
  objResponse_->output = dOutput_;
  objResponse_->status = "ok";
  publishStatus(objRequest_->input, dOutput_, "ok");
}

void CTemplateLifecycleNode::publishStatus(double dInput_, double dOutput_, const char* charState_) {
  if (!objStatusPublisher_ || !objStatusPublisher_->is_activated()) {
    return;
  }

  AlgorithmStatus objStatus_;
  objStatus_.stamp = get_clock()->now();
  objStatus_.last_input = dInput_;
  objStatus_.last_output = dOutput_;
  objStatus_.evaluation_count = uiEvaluationCount_;
  objStatus_.state = charState_;
  objStatusPublisher_->publish(objStatus_);
}

}  // namespace template_project_nodes

RCLCPP_COMPONENTS_REGISTER_NODE(template_project_nodes::CTemplateLifecycleNode)

