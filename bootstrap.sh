#!/bin/sh
# Copyright 2013-present Barefoot Networks, Inc. 
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This command bootstraps the autoconf-based configuratino
# for the P4c compiler

set -e  # exit on error
./find-makefiles.sh # creates otherMakefiles.am, included in Makefile.am
mkdir -p extensions # place where additional back-ends are expected
echo "Running autoconf/configure tools"
autoreconf -i
mkdir -p build # recommended folder for build
sourcedir=`pwd`
cd build
# TODO: the "prefix" is needed for finding the p4include folder.
# It should be an absolute path.  This may need to change
# when we have a proper installation procedure.
../configure CXXFLAGS="-g -O1" --prefix=$sourcedir $*
echo "### Configured for building in 'build' folder"
