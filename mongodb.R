#This is y first rmongodb script

##install rmongodb package
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
