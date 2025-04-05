local cfg = import 'config.jsonnet';
local pg = import 'postgres.jsonnet';
{
    config: cfg.Config(),
    postgres: pg.postgres,
}
