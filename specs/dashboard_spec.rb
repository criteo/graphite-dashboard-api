require 'rspec'
require_relative '../lib/graphite-dashboard-api'
require 'json'

def comparison_by_block(dashboard, expected_json)
  result = JSON.parse(JSON.generate(dashboard.to_hash))['state']
  expected_json['state'].each do |k,v|
    expect(result[k]).to eq v
  end
  expect(JSON.parse(JSON.generate(dashboard.to_hash))).to eq expected_json
end


describe GraphiteDashboardApi::Dashboard do

  it 'can be constructed to json' do
    graph = GraphiteDashboardApi::Graph.new "title" do
      from    "-5minutes"
      until_  "now"
      targets  ['storage.rsyslog.action1.processed.kestrel01-am5']
    end

    graph2 = GraphiteDashboardApi::Graph.new do
      from    "-5minutes"
      until_  "now"
      targets ['storage.rsyslog.action1.processed.bungee03-am5']
    end

    dashboard = GraphiteDashboardApi::Dashboard.new "remove_me" do
      defaultGraphParams_width '800'
      defaultGraphParams_height '400'
      graphs [ graph, graph2 ]
    end

    expected_json = JSON.parse('{"state":{"name":"remove_me","defaultGraphParams":{"width":"800","from":"-5minutes","until":"now","height":"400"},"refreshConfig":{"interval":600000,"enabled":false},"graphs":[["target=storage.rsyslog.action1.processed.kestrel01-am5",{"until":"now","from":"-5minutes","target":["storage.rsyslog.action1.processed.kestrel01-am5"],"title":"title"},"\/render?from=-5minutes&until=now&width=400&height=250&target=storage.rsyslog.action1.processed.kestrel01-am5&title=title"],["target=storage.rsyslog.action1.processed.bungee03-am5",{"from":"-5minutes","target":["storage.rsyslog.action1.processed.bungee03-am5"],"until":"now"},"\/render?from=-5minutes&until=now&width=400&height=250&target=storage.rsyslog.action1.processed.bungee03-am5&title=storage.rsyslog.action1.processed.bungee03-am5"]],"timeConfig":{"startDate":"1970-01-01T00:00:00","relativeStartUnits":"minutes","endDate":"1970-01-01T00:05:00","relativeStartQuantity":"5","relativeUntilQuantity":"","startTime":"9:00AM","endTime":"5:00PM","type":"relative","relativeUntilUnits":"now"},"graphSize":{"width":400,"height":250}}}')
    comparison_by_block(dashboard, expected_json)
  end

  it 'can generate more complex dashboards' do
    part1 = '{"state": {"name": "chef-storage", "defaultGraphParams": {"width": "350", "from": "-4days", "until": "now", "height": "250"}, "refreshConfig": {"interval": 600000, "enabled": true}, "graphs": [[["cactiStyle(alias(averageSeries(storage.chef.mdb*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.mdb*.fail))),\"fails\")"], {"title": "mongo pool", "from": "-4days", "until": "now", "target": ["cactiStyle(alias(averageSeries(storage.chef.mdb*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.mdb*.fail))),\"fails\")"]}, "/render?from=-4days&until=now&width=350&height=250&target=cactiStyle(alias(averageSeries(storage.chef.mdb*.elapsed_time)%2C%22mean%20run%20time%22))&target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.mdb*.fail)))%2C%22fails%22)&title=mongo%20pool"], [["cactiStyle(alias(averageSeries(storage.chef.rmq*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.rmq*.fail))),\"fails\")"], {"title": "Rabbit pool", "from": "-4days", "until": "now", "target": ["cactiStyle(alias(averageSeries(storage.chef.rmq*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.rmq*.fail))),\"fails\")"]}, "/render?from=-4days&until=now&width=350&height=250&target=cactiStyle(alias(averageSeries(storage.chef.rmq*.elapsed_time)%2C%22mean%20run%20time%22))&target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.rmq*.fail)))%2C%22fails%22)&title=Rabbit%20pool"], [["cactiStyle(alias(averageSeries(storage.chef.{couch,mem}*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.{couch,mem}*.fail))),\"fails\")"], {"title": "couchbase pool", "from": "-4days", "until": "now", "target": ["cactiStyle(alias(averageSeries(storage.chef.{couch,mem}*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.{couch,mem}*.fail))),\"fails\")"]}, "/render?from=-4days&until=now&width=350&height=250&target=cactiStyle(alias(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.elapsed_time)%2C%22mean%20run%20time%22))&target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)))%2C%22fails%22)&title=couchbase%20pool"], [["cactiStyle(alias(averageSeries(storage.chef.{kestrel,bungee}*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.{kestrel,bungee}*.fail))),\"fails\")"], {"title": "kestrel+bungee pool", "from": "-4days", "until": "now", "target": ["cactiStyle(alias(averageSeries(storage.chef.{kestrel,bungee}*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.{kestrel,bungee}*.fail))),\"fails\")"]}, "/render?from=-4days&until=now&width=350&height=250&target=cactiStyle(alias(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.elapsed_time)%2C%22mean%20run%20time%22))&target=alias(dashed(drawAsInfinite'
    part2 ='(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)))%2C%22fails%22)&title=kestrel%2Bbungee%20pool"], [["cactiStyle(alias(averageSeries(storage.chef.{squirrel,graphite}*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.{squirrel,graphite}*.fail))),\"fails\")"], {"title": "Graphites pool", "from": "-4days", "until": "now", "target": ["cactiStyle(alias(averageSeries(storage.chef.{squirrel,graphite}*.elapsed_time),\"mean run time\"))", "alias(dashed(drawAsInfinite(sumSeries(storage.chef.{squirrel,graphite}*.fail))),\"fails\")"]}, "/render?from=-4days&until=now&width=350&height=250&target=cactiStyle(alias(averageSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.elapsed_time)%2C%22mean%20run%20time%22))&target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.fail)))%2C%22fails%22)&title=Graphites%20pool"], ["target=hitcount(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.%7Bgraphite%2Csquirrel%7D*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.rmq*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.mdb*.fail)%2C%2230min%22)&target=color(secondYAxis(sumSeries(storage.chef.*.success))%2C%22green%22)", {"title": "Success & failure", "from": "-4days", "until": "now", "target": ["hitcount(sumSeries(storage.chef.{kestrel,bungee}*.fail),\"30min\")", "hitcount(sumSeries(storage.chef.{graphite,squirrel}*.fail),\"30min\")", "hitcount(sumSeries(storage.chef.rmq*.fail),\"30min\")", "hitcount(sumSeries(storage.chef.{couch,mem}*.fail),\"30min\")", "hitcount(sumSeries(storage.chef.mdb*.fail),\"30min\")", "color(secondYAxis(sumSeries(storage.chef.*.success)),\"green\")"]}, "/render?from=-4days&until=now&width=350&height=250&target=hitcount(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.%7Bgraphite%2Csquirrel%7D*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.rmq*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)%2C%2230min%22)&target=hitcount(sumSeries(storage.chef.mdb*.fail)%2C%2230min%22)&target=color(secondYAxis(sumSeries(storage.chef.*.success))%2C%22green%22)&title=Success%20%26%20failure"], [["keepLastValue(averageSeries(storage.chef.{kestrel,bungee}*.updated_resources))", "keepLastValue(averageSeries(storage.chef.{graphite,squirrel}}*.updated_resources))", "keepLastValue(averageSeries(storage.chef.rmq*.updated_resources))", "keepLastValue(averageSeries(storage.chef.{couch,mem}*.updated_resources))", "keepLastValue(averageSeries(storage.chef.mdb*.updated_resources))"], {"title": "Updated resources", "from": "-4days", "until": "now", "target": ["keepLastValue(averageSeries(storage.chef.{kestrel,bungee}*.updated_resources))", "keepLastValue'
    part3='(averageSeries(storage.chef.{graphite,squirrel}}*.updated_resources))", "keepLastValue(averageSeries(storage.chef.rmq*.updated_resources))", "keepLastValue(averageSeries(storage.chef.{couch,mem}*.updated_resources))", "keepLastValue(averageSeries(storage.chef.mdb*.updated_resources))"]}, "/render?from=-4days&until=now&width=350&height=250&target=keepLastValue(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.updated_resources))&target=keepLastValue(averageSeries(storage.chef.%7Bgraphite%2Csquirrel%7D%7D*.updated_resources))&target=keepLastValue(averageSeries(storage.chef.rmq*.updated_resources))&target=keepLastValue(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.updated_resources))&target=keepLastValue(averageSeries(storage.chef.mdb*.updated_resources))&title=Updated%20resources"]], "timeConfig": {"startDate": "2014-02-21T14:01:27", "relativeStartUnits": "days", "endDate": "2014-02-21T14:01:27", "relativeStartQuantity": "4", "relativeUntilQuantity": "", "startTime": "9:00 AM", "endTime": "5:00 PM", "type": "relative", "relativeUntilUnits": "now"}, "graphSize": {"width": "350", "height": "250"}}}'
    expected_json = JSON.parse(part1+part2+part3) #vim syntaxic coloration does not handle very long strings

    pool_definitions = {
      'mongo' => %w(mdb),
      'Rabbit' => %w(rmq),
      'couchbase' => %w(couch mem),
      'kestrel+bungee' => %w(kestrel bungee),
      'Graphites' => %w(squirrel graphite),
    }
    graphs = pool_definitions.map do |pool,prefixes|
      prefixes_ = '{' + prefixes.join(',') + '}'
      prefixes_ = prefixes.first if prefixes.size.eql? 1
      GraphiteDashboardApi::Graph.new "#{pool} pool" do
        from   '-4days'
        until_ 'now'
        targets [
          "cactiStyle(alias(averageSeries(storage.chef.#{prefixes_}*.elapsed_time),\"mean run time\"))",
          "alias(dashed(drawAsInfinite(sumSeries(storage.chef.#{prefixes_}*.fail))),\"fails\")",
        ]
      end
    end
    success_failure = GraphiteDashboardApi::Graph.new 'Success & failure' do
        from   '-4days'
        until_ 'now'
        targets [
          "hitcount(sumSeries(storage.chef.{kestrel,bungee}*.fail),\"30min\")",
          "hitcount(sumSeries(storage.chef.{graphite,squirrel}*.fail),\"30min\")",
          "hitcount(sumSeries(storage.chef.rmq*.fail),\"30min\")",
          "hitcount(sumSeries(storage.chef.{couch,mem}*.fail),\"30min\")",
          "hitcount(sumSeries(storage.chef.mdb*.fail),\"30min\")",
          "color(secondYAxis(sumSeries(storage.chef.*.success)),\"green\")"
        ]
    end
    updated_resources = GraphiteDashboardApi::Graph.new 'Updated resources' do
        from   '-4days'
        until_ 'now'
        targets [
          "keepLastValue(averageSeries(storage.chef.{kestrel,bungee}*.updated_resources))",
          "keepLastValue(averageSeries(storage.chef.{graphite,squirrel}}*.updated_resources))",
          "keepLastValue(averageSeries(storage.chef.rmq*.updated_resources))",
          "keepLastValue(averageSeries(storage.chef.{couch,mem}*.updated_resources))",
          "keepLastValue(averageSeries(storage.chef.mdb*.updated_resources))"
        ]
    end

    dashboard = GraphiteDashboardApi::Dashboard.new "chef-storage" do
      defaultGraphParams_width '350'
      defaultGraphParams_height '250'
      graphSize_width           '350'
      defaultGraphParams_from   '-4days'
      refreshConfig_enabled true
      graphs ([graphs, success_failure, updated_resources].flatten)
    end

    comparison_by_block(dashboard, expected_json)

  end
end

