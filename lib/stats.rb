class Stats
  autoload :Record, 'stats/record'
  autoload :Table,  'stats/table'

  REPOS = %w(
    travis-crowd
    pro travis-admin travis-sso
    travis-ci travis-core
    travis-cookbooks travis-build travis-worker travis-images travis-artifacts
    travis-hub travis-listener travis-gatekeeper travis-tasks travis-log
    travis-assets travis-web travis-api
    gh coder lograge
  )

  COLORS = {
    'travis-crowd'      => '#d94802',
    'travis-ci'         => '#ddd',
    'travis-core'       => '#999',
    'pro'               => '#173D63',
    'travis-sso'        => '#235C95',
    'travis-admin'      => '#3985D0',
    'travis-cookbooks'  => '#314B06',
    'travis-build'      => '#56840B',
    'travis-worker'     => '#7ABD0F',
    'travis-images'     => '#9DED1D',
    'travis-artifacts'  => '#BEF368',
    'travis-hub'        => '#50020F',
    'travis-listener'   => '#8C031A',
    'travis-gatekeeper' => '#B40421',
    'travis-tasks'      => '#F0052C',
    'travis-log'        => '#FB4B68',
    'travis-assets'     => '#CC9900',
    'travis-web'        => '#F5B800',
    'travis-api'        => '#FFD147',
    'gh'                => '#2D6254',
    'coder'             => '#408C78',
    'lograge'           => '#57B29A'
  }

  NAMES = %w(
    Josh
    Konstantin
    Mathias
    Sven
    Michael
    Lucas
    Piotr
  )
end
