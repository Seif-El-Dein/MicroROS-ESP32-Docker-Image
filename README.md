# micro-ROS ESP32 Project with ESP-IDF and Docker

This repository provides a complete setup for building and flashing a micro-ROS application for the ESP32 using ESP-IDF within a Dockerized environment.

## Prerequisites

- Docker installed and running
- Windows PowerShell (Administrator mode) or Linux terminal
- An ESP32 board

## Steps to Reproduce

### 1. Create ESP-IDF Project and Clone micro-ROS Component

```bash
git clone -b humble https://github.com/micro-ROS/micro_ros_espidf_component.git components/micro_ros_espidf_component
```

### 2. Configure `CMakeLists.txt` (Root of Project)

```cmake
cmake_minimum_required(VERSION 3.5)

# Add micro-ROS component
set(EXTRA_COMPONENT_DIRS components/micro_ros_espidf_component)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)

project(your_project_name)
```

### 3. Create a `Dockerfile`

Provide a Dockerfile that installs ESP-IDF, Python, and required dependencies.

### 4. Build and Run Docker Image

```bash
# Build the Docker Image
docker build -t microros-esp32-environment .

# Run the Docker Image
docker run -it --rm -v ${PWD}:/project -w /project microros-esp32-environment bash
```

### 5. Inside Docker Container

```bash
# Install Python tools
python3 -m pip install -U pip setuptools
python3 -m pip install -U colcon-common-extensions

# Install ESP-IDF
/opt/esp-idf/install.sh
. /opt/esp-idf/export.sh

# Fix empy dependency issue
pip install em==0.1.0
pip uninstall em
pip install empy==3.3.4

# Build your project
idf.py build
idf.py partition-table
```

### 6. After Successful Build (From Host Machine)

Run PowerShell as **Administrator**:

```powershell
docker cp <Container ID>:/project/build C:\Users\SeifE\Desktop\esp_build
```

### 7. Extract the BIN Files

- `bootloader.bin`
- `partition-table.bin`
- `app-template.bin`

### 8. Flash the ESP32 using `esptool.py`

```bash
esptool.py --chip esp32 --port COM8 --baud 460800 write_flash -z 0x1000 bootloader.bin
esptool.py --chip esp32 --port COM8 --baud 460800 write_flash -z 0x8000 partition-table.bin
esptool.py --chip esp32 --port COM8 --baud 460800 write_flash -z 0x10000 app-template.bin
```

> If using Docker on Linux, you may also flash the board directly from within the container.

### 9. Push Docker Image to Docker Hub (Optional)

```bash
# Tag the image using your Docker Hub username
docker tag microros-esp32-environment-test:latest seifeldein/microros-esp32-environment-test:latest

# Push to Docker Hub
docker push seifeldein/microros-esp32-environment-test:latest
```

---

## Notes

- Use `idf.py clean` if you make significant code changes (e.g., in `main.c`) to avoid build inconsistencies.
- Ensure Docker has access to the USB port if flashing from Linux.

## License

This project is licensed under the [MIT License](LICENSE).

