from typing_extensions import Self
import datetime as DT
import portion as P
import json

def storeDTT(I, path='./intervals.json'):
    with open(path,'w+') as f:
        f.write(json.dumps(P.to_data(I,conv=lambda v: (v.year, v.month, v.day))))

def loadDTT(path='./intervals.json'):
    with open(path,'r+') as f:
        return P.from_data(json.loads(f.read()), conv=lambda v:DT.date(*v))

def bytes2str(n,k=2):
    if n < 1024: return f'{round(n,k)} bytes'
    n = n/1024
    if n < 1024: return f'{round(n,k)} kB'
    n = n/1024
    if n < 1024: return f'{round(n,k)} MB'
    n = n/1024
    if n < 1024: return f'{round(n,k)} GB'
    n = n/1024
    return f'{round(n,k)} TB'    

def to_json(obj):
    return json.dumps(obj, default=lambda obj: obj.__dict__)

def clamp(x, l, u): 
    return max(l, min(u, x))

def isoformat(s:str):
    return DT.date.fromisoformat(s)

def today():
    return DT.date.today()

def date_short_str(date):
    return date.isoformat().split('T')[0]

def select(x:bool, a, b):
    """Returns alternatives for a valid object x"""
    return a if x else b


def selectNN(x, a, b):
    """Returns alternatives for a valid object x"""
    return select(x!=None,a,b)

def fixSC(s: str):
    '''Fix special characters'''
    if s!= None:
        return s.replace("\"","\\\"").replace("\'","\\\'")
    return ""

def compileStrProperties(texts, prefix:str):
    valid_args = len(texts)*len(prefix) > 0 
    if valid_args:
        joined = ' '.join(texts)
        return f"{prefix}:'{joined}'"
    return ''

def neoCmdWithSingleRet(driver, cmd:str):
    '''Returns the single result from executing of a cypher command'''
    def exec(tx, cmd):
        result = tx.run(cmd)
        return result.single().value()
    return driver.execute_r(exec, cmd)

def neoCmdWithSingleRetW(driver, cmd:str):
    '''Returns the single result from executing of a cypher command'''
    def exec(tx, cmd):
        result = tx.run(cmd)
        return result.single().value()
    return driver.execute_w(exec, cmd)

def compileUniqueProperties(texts, prefix):
    '''compiles an attribute string from objects with text property'''
    utexts = set([fixSC(str(p)) for p in texts]) # use unique texts
    return compileStrProperties(utexts,prefix)

import functools
def default_kwargs(**defaultKwargs):
    def actual_decorator(fn):
        @functools.wraps(fn)
        def g(*args, **kwargs):
            defaultKwargs.update(kwargs)
            return fn(*args, **defaultKwargs)
        return g
    return actual_decorator



def cliProgressBar (n, total, prefix = '', suffix = '', decimals = 1, length = 100):
    numFilled = int(length * n // total)
    curInPercent = 100 * (n / float(total))
    percent = f"{curInPercent:{0}.{decimals}f}"
    bar = '█' * numFilled + '-' * (length - numFilled)
    beat = '*' if n%10 == 0 else ' '
    print(f'\r{prefix} |{bar}| {percent}% {suffix} {beat}', end = '\r')
    if n == total: 
        print()

class MaybeExt:
    """
       Helper class for adding a maybe feature.
       Enables derived classes to construct from xml elements.
       Returns a None for invalid nodes.
    """
    @classmethod
    def maybe(cls,arg,**kw) -> Self:
        """Returns a class for valid arguments (else None)."""
        if arg != None: return cls(arg,**kw)    
