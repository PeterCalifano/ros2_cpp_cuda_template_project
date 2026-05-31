from launch import LaunchDescription
from launch_ros.actions import ComposableNodeContainer
from launch_ros.descriptions import ComposableNode
from ament_index_python.packages import get_package_share_directory

import os


def generate_launch_description():
    package_share = get_package_share_directory("template_project_bringup")
    params_file = os.path.join(package_share, "config", "template_project.yaml")

    return LaunchDescription([
        ComposableNodeContainer(
            name="template_project_container",
            namespace="",
            package="rclcpp_components",
            executable="component_container",
            composable_node_descriptions=[
                ComposableNode(
                    package="template_project_nodes",
                    plugin="template_project_nodes::CTemplateLifecycleNode",
                    name="template_algorithm",
                    parameters=[params_file],
                )
            ],
            output="screen",
        )
    ])

