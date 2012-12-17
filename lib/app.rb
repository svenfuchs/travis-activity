require 'sinatra'
require 'haml'
require 'stats'
require 'crowd'

ELASTIC_URL = ENV['BONSAI_URL'] || 'http://localhost:9200'

class App < Sinatra::Base
  get '/stats' do
    params.delete('name') if params['name'] == 'Travis CI'

    params['repos'] ||= []
    params['repos'].reject! { |repo| repo.empty? }
    params['repos'] = Stats::REPOS if params['repos'].empty?

    params['interval'] ||= 'week'

    table = Stats::Table.new(repos: params['repos'], user: params['name'], interval: params['interval'])

    @names  = Stats::NAMES
    @repos  = Stats::REPOS

    @intervals = %w(day week month)
    @stats  = table.data
    @colors = table.colors
    haml :stats
  end

  get '/crowd' do
    # @intervals = %w(day week month)
    @stats = Crowd::Table.new.data
    haml :crowd
  end
end
