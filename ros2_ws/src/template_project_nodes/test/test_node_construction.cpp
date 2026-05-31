#include "template_project_nodes/CTemplateLifecycleNode.h"

#include <gtest/gtest.h>
#include <rclcpp/rclcpp.hpp>

TEST(TemplateLifecycleNode, ConstructAndConfigure) {
  if (!rclcpp::ok()) {
    rclcpp::init(0, nullptr);
  }

  auto objNode_ = std::make_shared<template_project_nodes::CTemplateLifecycleNode>();
  const auto objState_ = objNode_->configure();
  EXPECT_EQ(objState_.label(), "inactive");

  objNode_->cleanup();
  rclcpp::shutdown();
}

