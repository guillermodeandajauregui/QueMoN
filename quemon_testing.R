library(tidyverse)
library(igraph)
library(tm)

#get example
b = read.graph(file = my_path, "gml")
my_names = names(neighbors(graph = b, v = 149))
#my_names = names(neighbors(graph = b, v = 482 ))

#prepare stopwords
my_stopwords = tm::stopwords(kind = "en")
my_stopwords = c(my_stopwords, "PATHWAY", "GO", "OF", "TO", "OR", "AND")

#my_stopwords = tm::stopwords(kind = "es")


#prepare my example by removing stopwords and signs
my_test  = gsub(pattern = "_", replacement = " ", my_names)
my_test  = removePunctuation(my_test)
my_test  = removeWords(x = my_test, words = my_stopwords)
my_test  = str_to_lower(my_test)
my_test  = str_trim(string = my_test, side = "left")
my_test  = str_squish(string = my_test)

#split phrases into words
my_split =sapply(my_test, FUN = function(i){
                strsplit(x = i, split = " ")
                })

#make a network for each phrase

my_g_list = lapply(X = my_split, FUN = function(i){
                     g = make_full_graph(n = length(i), 
                                         directed = FALSE, 
                                         loops = FALSE)
                     V(g)$name = i
                     return(g)
                     })

#get edge data frames 
my_df_list = lapply(X = my_g_list, FUN = get.data.frame)
my_df_list
#bind all data frames
my_big_df  = bind_rows(my_df_list, .id = NULL)
#count how many times a link is found
my_big_df = my_big_df %>% group_by(from,to)%>%tally()
colnames(my_big_df)[3] = "weight"
#make a network 

g = graph_from_data_frame(d = my_big_df, directed = FALSE)
V(g)$degree = degree(g)
V(g)$betweenness = betweenness(g)
V(g)$strength = strength(g)
V(g)$infomap  = infomap.community(g)$membership
V(g)$strength.rank  = rank(V(g)$strength)
g_df = get.data.frame(g, "vertices")

#p = ggplot(g_df, mapping = aes(degree, betweenness))
p = ggplot(g_df, mapping = aes(strength, betweenness))
p = p + geom_point()
p = p + geom_text(aes(label=name))
p

library(networkD3)

g_d3 <- igraph_to_networkD3(g, group = V(g)$infomap)
g_d3$nodes <- cbind(g_d3$nodes, 
                    get.data.frame(g, "vertices")[,-1])


forceNetwork(Links = g_d3$links, 
             Nodes = g_d3$nodes, 
             Source = 'source', 
             Target = 'target', 
             NodeID = 'name', 
             Group = "group",
             #Nodesize = "degree",
             #Nodesize = "betweenness",
             Nodesize = "strength",
             radiusCalculation = JS(" Math.sqrt(d.nodesize)"),
             fontSize = 24
             )

g_df%>%
#  mutate(ranking_bet = rank(betweenness),
#         ranking_deg = rank(degree))%>%
  arrange(strength)%>%tail(10)


g_df%>%#arrange(strength)%>%
  #ggplot(aes(name, strength)) + geom_bar(stat = "identity")
  ggplot(aes(x = reorder(name, strength), 
             y = strength,
             fill = as.factor(infomap))
  )+ 
  geom_bar(stat = "identity")+
  coord_flip()

