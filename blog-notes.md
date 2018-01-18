##Net:HTTP API
why tf have i been using nokogiri

##Collection_check_boxes - wtf are all those parameters?

##Beginner Docs: Git haircuts, restaurant mvc, DOM grammar


###param vs arg AND rspec expected vs given argument error


##How tf do you set up streamming api
- should i run a cron job instead
- rake task? 
	- just running a rake task in the terminal doesnt work when you close the computer 
- with activejob? foreman gem? just in initialize somewhere? how about on heroku?
- daemons... wtf is daemons https://github.com/tweetstream/tweetstream	

##wtf is a daemon?









# Building Trump Site

Scroll story brain dump:

- My use of social media is not Presidential - it’s MODERN DAY PRESIDENTIAL. Make America Great Again!
- I have the best words
	- word count breakdown
	- most mentioned people	 
- Most liked:
- Most rt:
- Most replied:
- 

**Is It Donald Algo**

- hashtag? - donald doesnt use a lot of hashtags
- by phone - staff iphone. trump android. (not anymore. trump got an iphone when he became president)
- time of day (trump tweets early AM - evenings sometimes)
- elipses ... strung together tweets
- attachment? multimedia from original (non rt) is not trump. He doesnt use a computer.
- reply? how often does he reply?
- rt - both trump and staff rt


**Sentiment Analysis Algo**

- dictionary https://www.nytimes.com/interactive/2016/01/28/upshot/donald-trump-twitter-insults.html
- retweet to comment ratio
	- >1 is noteworthy. It doesnt necessarily mean it's bad but almost all bad tweets have a ratio >1
	- api doesnt provide comment reply data
		- stream them as they come in - this is intensive
		- find another service
		- scrape page for info
- Punctuation 
	- all caps - potentially bad. shouting w all caps (sometimes he does this for positive things eg "MAKE AMERICA GREAT AGAIN"). 
	- `?` at the end is usually a leading question and indicative of a negative tweet.
- Is it him? Does this even matter? Everything is an official statement whether he wrote it or not. Tweets by him are more likely to be angry/agressive/negative potentially..?x
- stock phrases - `don't forget` tends negative. `monitoring the situation` isnt a shit tweet. `interview` and `book` promotions are false negatives bc people respond to them in disproportionate numbers. `wow` used at start of tweet is mostly negative (not for attachments though).
- attachment - always neautral/positive.
	- exception: 917172144710103040 (very high ratio)
- How do you catch this as negative https://twitter.com/realDonaldTrump/status/936037588372283392 And this as positive https://twitter.com/realDonaldTrump/status/933658521828315136
	- updated sentiment dictionary with `radical -5` 
- Outliers: 
	- https://twitter.com/realDonaldTrump/status/940795587733151744
	- negative https://twitter.com/realDonaldTrump/status/943135588496093190
	- negative https://twitter.com/realDonaldTrump/status/936551346299338752 VS positive https://twitter.com/realDonaldTrump/status/949066181381632001

**insecurity algo**

- parenthesis (except this one 933446283632824321) 
- insecure_ids = [935147410472480769,935493619204620288,934189999045693441,934031535757582336,933918671503753216,933280234220134401]

---
 
Decision tree for negative tweet:

- Is the ratio > 1?
	- Y - Is it > 2?
		- Y - Is the sentiment negative?
			- Y - Bad tweet. Worst tweet.
			- N - ? Probably bad. Could be policy and people are replying in disagreement/snarky comments 
		- N - (ratio btw 1-2)
	- N - Is it < .7
		- Y - Positive tweet. Neutral. Every bad tweet has people responsing to it.
		- N - Is the sentiment negative?
			- Y - Could be a false positive. But there are a very few examples of bad tweets hovering around the slightly < 1 mark
			- N - Probably positive tweet.


###What I learned?

- streaming api: daemon
- sentiment analysis: ngrams
- twitter gem: truncated tweets bc of 280 limit
 - def timeline
    client.user_timeline(handle, tweet_mode: 		'extended')
  	 end
- jpeg rendered when had jpg of same name? ie trump.jpeg vs trump.jpg
- twitter api doesnt have replyCount - had to scrape page
- d3!
	- manipulating x axis labels `call(xAxis.tickValues(x.domain().filter(function(d, i) { return !(i%7) })))`	 
- customize json response to serve d3 (instead of serving entire db objects as json)
	- https://github.com/rails/jbuilder vs doing it yourself http://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html
- twitter api `since_id` parameter to `user_timeline` is a pain in the ass that took 5 hours to figure out	 