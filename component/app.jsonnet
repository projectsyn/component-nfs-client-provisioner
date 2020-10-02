local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.nfs_client_provisioner;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('nfs-client-provisioner', params.namespace);

{
  'nfs-client-provisioner': app,
}
