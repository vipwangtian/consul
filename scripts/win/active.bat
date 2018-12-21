@echo off

set base_dir=%~dp0
set consul_bin_name=consul.exe
set consul_config_file=consul.json
set service_name=CONSUL

set consul_bin_path=%base_dir%%consul_bin_name%
set consul_config_path=%base_dir%%consul_config_file%
set log_path=%base_dir%log\consul.log

@echo on
sc create %service_name% binpath="%consul_bin_path% agent -config-file=%consul_config_path% -log-file=%log_path%" type=own displayname=%service_name% start=auto