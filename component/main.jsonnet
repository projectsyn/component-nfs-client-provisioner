// main template for nfs-client-provisioner
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local sc = import 'lib/storageclass.libsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.nfs_client_provisioner;

local storageclass = sc.storageClass(params.storageClass.name) {
  parameters: {
    archiveOnDelete: params.storageClass.archiveOnDelete,
  },
  allowVolumeExpansion: true,
  provisioner: 'cluster.local/' + params.provisionerName,
  reclaimPolicy: params.storageClass.reclaimPolicy,
  mountOptions: params.mountOptions,
};

// Define outputs below
{
  '00_namespace': kube.Namespace(params.namespace),
  '10_storageclass': storageclass,
}
