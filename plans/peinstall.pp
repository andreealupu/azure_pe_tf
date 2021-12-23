plan azure_pe_tf::peinstall (
  TargetSpec $targets #= get_target('primaryserver')
) {
  #upload the pe.conf file 
  $pe_conf_upload = upload_file('azure_pe_tf/pe.conf', '/tmp/', $targets)
  if $pe_conf_upload.ok {
    run_script('azure_pe_tf/install.sh', $targets)

  } else {
    return $pe_conf_upload
  }
}
