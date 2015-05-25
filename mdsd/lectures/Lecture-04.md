Lecture 4.
#EMF - IncQuery 
Incremental Evaluation of Model queries 
##motivation: early validation of design rules 
###Design-rules/Well-formedness constraints 
*e.g.: each valid car architecture needs to respect 
*designers are immediately notified => There are 500 (many)  
=>much more complex as first someone would think and evolved constantly => emf not support you to do so 
 
 
##Domain Specific Modeling Languages 
1. model size in practice:  
App Model Size 
System models: 10ˇ8 
Sensor data: 10^9 
Geospatial model: 10^12 
 
 
why not pushed into a DB: queries would include more than 10-15 joins 
 
 
model query:  
1. Query: set of constraints that have to be satisfied by (parts of) the (graph) model 
2. Result: set of model element tuple that satisfy the constraints of the queries 
3. Match: bind constant variables to model elements 
 
 
Query(A,B)<-^cond(A,B) 
header body 
imperative declarative 
expressive code lots of code not much code 
safety precise control many side effects  
you know it you have to learn it(difficult)  
standard OO practice ??? 
performance manual optimization necessary depends on the platform 
 
 
##Graph Pattern Matching for Queries 
 
 
complexity: |G|^|L| (often wrong in papers as well): because the size of L is fixed 
 
 
*m: L-> G (graph morphism)  
*CSP  
 
 
Local search: we use Ulman algorithm  
1. select first node to be matched  
2. order on edges 
3. try to find a corresponding match 
 
 
branch latter is better: push decision to down => decrease backtracking 
use: visitor pattern - visit nodes with visitor pattern  
 
 
Alternate search tree => based on the order of numbering 
 
 
Increment: Performance of query evaluation 
 
 
Query ~ : Execution time:  
*Pattern/Query complexity  
*Model size 
*result set time: number of the matches =>if you calculating one than it is simple 
 
 
in design for 1 000 000 elements you will have ander 100 matches  
 
 
Motivation  
 
 
Incremental Graph Pattern Match  
*More space less time 
- cache all matches  
- instantly retrieves match (if valid)  
- 
- 
 
 
2 types:  
I. Batch query: designer select on demand, 1 or all 
II. Live query: automatically available 
 
 
IncQuery(IQ): declarative query language 
*each node or edge: became a predicate 
*all constraints should be true (can imagine at the end of the line)  
 
 
pattern (S:State, N) 
 
 
Event minta:::::: 
 
 
neg find (x) you have a match for it if you don't have match for (x) 
 
 
Transitive closure: tranzitív lezárt 
 
 
e.g.: I have a family tree and children have transitive closure => my t. c. of parent edge is all my father, mother, grandparents 
 
 
disjunction { 
from == to } 
or{...} 
 
 
Important:  
* unreachable state: negative values don't substituted (mint prolog tagadásnál, az értékek nem helyettesítődnek be) 
* patterns have to be connected 
*check: everything can be in check, but it must not have side effects!! 
*local: fixes one or more parameters (just search for my ancestors)  
* and global query: iterates over everyone ( find every ancestor of every person)  
 
 
##Development workflow:  
 
 
Develop EMF domain => develop & test queries => use/generate IncQuery code => integrate into EMF application 
 
 
you always capture the invalid case => validation => if you don't find a match than you don't have faults in it 
 
 
antijoin: do the join as the usual way and throw away which has a join 
 
 
incremental evaluation: will depend on the change not on model. If one pattern reuses the changed item, than you have to count all states which contains, the others you don't have to.  
=> binding up a proper rete network is hard (rete means network in Italian)  
 
 
 