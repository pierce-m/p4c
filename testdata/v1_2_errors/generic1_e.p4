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

extern If<T>
{
    T id(in T d);
}

control p1(in If x) // missing type parameter
{
    apply {}
}

control p2(in If<int<32>, int<32>> x) // too many type parameters
{
    apply {}
}

header h {}

control p()
{
    apply {
        h<bit> x;     // no type parameter
    }
}
