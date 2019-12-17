FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# Develop
RUN apt-get update && apt-get install -y \
        software-properties-common \
        wget curl git cmake cmake-curses-gui \
        libboost-all-dev \
        libflann-dev \
        libgsl0-dev \
        libgoogle-perftools-dev \
        libeigen3-dev

# Intall some basic GUI and sound libs
RUN apt-get update && apt-get install -y \
        xz-utils file locales dbus-x11 pulseaudio dmz-cursor-theme \
        fonts-dejavu fonts-liberation hicolor-icon-theme \
        libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
        libasound2 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
        libgl1-mesa-glx libgl1-mesa-dri language-pack-en \
        && update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

# Intall some basic GUI tools
RUN apt-get update && apt-get install -y \
        cmake-qt-gui \
        gnome-terminal

# Intall ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full ros-kinetic-nmea-msgs ros-kinetic-nmea-navsat-driver ros-kinetic-sound-play ros-kinetic-jsk-visualization ros-kinetic-grid-map ros-kinetic-gps-common
RUN apt-get update && apt-get install -y ros-kinetic-controller-manager ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-gazebo-ros-control ros-kinetic-joystick-drivers
RUN apt-get update && apt-get install -y libnlopt-dev freeglut3-dev qtbase5-dev libqt5opengl5-dev libssh2-1-dev libarmadillo-dev libpcap-dev gksu libgl1-mesa-dev libglew-dev python-wxgtk3.0 software-properties-common libmosquitto-dev libyaml-cpp-dev python-flask python-requests

# Setup .bashrc for ROS
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

RUN rosdep init && rosdep update

# Setting
ENV LANG="en_US.UTF-8"
RUN echo "export LANG=\"en_US.UTF-8\"" >> ~/.bashrc

# Install dev tools
RUN sudo apt-get -y install vim tmux parallel

# Install Autoware
RUN cd && git clone https://github.com/TakedaLab/Autoware.git -b feature/add_custom_messages
RUN bash -c 'source /opt/ros/kinetic/setup.bash && cd ~/Autoware/ros/src && git submodule update --init --recursive && catkin_init_workspace && cd ../ && ./catkin_make_release'
RUN bash -c 'echo "source ~/Autoware/ros/devel/setup.bash" >> ~/.bashrc'

# Install packages for CARLA
RUN apt-get install -y ros-kinetic-derived-object-msgs

COPY docker-entrypoint.sh /docker-entrypoint.sh

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/docker-entrypoint.sh"]
