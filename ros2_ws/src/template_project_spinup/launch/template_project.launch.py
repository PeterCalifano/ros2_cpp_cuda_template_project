from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory

import os


def generate_launch_description():
    package_share = get_package_share_directory("template_project_spinup")
    params_file = os.path.join(package_share, "config", "template_project.yaml")

    return LaunchDescription([
        Node(
            package="template_project_nodes",
            executable="template_project_node",
            name="template_algorithm",
            output="screen",
            parameters=[params_file],
        )
    ])

