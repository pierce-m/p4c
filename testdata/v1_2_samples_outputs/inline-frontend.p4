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

control p() {
    action a(in bit<1> x0, out bit<1> y0) {
        bit<1> x = x0;
        y0 = x0 & x;
    }
    action b(in bit<1> x, out bit<1> y) {
        bit<1> z;
        a(x, z);
        a(z & z, y);
    }
    apply {
        bit<1> x;
        bit<1> y;
        b(x, y);
    }
}

package m(p pipe);
m(p()) main;
