local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

{
    local deployment = k.apps.v1.deployment,
    local container = k.core.v1.container,
    local service = k.core.v1.service,

    postgres: [
        deployment.new(name='postgres',
        replicas=1, containers =
            container.new(name='postgres', image='postgres:13.2-alpine')
            + container.withPorts([{containerPort: 5432}])
            + container.withEnvFrom([{
                secretRef: {
                    name: 'postges-secrets',
                },
            }])
            + container.withEnv([{
                name: 'POSTGRES_HOST',
                value: 'postgres.backstage',
            },{
                name: 'POSTGRES_PORT',
                value: '5432',
            }])
            + container.withVolumeMounts([{
                mountPath: '/var/lib/postgresql/data',
                name: 'postgresdb',
                subPath: 'data',
            }]),
        podLabels={app: 'postgres'})
        + deployment.spec.selector.withMatchLabels({app: 'postgres'})
        + deployment.spec.template.spec.withVolumes([{
            name: 'postgresdb',
            persistentVolumeClaim: {
                claimName: 'postgres-storage-claim',
            },
        }])
        + deployment.metadata.withNamespace('backstage'),

        service.new(name='postgres', selector={app: 'postgres'}, ports=[
            {port: 5432},
        ])

    ]

}