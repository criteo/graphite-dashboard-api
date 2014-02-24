require 'rspec'
require_relative '../lib/graphite-dashboard-api'
require 'json'

describe GraphiteDashboardApi::Dashboard do

  it 'can be constructed to json' do
    graph = GraphiteDashboardApi::Graph.new "title" do
      from    "-5minutes"
      until_  "now"
      targets  ['storage.rsyslog.action1.processed.kestrel01-am5']
    end

    graph2 = GraphiteDashboardApi::Graph.new nil do
      from    "-5minutes"
      until_  "now"
      targets ['storage.rsyslog.action1.processed.bungee03-am5']
    end

    dashboard = GraphiteDashboardApi::Dashboard.new "remove_me" do
      defaultGraphParams_width '800'
      defaultGraphParams_height '400'
      timeConfig_startDate "2014-02-24T15:03:21"
      timeConfig_relativeStartUnits  "minutes"
      timeConfig_endDate  "2014-02-24T15:03:21"
      timeConfig_relativeStartQuantity  '5'
      timeConfig_relativeUntilQuantity  ""
      timeConfig_startTime  "9:00AM"
      timeConfig_type  "relative"
      timeConfig_relativeUntilUnits  "now"
      timeConfig_endTime  '5:00PM'
      graphs [ graph, graph2 ]
    end

    expected_json = JSON.parse('{"state":{"name":"remove_me","defaultGraphParams":{"width":"800","from":"-5minutes","until":"now","height":"400"},"refreshConfig":{"interval":600000,"enabled":false},"graphs":[["target=storage.rsyslog.action1.processed.kestrel01-am5",{"until":"now","from":"-5minutes","target":["storage.rsyslog.action1.processed.kestrel01-am5"],"title":"title"},"\/render?from=-5minutes&until=now&width=400&height=250&target=storage.rsyslog.action1.processed.kestrel01-am5&title=title"],["target=storage.rsyslog.action1.processed.bungee03-am5",{"from":"-5minutes","target":["storage.rsyslog.action1.processed.bungee03-am5"],"until":"now"},"\/render?from=-5minutes&until=now&width=400&height=250&target=storage.rsyslog.action1.processed.bungee03-am5&title=storage.rsyslog.action1.processed.bungee03-am5"]],"timeConfig":{"startDate":"2014-02-24T15:03:21","relativeStartUnits":"minutes","endDate":"2014-02-24T15:03:21","relativeStartQuantity":"5","relativeUntilQuantity":"","startTime":"9:00AM","endTime":"5:00PM","type":"relative","relativeUntilUnits":"now"},"graphSize":{"width":400,"height":250}}}')
    result = JSON.parse(JSON.generate(dashboard.to_hash))['state']
    expected_json['state'].each do |k,v|
      expect(result[k]).to eq v
    end
    expect(JSON.parse(JSON.generate(dashboard.to_hash))).to eq expected_json
  end
end

