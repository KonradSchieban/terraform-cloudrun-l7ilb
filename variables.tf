/*
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

variable "project_id" {
  default = ""
  type    = string
}

variable "region" {
  default = ""
  type    = string
}

variable "cloud_run_service_name" {
  default = ""
  type    = string
}

variable "vpc_name" {
  default = ""
  type    = string
}

variable "subnet_name" {
  default = ""
  type    = string
}

variable "subnet_range" {
  default = ""
  type    = string
}

variable "proxy_subnet_name" {
  default = ""
  type    = string
}

variable "proxy_subnet_range" {
  default = ""
  type    = string
}

variable "ilb_ip_address" {
  default = ""
  type    = string
}
