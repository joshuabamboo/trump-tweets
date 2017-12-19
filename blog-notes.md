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
	- >1 is noteworthy. 
	- api doesnt provide comment reply data
		- stream them as they come in - this is intensive
		- find another service
		- scrape page for info
- all caps - potentially bad. shouting w all caps (sometimes he does this for positive things? eg "MAKE AMERICA GREAT AGAIN")
- Is it him? Does this even matter? Everything is an official statement whether he wrote it or not. Tweets by him are more likely to be angry/agressive/negative potentially..?


###What I learned?

- streaming api: daemon
- sentiment analysis: ngrams
- twitter gem: truncated tweets bc of 280 limit
 - def timeline
    client.user_timeline(handle, tweet_mode: 		'extended')
  	 end
- jpeg rendered when had jpg of same name? ie trump.jpeg vs trump.jpg
- twitter api doesnt have replyCount - had to scrape page
