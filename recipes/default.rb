#
# Cookbook Name:: nagios-core
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe "nagios-core::basics"
include_recipe "nagios-core::apache"
include_recipe "nagios-core::nagios_core"