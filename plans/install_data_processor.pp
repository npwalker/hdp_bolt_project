# This is the structure of a simple plan. To learn more about writing
# Puppet plans, see the documentation: http://pup.pt/bolt-puppet-plans

# The summary sets the description of the plan that will appear
# in 'bolt plan show' output. Bolt uses puppet-strings to parse the
# summary and parameters from the plan.
# @summary A plan created with bolt plan new.
# @param targets The targets to run on.
plan hdp_bolt_project::install_data_processor (
  TargetSpec $targets = "localhost"
) {
  apply_prep($targets)
  apply($targets){
    $hdp_dns_name = lookup('hdp_dns_name')

    class { 'hdp::data_processor'
      hdp_url =>  "https://${hdp_dns_name}:9091",
  }
}
