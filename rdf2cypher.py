"""Loads a RDF file into a neo4j database"""

import argparse
import rdflib
import urllib.request as ULR
from urllib.parse import urlparse

subjectPrefixes2ignore = ['http://www.cidoc-crm.org/cidoc-crm/','http://erlangen-crm.org/170309/','http://iconclass.org']

def isValid(s, p, o):
    '''Verifies an SPO triple'''
    if subjectPrefixes2ignore:
        return not any([str(s).startswith(x) for x in subjectPrefixes2ignore])
    return True

def defaultNSFile() : 
    return f"https://raw.githubusercontent.com/nfdi4objects/n4o-rdf-import/main/namespaces.csv"

def collLabel(): 
    return "collection"
    
def fixSC(s: str):
    '''Fix special characters'''
    if s!= None:
        return s.replace("\"","\\\"").replace("\'","\\\'")
    return ""

class RDFLoader():
    def __init__(self, fileName,collection=None):
        self.fileName = fileName
        self.collection =  str(collection) if collection else ''
        self.graph = rdflib.Graph()

        self.graph.parse(fileName,format=rdflib.util.guess_format(fileName))
        self.bindNS( defaultNSFile() )

    def bindNS(self, nsFile):
        '''Loads namespaces from URL and binds them to this graph'''
        with ULR.urlopen(nsFile) as response:
            answer = response.read().decode('utf-8')
            # Process lines
            for line in answer.split('\n'):
                #Line format: <DESCRIPTION>,<URL>,<SHORT(opt)>
                items = line.split(',')
                if len(items) > 1:
                    nsPrefix = items[0].replace(' ', '_').replace('-', '_')
                    nsUrl = items[1]
                    if len(items) > 2:
                        nsPrefix =items[2]
                    self.graph.bind(nsPrefix, nsUrl, override=True)
        #for ns in self.graph.namespaces(): print(ns)

    def getLabel(self, uriRef):
        '''Returns a label for an URIRef element'''
        sn = uriRef.n3(self.graph.namespace_manager)
        if (sn.startswith('<http')):
            return 'Node'
        if (sn.startswith('_:')):
            return 'BNode'
        sn = sn.split(':')[1]
        if sn[0].isdigit(): 
            return 'Node'        
        sn = sn.translate({ord(i): '_' for i in ':-'})
        sn = sn.translate({ord(i): None for i in '<>%.'})
        return sn
    
    def cypherBuildCommand(self, s, p, o):
        '''Returns a CYPHER command for building nodes/edges '''
        if isValid(s, p, o):
            #Process subject => Node
            collStr = f", {collLabel()}:'{ self.collection.replace('-', '_')}'" if  self.collection else ''
            sLabel = self.getLabel(s)
            cypherCmd = f"MERGE( n:{sLabel} {{ uri:'{s}'{collStr}}}) " 
            #Process predicate => Property
            pn = str(p.fragment)
            if not pn:
                pn = p.split('/')[-1]
                pn = fixSC(pn).replace('-', '_')    
            #Process object => Node
            if isinstance(o, rdflib.term.URIRef) or isinstance(o, rdflib.term.BNode):
                cypherCmd += f"WITH n MERGE( d:{self.getLabel(o)} {{ uri:'{o}'{collStr}}}) "
            else:
                tstr = f", type:'{fixSC(o.datatype)}'" if o.datatype else ''
                cypherCmd += f"WITH n MERGE( d:Literal {{ value:'{fixSC(o)}'{tstr}}}) " 
            cypherCmd += f"WITH n,d Merge (n)-[:{pn} {{ uri:'{p}' }}]->(d)"
            print(cypherCmd)
            return cypherCmd
        return ''

    def run(self, logger=None):
        '''Passes the recent RDF data '''
        graphLen = len(self.graph)
        for i, (s, p, o) in enumerate(self.graph,1):
            if cmd := self.cypherBuildCommand(s, p, o):
                if logger: 
                    logger(cmd)
                print(cmd)

def makeArgParser():
    ''' Makes an CLI argument parser'''
    parser = argparse.ArgumentParser(prog='rdf2neo', description='Uploads an RDF file to a neo4j database.')
    parser.add_argument("-f", '--file', dest="file", help="Source RDF file")
    parser.add_argument('-v', '--verbose', dest="verbose", action='store_true', help="Print infos during transfer")
    parser.add_argument('-c', '--collection', dest="collection", help="Gives a collection name")
    return parser

def main():

    argParser = makeArgParser()
    if args := argParser.parse_args():

        if args.file is None:
            argParser.print_help()
            argParser.error("an input file is required")

        loader = RDFLoader(args.file,args.collection)
        logger = print if args.verbose else None 
        loader.run(logger)
    else:
        argParser.print_help()

if __name__ == "__main__":
    main()
