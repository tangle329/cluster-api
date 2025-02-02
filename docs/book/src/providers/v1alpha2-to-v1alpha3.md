# Cluster API v1alpha2 compared to v1alpha3

## In-Tree bootstrap provider

- Cluster API now ships with the Kubeadm Bootstrap provider (CABPK).
- Update import paths from `sigs.k8s.io/cluster-api-bootstrap-provider-kubeadm` to `sigs.k8s.io/cluster-api/bootstrap/kubeadm`.

## Machine `spec.metadata` field has been removed

- The field has been unused for quite some time and didn't have any function.
- If you have been using this field to setup MachineSet or MachineDeployment, switch to MachineTemplate's metadata instead.

## Set `spec.clusterName` on Machine, MachineSet, MachineDeployments.

- The field is now required on all Cluster dependant objects.
- The `cluster.x-k8s.io/cluster-name` label is created automatically by each respective controller.

## Context is now required for `external.CloneTemplate` function.

- Pass a context as the first argument to calls to `external.CloneTemplate`.

## Context is now required for `external.Get` function.

- Pass a context as the first argument to calls to `external.Get`.

## Cluster and Machine `Status.Phase` field values now start with an uppercase letter.

- To be consistent with Pod phases in k/k.
- More details in https://github.com/kubernetes-sigs/cluster-api/pull/1532/files.

## `MachineClusterLabelName` is renamed to `ClusterLabelName`

- The variable name is renamed as this label isn't applied only to machines anymore.
- This label is also applied to external objects(bootstrap provider, infrastructure provider)

## Cluster and Machine controllers now set `cluster.x-k8s.io/cluster-name` to external objects.

- In addition to the OwnerReference back to the Cluster, a label is now added as well to any external objects, for example objects such as KubeadmConfig (bootstrap provider), AWSCluster (infrastructure provider), AWSMachine (infrastructure provider), etc.
