#==================================================#
# author: Winnie yeung #
#==================================================#
#this is the code for aggregateing the daily data for twitter and facbeook into a weekly level 
#==================================================#
#reading the twitter data

setwd("/Users/vionwinnie/Desktop")
library(xlsx)
twitter_df <- read.xlsx("Lensational_Twitter_Facebook.xls", sheetIndex=1,startRow=2, header=TRUE)
fb_df <- read.xlsx("Lensational_Twitter_Facebook.xls", sheetIndex=2,startRow=1, header=TRUE)

colnames(twitter_df)  #total posts,Impression
colnames(fb_df)  #likes_lifetime, enage_daily

#twitter weekly data
library("xts")
twitter_posts_ts <- xts(twitter_df$Total.Posts, twitter_df$Date..UTC.)
twitter_posts_weekly <- apply.weekly(twitter_posts_ts,sum)
twitter_impression_ts <- xts(twitter_df$Impression, twitter_df$Date..UTC.)
twitter_impression_weekly <- apply.weekly(twitter_impression_ts,sum)
twitter_aggregate <- merge(twitter_posts_weekly,twitter_impression_weekly)
twitter_weekly_df <- data.frame(date=index(twitter_aggregate), coredata(twitter_aggregate))

#facebook weekly data
fb_likes_ts <- xts(fb_df$likes_lifetime, fb_df$date)
fb_likes_weekly <- apply.weekly(fb_likes_ts,max, na.rm=TRUE)
fb_engagement_ts <- xts(fb_df$enage_daily, fb_df$date)
fb_engagement_weekly <- apply.weekly(fb_engagement_ts,sum)
fb_aggregate <- merge(fb_likes_weekly,fb_engagement_weekly)
fb_weekly_df <- data.frame(date=index(fb_aggregate), coredata(fb_aggregate))

#export result into an excel file 
write.xlsx(twitter_weekly_df, file="lensational_socialmedia_weeklystats.xlsx", sheetName="twitter",row.names=FALSE)
write.xlsx(fb_weekly_df, file="lensational_socialmedia_weeklystats.xlsx", sheetName="fb", append=TRUE,row.names=FALSE)
