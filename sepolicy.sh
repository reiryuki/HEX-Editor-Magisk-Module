# debug
magiskpolicy --live "dontaudit system_server system_file file write"
magiskpolicy --live "allow     system_server system_file file write"

# file
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { proc_tty_drivers serialno_prop qemu_hw_prop } file { read open getattr }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { proc_tty_drivers serialno_prop qemu_hw_prop } file { read open getattr }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { vendor_file hal_perf_default_exec hal_power_default_exec } file { read open }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { vendor_file hal_perf_default_exec hal_power_default_exec } file { read open }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { adsprpcd_file cgroup_desc_file proc_uid_time_in_state rootfs init_exec ipa_dev } file getattr"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { adsprpcd_file cgroup_desc_file proc_uid_time_in_state rootfs init_exec ipa_dev } file getattr"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } qemu_sf_lcd_density_prop file read"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } qemu_sf_lcd_density_prop file read"
magiskpolicy --live "dontaudit system_server system_file file ioctl"
magiskpolicy --live "allow     system_server system_file file ioctl"

# fifo_file
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { privapp_data_file app_data_file } fifo_file { create read getattr write unlink open }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { privapp_data_file app_data_file } fifo_file { create read getattr write unlink open }"

# lnk_file
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { mnt_vendor_file init_exec } lnk_file read"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { mnt_vendor_file init_exec } lnk_file read"

# chr_file
#magiskpolicy --live "dontaudit  { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { at_device video_device mtp_device ppp_device vendor_ramdump_microdump_modem_device smd_device audio_device wcnss_device sensors_device avtimer_device tee_device qtaquid_device msm_aac_in_device loop_control_device qce_device vendor_smd7_device rmnet_device diag_device device_latency } chr_file getattr"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { at_device video_device mtp_device ppp_device vendor_ramdump_microdump_modem_device smd_device audio_device wcnss_device sensors_device avtimer_device tee_device qtaquid_device msm_aac_in_device loop_control_device qce_device vendor_smd7_device rmnet_device diag_device device_latency } chr_file getattr"
magiskpolicy --live "dontaudit  { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * chr_file getattr"
magiskpolicy --live "allow      { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * chr_file getattr"

# dir
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { asec_apk_file mnt_product_file vendor_firmware_file postinstall_mnt_dir fscklogs audio_device } dir getattr"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { asec_apk_file mnt_product_file vendor_firmware_file postinstall_mnt_dir fscklogs audio_device } dir getattr"
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * dir getattr"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * dir getattr"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { cgroup rootfs } dir { read open }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { cgroup rootfs } dir { read open }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { apex_mnt_dir configfs debugfs adsprpcd_file system_data_file shell_data_file device } dir read"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { apex_mnt_dir configfs debugfs adsprpcd_file system_data_file shell_data_file device } dir read"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { device sysfs } dir open"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { device sysfs } dir open"
magiskpolicy --live "dontaudit dexoptanalyzer privapp_data_file dir search"
magiskpolicy --live "allow     dexoptanalyzer privapp_data_file dir search"


