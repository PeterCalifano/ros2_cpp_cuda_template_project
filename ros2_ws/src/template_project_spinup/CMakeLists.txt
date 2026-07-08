cmake_minimum_required(VERSION 3.16)
project(template_project_spinup)

option(TEMPLATE_PROJECT_ENABLE_CUDA "Accepted for workspace-wide build helper compatibility" OFF)
option(TEMPLATE_PROJECT_ENABLE_OPTIX "Accepted for workspace-wide build helper compatibility" OFF)
option(TEMPLATE_PROJECT_PROFILE_CORE "Accepted for workspace-wide build helper compatibility" OFF)

find_package(ament_cmake REQUIRED)

install(
  DIRECTORY launch config rviz
  DESTINATION share/${PROJECT_NAME}
)

install(
  PROGRAMS scripts/run_template_project.sh
  DESTINATION lib/${PROJECT_NAME}
)

ament_package()
