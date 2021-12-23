# This is the structure of a simple plan. To learn more about writing
# Puppet plans, see the documentation: http://pup.pt/bolt-puppet-plans

# The summary sets the description of the plan that will appear
# in 'bolt plan show' output. Bolt uses puppet-strings to parse the
# summary and parameters from the plan.
# @summary A plan created with bolt plan new.
# @param targets The targets to run on.
plan azure_pe_tf::boltazureplan (
  TargetSpec $targets = get_targets('localhost')
) {
  $plan_string = run_command("cd terraform && terraform apply -auto-approve", $targets)

    #############################################
    # Pull in Terraform References for Bolt Use #
    #############################################

    # Linux References and mapping to tf state file
    $primevmref = {
        '_plugin'        => 'terraform',
        'dir'            => './terraform',
        'backend'        => 'remote',
        'resource_type'  => 'azurerm_linux_virtual_machine',
        'state'          => 'terraform.tfstate',
        'target_mapping' => {
            'uri' => 'public_ip_address',
            'name' => 'name',
            'config' => {
              'ssh'  => {
                'user' => 'admin_username',
                'host' => 'public_ip_address',
              }
            }
        }
    }

  $lookup_targets = resolve_references($primevmref)
  out::message($lookup_targets)
  $lookup_targets.map|$target|{$new_primaryserver = Target.new($target).add_to_group('primaryserver')
  out::message($new_primaryserver)
  wait_until_available($new_primaryserver, wait_time => 120)
  run_plan('azure_pe_tf::peinstall', $new_primaryserver)}
}

