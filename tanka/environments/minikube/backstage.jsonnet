local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
{
    local deployment = k.apps.v1.deployment,
    local container = k.core.v1.container,
    local service = k.core.v1.service,

    backstage: [
        deployment.new(name='backstage',
        replicas=1,
        containers =
            container.new('backstage', 'backstage:1.0.5')
            + container.withPorts([{name: 'http', containerPort: 7007}])
            + container.withEnvFrom([
                {secretRef: {
                    name: 'postges-secrets',
                }},
                {secretRef: {
                    name: 'backstage-secrets',
                }},
            ]),
        podLabels = {app: 'backstage'})
        + deployment.metadata.withNamespace('backstage')
        + deployment.spec.selector.withMatchLabels({app: 'backstage'}),

        service.new(name='backstage', selector={app: 'backstage'}, ports=[
            {name: 'http', port: 80, targetPort: 'http'},
        ])
        + service.metadata.withNamespace('backstage')

    ]

}