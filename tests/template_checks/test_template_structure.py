from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[2]


def ReadText(relative_path_: str) -> str:
    return (ROOT / relative_path_).read_text(encoding="utf-8")


def StripCmakeComments(text_: str) -> str:
    return "\n".join(line_.split("#", 1)[0] for line_ in text_.splitlines())


def InstallDirectoryRules(cmake_text_: str) -> list[list[str]]:
    rules_ = []
    for match_ in re.finditer(r"install\s*\(\s*DIRECTORY\s+(.*?)\s+DESTINATION\b", cmake_text_, re.DOTALL):
        dirs_ = [token_ for token_ in re.split(r"\s+", StripCmakeComments(match_.group(1)).strip()) if token_]
        rules_.append(dirs_)
    return rules_


def test_plan_uses_checkbox_stages() -> None:
    plan_ = ReadText("doc/developments/ros2_cpp_cuda_template_plan.md")
    assert "## Stage 2 - Early Testfield Repository" in plan_
    assert "- [ ] Create `/home/peterc/devDir/dev-tools/ros2_cpp_cuda_template_testfield`" in plan_


def test_readme_explains_template_gap() -> None:
    readme_ = ReadText("README.md")
    assert "ros2 pkg create" in readme_
    assert "cpp_cuda_template_project" in readme_
    assert "hyper_2" in readme_
    assert "C++/CUDA library" in readme_


def test_core_package_keeps_ros_boundary() -> None:
    core_header_ = ReadText("ros2_ws/src/template_project_core/include/template_project_core/CTemplateAlgorithm.h")
    assert "rclcpp" not in core_header_
    core_package_ = ReadText("ros2_ws/src/template_project_core/package.xml")
    assert "<depend>rclcpp</depend>" not in core_package_


def test_core_package_exports_library_target() -> None:
    cmake_ = ReadText("ros2_ws/src/template_project_core/CMakeLists.txt")
    assert "add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})" in cmake_
    assert "ament_export_targets(${PROJECT_NAME}Targets HAS_LIBRARY_TARGET)" in cmake_
    assert "TEMPLATE_PROJECT_ENABLE_CUDA" in cmake_
    assert "TEMPLATE_PROJECT_PROFILE_CORE" in cmake_


def test_profiling_rejects_ros2_targets_by_default() -> None:
    common_ = ReadText("profiling/common_core_profiler.sh")
    assert "Refusing to profile a ROS2-facing executable by default" in common_
    assert "--allow-ros2-target" in common_
    profiling_doc_ = ReadText("doc/profiling.md")
    assert "ROS2 executors" in profiling_doc_
    assert "core-library profiling" in profiling_doc_


def test_containers_have_dev_and_runtime_stages() -> None:
    dockerfile_ = ReadText("docker/Dockerfile")
    assert "FROM deps AS dev" in dockerfile_
    assert "FROM deps AS builder" in dockerfile_
    assert "FROM ros:${ROS_DISTRO} AS runtime" in dockerfile_
    assert "rosdep install --from-paths ros2_ws/src" in dockerfile_


def test_install_directory_rules_reference_existing_directories() -> None:
    for cmake_file_ in (ROOT / "ros2_ws/src").glob("*/CMakeLists.txt"):
        cmake_text_ = cmake_file_.read_text(encoding="utf-8")
        for directories_ in InstallDirectoryRules(cmake_text_):
            for directory_ in directories_:
                assert (cmake_file_.parent / directory_).is_dir(), f"{cmake_file_}: missing install directory '{directory_}'"


def test_spinup_package_replaces_bringup_runtime_references() -> None:
    assert (ROOT / "ros2_ws/src/template_project_spinup").is_dir()
    assert not (ROOT / "ros2_ws/src/template_project_bringup").exists()

    runtime_paths_ = [
        "AGENTS.md",
        "CONTEXT.md",
        "README.md",
        "docker/Dockerfile",
        "tailor_ros2_template_cleanup.sh",
    ]
    for relative_path_ in runtime_paths_:
        text_ = ReadText(relative_path_)
        assert "template_project_bringup" not in text_, relative_path_
        assert "bringup" not in text_.lower(), relative_path_

def test_bringup_installs_default_rviz_workspace() -> None:
    cmake_ = ReadText("ros2_ws/src/template_project_bringup/CMakeLists.txt")
    rviz_config_ = ReadText("ros2_ws/src/template_project_bringup/rviz/template_project.rviz")
    assert "DIRECTORY launch config rviz" in cmake_
    assert "Visualization Manager:" in rviz_config_
    assert "Displays: []" in rviz_config_

