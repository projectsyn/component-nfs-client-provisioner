// main template for nfs-client-provisioner
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local sc = import 'lib/storageclass.libsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.nfs_client_provisioner;
local instance = params._instance;

// component defaults for all storage classes, can be overridden by specifying
// the fields in the hierarchy.
local scDefaults = {
  allowVolumeExpansion: true,
  mountOptions: params.pvMountOptions,
  parameters: {
    archiveOnDelete: 'true',
  },
  reclaimPolicy: 'Delete',
};

local scName(class) =
  if instance != "default" then
    "%s-%s" % [instance, class ]
  else
    class;

// Create storageclasses from entries in params.storageClasses.
local storageclasses = std.map(
  // prune resulting StorageClass objects to remove fields with null values
  std.prune,
  [
    sc.storageClass(scName(class)) + scDefaults + params.storageClasses[class] + {
      provisioner: params.provisionerName,
    }
    for class in std.objectFields(params.storageClasses)
  ]
);

// Define outputs below
{
  '00_namespace': kube.Namespace(params.namespace),
  '10_storageclasses': storageclasses,
}
