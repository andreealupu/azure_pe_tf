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
  run_plan('azure_pe_tf::peinstall')
}

