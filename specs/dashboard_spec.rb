require 'rspec'
require_relative '../lib/graphite-dashboard-api'
require 'json'

describe GraphiteDashboardApi::Dashboard do

  it 'can generate complex dashboards' do
    part1 = "state=%7B%22name%22:%22chef-storage-automatic%22%2C%22defaultGraphParams%22:%7B%22width%22:%22350%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22height%22:%22250%22%7D%2C%22refreshConfig%22:%7B%22interval%22:600000%2C%22enabled%22:true%7D%2C%22timeConfig%22:%7B%22startDate%22:%221970-01-01T00:00:00%22%2C%22relativeStartUnits%22:%22days%22%2C%22endDate%22:%221970-01-01T00:05:00%22%2C%22relativeStartQuantity%22:%224%22%2C%22relativeUntilQuantity%22:%22%22%2C%22startTime%22:%229:00%20AM%22%2C%22endTime%22:%225:00%20PM%22%2C%22type%22:%22relative%22%2C%22relativeUntilUnits%22:%22now%22%7D%2C%22graphSize%22:%7B%22width%22:%22350%22%2C%22height%22:%22250%22%7D%2C%22graphs%22:[[[%22cactiStyle(alias(averageSeries(storage.chef.mdb*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.mdb*.fail)))%2C%5C%22fails%5C%22)%22]%2C%7B%22title%22:%22mongo%20pool%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22target%22:[%22cactiStyle(alias(averageSeries(storage.chef.mdb*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.mdb*.fail)))%2C%5C%22fails%5C%22)%22]%7D%2C%22/render?from=-4days%26until=now%26width=350%26height=250%26target=cactiStyle(alias(averageSeries(storage.chef.mdb*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%26target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.mdb*.fail)))%2C%5C%22fails%5C%22)%26title=mongo%20pool%22]%2C[[%22cactiStyle(alias(averageSeries(storage.chef.rmq*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.rmq*.fail)))%2C%5C%22fails%5C%22)%22]%2C%7B%22title%22:%22Rabbit%20pool%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22target%22:[%22cactiStyle(alias(averageSeries(storage.chef.rmq*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.rmq*.fail)))%2C%5C%22fails%5C%22)%22]%7D%2C%22/render?from=-4days%26until=now%26width=350%26height=250%26target=cactiStyle(alias(averageSeries(storage.chef.rmq*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%26target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.rmq*.fail)))%2C%5C%22fails%5C%22)%26title=Rabbit%20pool%22]%2C[[%22cactiStyle(alias(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)))%2C%5C%22fails%5C%22)%22]%2C%7B%22title%22:%22couchbase%20pool%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22target%22:[%22cactiStyle(alias(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)))%2C%5C%22fails%5C%22)%22]%7D%2C%22/render?from=-4days%26until=now%26width=350%26height=250%26target=cactiStyle(alias(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.elapsed_time)"
    part2 = "%2C%5C%22mean%20run%20time%5C%22))%26target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)))%2C%5C%22fails%5C%22)%26title=couchbase%20pool%22]%2C[[%22cactiStyle(alias(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)))%2C%5C%22fails%5C%22)%22]%2C%7B%22title%22:%22kestrel%2Bbungee%20pool%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22target%22:[%22cactiStyle(alias(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)))%2C%5C%22fails%5C%22)%22]%7D%2C%22/render?from=-4days%26until=now%26width=350%26height=250%26target=cactiStyle(alias(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%26target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)))%2C%5C%22fails%5C%22)%26title=kestrel%2Bbungee%20pool%22]%2C[[%22cactiStyle(alias(averageSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.fail)))%2C%5C%22fails%5C%22)%22]%2C%7B%22title%22:%22Graphites%20pool%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22target%22:[%22cactiStyle(alias(averageSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%22%2C%22alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.fail)))%2C%5C%22fails%5C%22)%22]%7D%2C%22/render?from=-4days%26until=now%26width=350%26height=250%26target=cactiStyle(alias(averageSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.elapsed_time)%2C%5C%22mean%20run%20time%5C%22))%26target=alias(dashed(drawAsInfinite(sumSeries(storage.chef.%7Bsquirrel%2Cgraphite%7D*.fail)))%2C%5C%22fails%5C%22)%26title=Graphites%20pool%22]%2C[[%22hitcount(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)%2C%5C%2230min%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.%7Bgraphite%2Csquirrel%7D*.fail)%2C%5C%2230min%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.rmq*.fail)%2C%5C%2230min%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)%2C%5C%2230min%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.mdb*.fail)%2C%5C%2230min%5C%22)%22%2C%22color(secondYAxis(sumSeries(storage.chef.*.success))%2C%5C%22green%5C%22)%22]%2C%7B%22title%22:%22Sucess%20%26%20failure%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22target%22:[%22hitcount(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)%2C%5C%2230min%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.%7Bgraphite%2Csquirrel%7D*.fail)%2C%5C%2230min%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.rmq*.fail)%2C%5C%2230min%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)%2C%5C%2230min"
    part3 = "%5C%22)%22%2C%22hitcount(sumSeries(storage.chef.mdb*.fail)%2C%5C%2230min%5C%22)%22%2C%22color(secondYAxis(sumSeries(storage.chef.*.success))%2C%5C%22green%5C%22)%22]%7D%2C%22/render?from=-4days%26until=now%26width=350%26height=250%26target=hitcount(sumSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.fail)%2C%5C%2230min%5C%22)%26target=hitcount(sumSeries(storage.chef.%7Bgraphite%2Csquirrel%7D*.fail)%2C%5C%2230min%5C%22)%26target=hitcount(sumSeries(storage.chef.rmq*.fail)%2C%5C%2230min%5C%22)%26target=hitcount(sumSeries(storage.chef.%7Bcouch%2Cmem%7D*.fail)%2C%5C%2230min%5C%22)%26target=hitcount(sumSeries(storage.chef.mdb*.fail)%2C%5C%2230min%5C%22)%26target=color(secondYAxis(sumSeries(storage.chef.*.success))%2C%5C%22green%5C%22)%26title=Sucess%20%26%20failure%22]%2C[[%22keepLastValue(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.%7Bgraphite%2Csquirrel%7D%7D*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.rmq*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.mdb*.updated_resources))%22]%2C%7B%22title%22:%22Updated%20resources%22%2C%22from%22:%22-4days%22%2C%22until%22:%22now%22%2C%22target%22:[%22keepLastValue(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.%7Bgraphite%2Csquirrel%7D%7D*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.rmq*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.updated_resources))%22%2C%22keepLastValue(averageSeries(storage.chef.mdb*.updated_resources))%22]%7D%2C%22/render?from=-4days%26until=now%26width=350%26height=250%26target=keepLastValue(averageSeries(storage.chef.%7Bkestrel%2Cbungee%7D*.updated_resources))%26target=keepLastValue(averageSeries(storage.chef.%7Bgraphite%2Csquirrel%7D%7D*.updated_resources))%26target=keepLastValue(averageSeries(storage.chef.rmq*.updated_resources))%26target=keepLastValue(averageSeries(storage.chef.%7Bcouch%2Cmem%7D*.updated_resources))%26target=keepLastValue(averageSeries(storage.chef.mdb*.updated_resources))%26title=Updated%20resources%22]]%7D"

    expected_encoded_string = part1 + part2 + part3 #vim syntaxic coloration does not handle long lines well

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
    success_failure = GraphiteDashboardApi::Graph.new 'Sucess & failure' do
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

    dashboard = GraphiteDashboardApi::Dashboard.new "chef-storage-automatic" do
      defaultGraphParams_width '350'
      defaultGraphParams_height '250'
      graphSize_width            350
      stringify_graphSize        true
      defaultGraphParams_from   '-4days'
      timeConfig_relativeStartUnits 'days'
      timeConfig_relativeStartQuantity '4'
      refreshConfig_enabled true
      graphs ([graphs, success_failure, updated_resources].flatten)
    end

    expected_json = {'state' => JSON.parse(URI::decode(expected_encoded_string)[/^state=(.*)/,1])}
    comparison_by_block(dashboard, expected_json)
    #expect(dashboard.save!(a_graphite_url)['success']).to eq true

  end
end

def comparison_by_block(dashboard, expected_json)
  result = JSON.parse(JSON.generate(dashboard.to_hash))['state']
  expected_json['state'].each do |k,v|
    expect(result[k]).to eq v
  end
  expect(JSON.parse(JSON.generate(dashboard.to_hash))).to eq expected_json

  # also check idempotency of (to_hash o from_hash)
  # we have to be careful with tweaking options
  new_dashboard = GraphiteDashboardApi::Dashboard.new
  new_dashboard.from_hash! dashboard.to_hash
  expect(new_dashboard.graphs.size).to eq dashboard.graphs.size
  dashboard.graphs.each_with_index do |el, index|
    if el.compact_leading
      new_dashboard.graphs[index].compact_leading = true
    end
  end
  new_dashboard.to_hash['state'].each do |k,v|
    expect(dashboard.to_hash['state'][k]).to eq v
  end
  expect(new_dashboard.to_hash).to eq dashboard.to_hash
end
