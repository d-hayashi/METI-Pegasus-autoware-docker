#!/bin/bash

source /root/.bashrc
source /opt/ros/kinetic/setup.bash
source /root/Autoware/ros/devel/setup.bash

exec "$@"
