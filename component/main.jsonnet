// main template for nfs-client-provisioner
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.nfs_client_provisioner;

// Define outputs below
{
  '00_namespace': kube.Namespace(params.namespace),
}
