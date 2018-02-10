# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# tweets = GetTweets.new.timeline
# tweets.each { |tweet| Tweet.new_from_twitter(tweet) }

# really_negative_ids = [939485131693322240,935874566701842434,935844881825763328,933280234220134401,933282274937733126,932570628451954688,932388590344196096,932303108146892801,917734186848579584,917026789188399105,917029060471152640]
# regular_negative_ids = [944665687292817415,944222157218942978,944210183089254400,943856675294982145,943819430735372289,943489378462130176,943135588496093190,942717030091943936,940930017365778432,939967625362276354,939480342779580416,937305615218696193,937301085156503552,937279001684598784,937145025359761408,937142713211813889,937141061343956992,936551346299338752,936260193536573440,936206961728786432,936058006659321858,936037588372283392,
#                 935838073618870272,935701139198181376,935513049729028096,935489831005810688,935150368207654912,935147410472480769,934896989539586054,934781939088629761,934189999045693441,933837062293291008,933285973277868032,932392209445457920]
# borderline_negative_ids = [944247868126318593,943824695144697857,939149296389251072,937309279257792512]
# negative_ids = [really_negative_ids, regular_negative_ids, borderline_negative_ids].flatten.uniq
# presidential_ids = [935506217392267265,935393413804965888,935147767726448640,935340092583006208,934961858380955648,934507210385829888,934080974773776384,934031535757582336,933921775984967681,933831194558582784,933720598383026176,933692459351265280,933662564587855877,933658521828315136,933517194142584833,933446283632824321,932578255810498560,932433668068528131,932397369655808001,928064591665467393,938756989542457344,927265906086031363,926238774773862400,923277142271684609,922603042796654592,921483820288921601,920966294035451904,920425069964349445,947536951464333318, 948739073237311488, 948189482284707840, 947824196909961216, 945437479863291904, 943842608631238656, 943213901625294849, 942721681130483712, 941291666564141057, 941094961482780672, 940795587733151744, 939521466634326016, 939355447273906182, 939120304542101505, 938861758038577152, 938786402992578560, 938440878577856512, 936941673124425728, 936219599422574592, 936005585019002887, 935881037254725632, 935713791765110785,949066181381632001]
#
# negative_ids.map do |id|
#   t = GetTweets.new.by_id(id)
#   Tweet.new_from_twitter(t) if !Tweet.find_by(twitter_id: id)
# end
#
# presidential_ids.map do |id|
#   t = GetTweets.new.by_id(id)
#   Tweet.new_from_twitter(t) if !Tweet.find_by(twitter_id: id)
# end


# Get Trump's entire timeline oldest to newest
# GetTweets.new.timeline.each {|tweet| Tweet.new_from_twitter(tweet)}
first_tweet_as_president = 822501803615014918
# t = GetTweets.new.by_id(first_tweet_as_president)
# Tweet.new_from_twitter(t)
latest_tweet_id = first_tweet_as_president
# max_id = Tweet.order('date').first.twitter_id - 1
max_id = 954904213687021568

loop do
  resp = GetTweets.new.user_timeline_since(latest_tweet_id, max_id).each do |tweet|
    Tweet.new_from_twitter(tweet)
  end
  break if resp.empty?
  max_id = Tweet.order('date').first.twitter_id - 1
end

# #adjust to EST timezone
# Tweet.all.each do |t|
#   est_date = t.date - 18000
#   t.update(date: est_date)
# end


# # Get Trump's entire timeline newest to oldest
# last_tweet = 949619270631256064
# t = GetTweets.new.by_id(last_tweet)
# Tweet.new_from_twitter(t)
# max_tweet_id = last_tweet
#
# until max_tweet_id == 954904213687021568
#   batch = GetTweets.new.user_timeline_max(max_tweet_id)
#   batch.each do |tweet|
#     Tweet.new_from_twitter(tweet)
#   end
#   max_tweet_id = Tweet.order('date').last.twitter_id
# end

# # JSON for histogram
# require 'json'
# tweets = Tweet.all
# @results = []
# # get all uniq dates
# dates = Tweet.order(date: :asc).pluck(:date).map {|date| date.strftime('%b %d, %Y')}.uniq
# # iterate over them
# dates.each do |d|
#   # get count for all tweets on that day
#   tweet_count = Tweet.where(:date => Date.parse(d).beginning_of_day..Date.parse(d).end_of_day).size
#   # add structured hash to results array
#   @results.push({Date: d, Count: tweet_count})
# end
#
# File.open("all-tweets.json","w") do |f|
#   f.write(@results.to_json)
# end

# JSON for circle graph
# require 'json'
# tweets = Tweet.all
# @results = [{year: '0'}]
# weeks = Array( Date.parse("2017-01-20")..Date.parse("2018-01-20") ).select(&:sunday?).map(&:to_s)
# weeks.each.with_index(1) do |d, i|
#   tweets = Tweet.where(:date => Date.parse(d).beginning_of_week..Date.parse(d).end_of_day)#.sort_by {|t| t.negative?}
#   sorted_tweets = tweets.where("negative is not null").order("negative desc")
#   no_prediction = tweets.where("negative is null")
#   formatted_tweets = sorted_tweets + no_prediction
#   @results[0]["Week #{i}"] = formatted_tweets
# end
#
# File.open("all-tweets.json","w") do |f|
#   f.write(@results.to_json)
# end
