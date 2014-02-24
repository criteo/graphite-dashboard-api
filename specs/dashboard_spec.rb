require 'rspec'
require_relative '../lib/graphite-dashboard-api'
require 'json'

describe GraphiteDashboardApi::Dashboard do

  it 'can be constructed to json' do
    graph = GraphiteDashboardApi::Graph.new "title"
    graph.from = "-5minutes"
    graph.until = "now"
    graph.targets << 'storage.rsyslog.action1.processed.kestrel01-am5'
    graph2 = GraphiteDashboardApi::Graph.new nil
    graph2.from = "-5minutes"
    graph2.until = "now"
    graph2.targets << 'storage.rsyslog.action1.processed.bungee03-am5'
    dashboard = GraphiteDashboardApi::Dashboard.new "remove_me"
    dashboard.graphs << graph
    dashboard.graphs << graph2
    dashboard.defaultGraphParams_width = '800'
    dashboard.defaultGraphParams_height = '400'
    dashboard.timeConfig_startDate = "2014-02-24T15:03:21"
    dashboard.timeConfig_relativeStartUnits = "minutes"
    dashboard.timeConfig_endDate = "2014-02-24T15:03:21"
    dashboard.timeConfig_relativeStartQuantity = '5'
    dashboard.timeConfig_relativeUntilQuantity = ""
    dashboard.timeConfig_startTime = "9:00AM"
    dashboard.timeConfig_type = "relative"
    dashboard.timeConfig_relativeUntilUnits = "now"
    dashboard.timeConfig_endTime = '5:00PM'

    expected_json = JSON.parse('{"state":{"name":"remove_me","defaultGraphParams":{"width":"800","from":"-5minutes","until":"now","height":"400"},"refreshConfig":{"interval":600000,"enabled":false},"graphs":[["target=storage.rsyslog.action1.processed.kestrel01-am5",{"until":"now","from":"-5minutes","target":["storage.rsyslog.action1.processed.kestrel01-am5"],"title":"title"},"\/render?from=-5minutes&until=now&width=400&height=250&target=storage.rsyslog.action1.processed.kestrel01-am5&title=title"],["target=storage.rsyslog.action1.processed.bungee03-am5",{"from":"-5minutes","target":["storage.rsyslog.action1.processed.bungee03-am5"],"until":"now"},"\/render?from=-5minutes&until=now&width=400&height=250&target=storage.rsyslog.action1.processed.bungee03-am5&title=storage.rsyslog.action1.processed.bungee03-am5"]],"timeConfig":{"startDate":"2014-02-24T15:03:21","relativeStartUnits":"minutes","endDate":"2014-02-24T15:03:21","relativeStartQuantity":"5","relativeUntilQuantity":"","startTime":"9:00AM","endTime":"5:00PM","type":"relative","relativeUntilUnits":"now"},"graphSize":{"width":400,"height":250}}}')
    result = JSON.parse(JSON.generate(dashboard.to_hash))['state']
    expected_json['state'].each do |k,v|
      expect(result[k]).to eq v
    end
    expect(JSON.parse(JSON.generate(dashboard.to_hash))).to eq expected_json
  end
end

