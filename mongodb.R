#This is y first rmongodb script

##install rmongodb package
install.packages("rmongodb")
library(rmongodb)

install.packages("devtools")
library(devtools)
install_github("mongosoup/rmongodb")

# connect to your local mongodb
mongo <- mongo.create()

#test whether you are connected to mongo database
mongo.is.connected(mongo)

#take a look at what you have.
#this will show the databases in my local instance of MongDB
mongo.get.databases(mongo)


#Let's look at all of the collections (tables) in my db "emaasit".
mongo.get.database.collections(mongo, db="emaasit")

#count how many documents (rows) we have in a collection
DBNS = "emaasit.players"
mongo.count(mongo, ns = DBNS)

#Query the data
##When exploring what you have for data, it's really helpful to use the find.one concept.
tmp = mongo.find.one(mongo, ns = "emaasit.players")
tmp
class(tmp)#mongo.bson is not a normal R object

#convert Mongo's BSON objects to a list
tmp = mongo.bson.to.list(tmp)
class(tmp)
names(tmp)

#brings all records from a collection into a dataframe
find_all = mongo.find.all(mongo, ns = DBNS)
nrow(find_all)
View(find_all)

# create query object 
query <- mongo.bson.from.JSON('{"stats.position":"P"}')

# Find the records in my collection where position =="P"
cursor <- mongo.find(mongo, "emaasit.players", query)
class(cursor)

# Step though the matching records and display them
while (mongo.cursor.next(cursor))
        print(mongo.cursor.value(cursor))

#or get the results in a matrix
res <- mongo.find.batch(mongo, "emaasit.players", query)
View(res)
class(res)


# create another query object 
query2 <- mongo.bson.from.JSON('{"stats.hits": {"$gte":90}}')

# Find the records in my collection where hits >=90
cursor2 <- mongo.find(mongo, "emaasit.players", query2)

# Step though the matching records and display them
while (mongo.cursor.next(cursor2))
        print(mongo.cursor.value(cursor2))

#or get the results in a matrix
res2 <- mongo.find.batch(mongo, "emaasit.players", query2)
View(res2)
mongo.count(mongo, "emaasit.players", query)

#get keys
mongo.summary(mongo, "emaasit.players")


#Build a Dataset
#let's use the plyr & dplyr package
library(plyr); library(dplyr)

## create the empty data frame
players = data.frame(stringsAsFactors = FALSE)

## create the namespace
DBNS = "emaasit.players"

## create the cursor we will iterate over, basically a select * in SQL
cursor3 = mongo.find(mongo, DBNS)

## create the counter
i = 1

## iterate over the cursor
while (mongo.cursor.next(cursor3)) {
        # iterate and grab the next record
        tmp3 = mongo.bson.to.list(mongo.cursor.value(cursor3))
        # make it a dataframe
        tmp.df = as.data.frame(t(unlist(tmp3)), stringsAsFactors = F)
        # bind to the master dataframe
        players = rbind.fill(players, tmp.df)
        # to print a message, uncomment the next 2 lines cat('finished game ', i,
        # '\n') i = i +1
}

#now let's look at our dataset "players"
class(players)
names(players)
head(players)

#then you can perform any operation on the datafram
myvars<-c("first_name","last_name", "stats.0.hits")
subset_data<-players[,myvars]

#disconnect mongodb
mongo.disconnect(mongo)
mongo.destroy(mongo)
