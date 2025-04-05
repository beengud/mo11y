local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
{
    local namespace = k.core.v1.namespace,
    local secret = k.core.v1.secret,
    local pv = k.core.v1.persistentVolume,
    local pvc = k.core.v1.persistentVolumeClaim,

    Config()::{
        namespaces: [
            namespace.new('backstage'),
        ],

        secrets: [
            secret.new('postges-secrets', data={
                'POSTGRES_USER': 'YmFja3N0YWdl',
                'POSTGRES_PASSWORD': 'YmFja3N0YWdl',
            }, type='Opaque')
            + secret.metadata.withNamespace('backstage'),

        ],

        persistentVolumes: [
            pv.new('postgres-storage')
            + pv.metadata.withNamespace('backstage')
            + pv.metadata.withLabels({type: 'local'})
            + pv.spec.withStorageClassName('manual')
            + pv.spec.withCapacity({storage: '2G'})
            + pv.spec.withAccessModes(['ReadWriteOnce'])
            + pv.spec.hostPath.withPath('/mnt/data'),
        ],

        persistentVolumeClaims: [
            pvc.new('postgres-storage-claim')
            + pvc.metadata.withNamespace('backstage')
            + pvc.spec.withStorageClassName('manual')
            + pvc.spec.withAccessModes(['ReadWriteOnce'])
            + pvc.spec.resources.withRequests({storage: '2G'}),
        ],

    }
}