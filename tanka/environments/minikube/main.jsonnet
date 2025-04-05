local cfg = import 'config.jsonnet';
local pg = import 'postgres.jsonnet';
local bs = import 'backstage.jsonnet';

{
    config: cfg.Config(),
    postgres: pg.postgres,
    backstage: bs.backstage,
}
