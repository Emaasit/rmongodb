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
























