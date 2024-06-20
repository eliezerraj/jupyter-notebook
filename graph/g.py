# Load Libraries
import pandas as pd
import os
import json

from gremlin_python.structure.graph import Graph
from gremlin_python.process.traversal import T
from gremlin_python.process.graph_traversal import __ 
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection

connection = {}

# load the requirements
def connect_database(fendpoint):
    print("connect_database")
    try:
        connection = DriverRemoteConnection(fendpoint,'g')
    except Exception as error:
        print("Couldn't connect successfully with Neptune instance : ", error)
    return connection

if __name__ == "__main__":
    print("main")
    
    endpoint = 'ws://localhost:8182/gremlin'
    # Prepare connection
    graph = Graph()
    
    connection = connect_database(endpoint)
    g = graph.traversal().withRemote(connection)
    



    #print(g.V(1).valueMap().toList())
    #print(g.V(10001).valueMap().toList())

    #print(g.V(10001).bothE().toList())

    #print(g.V().hasLabel('terminal').valueMap().toList())
    #print(g.V('TERM-24').valueMap().toList())
    res = g.V().has('terminal','name','TERM-23').next()
    print(res)
    res1 = g.V(res).next()
    print(res1)

    #print(g.V().has('terminal','id','TERM-23').next())
    #print(g.V().has('terminal','name','TERM-23').both().toList())

    #print(g.V(21672).toList())
    #print(g.V(21672).both().toList())

    #print(g.V().has('terminal','name','TERM-24').both().toList())

    ##print(g.V().has('person','name', within('Person-24')).valueMap().toList())

    connection.close()