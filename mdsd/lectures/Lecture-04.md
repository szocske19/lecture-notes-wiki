#EMF-IncQuery 
Incremental Evaluation of Model queries 

 - Motivation: early validation of design rules 
 
##Design-rules/Well-formedness constraints 
 - e.g.: each valid car architecture needs to respect 
 - designers are immediately notified
	 - there are 500 (many)  
	 - much more complex as first someone would think and evolved constantly
	 - emf doesn't support you to do so 
 
 
##Domain Specific Modeling Languages 
 Model size in practice:  (App Model Size )
	 - System models: 10^8 
	 - Sensor data: 10^9 
	 - Geospatial model: 10^12 
 
 
_Why not push into a DB?_
Queries would include more than 10-15 joins!
 
 
###Model query:  
 - **Query**: set of constraints that have to be satisfied by (parts of) the (graph) model 
 - **Result**: set of model element tuple that satisfy the constraints of the queries 
 - **Match**: bind constant variables to model elements 
 
 
_Query(A,B)_ <- ^_cond(A,B)_ 
header && body
 
 
##Graph Pattern Matching for Queries 
 
 
complexity: _|G|^|L|_ (often wrong in papers as well) - because the size of L is fixed 
 
 
 - m: L-> G (graph morphism)  
 - CSP
 
  
Local search: we use Ulman algorithm 
 
 - select first node to be matched  
 - order on edges 
 - try to find a corresponding match 
 - branch latter is better: push decision to down => decrease backtracking
 - use: visitor pattern - visit nodes with visitor pattern
 - Alternate search tree => based on the order of numbering

---
 
Increment: Performance of query evaluation 
 
 
Query ~ : Execution time:  

 - Pattern/Query complexity
 - Model size
 - result set time: number of matches - if you calculate one it is simple

 
 
in design for 1 000 000 elements you will have matches under 100 (you are waiting to have) 
 
 
Motivation for incremental graph pattern match  

 1. More space less time
 2. cache all matches  
 3. instantly retrieves match (if valid)  

 ---

2 types:  
 
 1. _Batch query_: designer select on demand, 1 or all
 2. _Live query_: automatically available
 
IncQuery(IQ): declarative query language 

 - each node or edge: became a predicate
 - all constraints should be true (can imagine at the end of the line)
 
_pattern (S:State, N)_  
_neg find (x)_: you have a match for it if you don't have match for (x) 
 
_Transitive closure_: ~ continues to find the pattern on the result
e.g.: I have a family tree and apply transitive closure on childOf(...) the result is all my descendants
 
 
_disjunction_: {
from == to } 
or{...}_ 
 
 
###Important:  

 - unreachable state: negative values don't substituted (like in prolog) 
 - patterns have to be connected 
 - check: everything can be in check, but it must not have side
   effects!!
 - local: fixes one or more parameters (just search for my ancestors)
 - and global query: iterates over everyone ( find every ancestor of every person)  

---
 
 
##Development workflow:  
 
 
 - Develop EMF domain
 - develop & test queries
 - use/generate IncQuery code
 - integrate into EMF application 

_Validation_:

 - you always capture the invalid case
 - if you don't find a match than you don't have faults in it 
 

_antijoin_ :  do the join as the usual way and throw away which has a join 
 
 
_incremental evaluation:_ will depend on the change not on model. 

 - If one pattern reuses the changed item, than you have to count all states which contains, the others you don't have to.  (???)
 - binding up a proper rete network is hard (rete means network in Italian)  
 
 
 
