# This is the structure of a simple plan. To learn more about writing
# Puppet plans, see the documentation: http://pup.pt/bolt-puppet-plans

# The summary sets the description of the plan that will appear
# in 'bolt plan show' output. Bolt uses puppet-strings to parse the
# summary and parameters from the plan.
# @summary A plan created with bolt plan new.
# @param targets The targets to run on.
plan hdp_bolt_project::install (
  TargetSpec $targets = "localhost",
  String     $puppet_primary_hostname,
  Optional[String] $hdp_dns_name = lookup('hdp_dns_name'),
) {
  apply_prep($targets)
  out::message("Installing docker now")
  apply($targets){
    include docker
  }
  out::message("Docker install finished")
  out::message("Installing HDP now")
  apply($targets){
    class { 'hdp::app_stack':
        ca_server        => "https://${puppet_primary_hostname}:8140",
        dns_name         => pick($hdp_dns_name, $facts['fqdn']),
        image_repository => 'gcr.io/hdp-gcp-316600',
        hdp_version      => 'latest',
    }
  }
  out::message("HDP install finished")
}
