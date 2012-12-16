$: << 'lib'

require 'sinatra'
require 'haml'

require 'stats'
require 'table'

ELASTIC_URL = ENV['BONSAI_URL'] || 'http://localhost:9200'

REPOS = %w(
  travis-crowd
  pro
  travis-ci travis-core
  travis-cookbooks travis-build travis-worker travis-images travis-artifacts
  travis-hub travis-listener travis-gatekeeper travis-tasks travis-log
  travis-assets travis-web travis-api travis-sso
  travis-admin
  gh coder lograge
)

NAMES = %w(
  Josh
  Konstantin
  Mathias
  Sven
  Michael
  Lucas
  Piotr
)

class Travis < Sinatra::Base
  enable :inline_templates

  get '/' do
    params.delete('name') if params['name'] == 'Travis CI'

    params['repos'] ||= []
    params['repos'].reject! { |repo| repo.empty? }
    params['repos'] = REPOS if params['repos'].empty?

    params['interval'] ||= 'week'

    @names = NAMES
    @repos = REPOS
    @intervals = %w(day week month)
    @stats = Table.new(repos: params['repos'], user: params['name'], interval: params['interval']).data
    haml :index
  end
end

run Travis

__END__

@@ index
%html
  %head
    %script{ :src => "https://www.google.com/jsapi", :type => "text/javascript" }
    %script
      = 'var stats = ' + JSON.dump(@stats)
    :javascript
      google.load("visualization", "1", { packages:["corechart"] });
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable(stats);

        var options = {
          isStacked: true,
          areaOpacity: 1,
          lineWidth: 0,
          chartArea: { left: 50, top: 10, width: '85%', height:'90%' },
          hAxis: { textStyle: { color: '#666', fontSize: 14 }, gridlines: { count: 52 } },
          vAxis: { textStyle: { color: '#666', fontSize: 14 } },
          legend: { textStyle: { color: '#666', fontSize: 14 } },
          colors: [
            '#dc3912',
            '#3366cc',
            '#ffcc00', '#ccc',
            '#119911', '#66bb11', '#66dd11', '#000000', '#11aa00',
            '#FFD1B2', '#FFA366', '#FF7519', '#B24700', '#FF6600',
            '#FFFF00', '#FFD700', '#FFFF80', '#FF8C00',
          ]
        };

        var chart = new google.visualization.AreaChart(document.getElementById('chart_total'));
        chart.draw(data, options);
      }
  %body
    %h1= "#{params['name']}'s changes by #{params[:interval]}"
    #chart_total{ style: 'width: 100%; height: 560px;' }
    %form{ action: '/' }
      %select{ name: 'repos[]', multiple: true, size: @repos.size }
        - @repos.each do |repo|
          %option{ selected: (params['repos'] || []).include?(repo) }
            = repo
      %select{ name: 'name', multiple: false, size: @names.size + 1 }
        %option{ selected: !params['name'] } Travis CI
        - @names.each do |name|
          %option{ selected: params['name'] == name }
            = name
      %select{ name: 'interval', multiple: true, size: 3 }
        - @intervals.each do |interval|
          %option{ selected: params['interval'] == interval }
            = interval

      %input{ type: :submit }

