require 'faraday'
require 'json'
require 'date'

class Stats
  attr_reader :repo, :user, :interval

  def initialize(repo, user = nil, interval)
    @repo = repo
    @user = user
    @interval = interval
  end

  def data
    json = JSON.parse(fetch)
    data = json['facets']['stats']['entries']
    data.inject({}) { |data, entry| data.merge(send(interval, entry) => entry['total_count']) }
  end

  def day(entry)
    to_date(entry['time']).yday
  end

  def month(entry)
    to_date(entry['time']).month
  end

  def week(entry)
    to_date(entry['time']).cweek
  end

  def to_date(timestamp)
    Date.strptime((timestamp / 1000).to_s,'%s')
  end

  def fetch
    response = Faraday.get("#{ELASTIC_URL}/git/_search") do |request|
      request.body = JSON.dump(query)
    end
    response.body
  end

  def query_string
    [repo, user].compact.map { |str| %("#{str}") }.join(' AND ')
  end

  def query
    {
      size: 10,
      sort: { date:  { order: 'asc' } },
      query: { query_string: { query: query_string } },
      facets: { stats: { date_histogram: { key_field: 'date', value_field: 'changes', interval: interval } } }
    }
  end
end
