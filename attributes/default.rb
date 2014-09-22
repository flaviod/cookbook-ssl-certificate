# encoding: UTF-8
#
# Cookbook Name:: ssl-certificate
# Attributes:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['ssl']['ca']['base_dir'] = '/opt/CA'
default['ssl']['ca']['cert_file'] = '#{node['ssl']['ca']['base_dir']}/cert.pem'
default['ssl']['ca']['key_file'] = '#{node['ssl']['ca']['base_dir']}/cakey.pem'

default['ssl']['cert']['dir'] = '#{node['ssl']['ca']['base_dir']}/certs'
default['ssl']['cert']['file'] = '#{node['ssl']['cert']['dir']}/cert.pem'
default['ssl']['cert']['key_file'] = '#{node['ssl']['cert']['dir']}/key.pem'

