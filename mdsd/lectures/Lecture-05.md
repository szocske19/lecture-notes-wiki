Lecture 5.
#Behavioural Modelling Languages 
categorized in different ways 

 - properties 
 - requirements : not the whole possibilities
 - system scenarios
 - analysis
 - … 
 
(Statemate = original formalization of statcharts)
##Characteristics of Dynamic Languages 
 - Specification
	 - **unambiguity**: there are no undefined or ambiguos (ie. that can be understood/interpreted multiple ways) parts in declaration 
	 (*egyértelmű*)
	 - **consistency**: no contradicting requirements 
	 (*ellentmondás mentes*)  
	 - **completeness**: did not forget important parts 
 - Time
	 - **untimed**   
	 - **discrete**: the range of time is taken from the natural (?) numbers.  	   
	 - **continuous**: the range of time is taken from the real numbers.
 - Communication
	 - **synchronous**: communication driven by a clock
	 - **asynchronous**: the different processes are driven by a message queue
 - Determinism
	 - **stochastic**: distribution about probability selection  
	 - **deterministic**
 - Causality
	 - **causal**: from number of independent variables calculate an other/dependent one   	  
	 - **non-causal**
 - Analysis
	 - **complete/incomplete**: (free of flaws) a complete analysis answers yes or no, an incomplete analysis may answer yes, no, or *I don't know*, so it may not give you the answer
	 - **approximative/exact** - Does the result have an error margin?

## Property Specification Languages 

 - **requirements**:   Either in structured text of with modeling notations.   
  
 - **scenarios**: specify permitted/forbidden executed paths (that is, a queue of states)

[ÁBRA - Szerintem ide am. nem kell ábra, Formális módszereken simán vettünk ilyeneket - FR]  
###State-based Languages  

 Like in a finite automaton : states, transitions, events, actions, etc. 
  Hierarchy of states, history.

###Data-flow Language 

 Processes with activities, communicating through channels (tokens/messages in queues), e.g.: Activity Diagrams, Petri Nets. The activity trigger is that there is data to be processed.
 
### Event-based Rule Languages 

 - core concept is event (atomic, complex …)
 - the system response(responds?) to events specified by rules; precondition/action specifies
 - intended to be used by the domain user and not the software engineer

~controlled natural language 
###Agent-based languages 

 - real-life entities/agents with connections (e.g. FB users / profiles)
	 - plus behaviour
	 - plus space, mobility
	 - plus environment - assumptions about the environment; eg. mobile phone in low temperature (???)
### Continous-time Languages 
 - e.g. simulink, described with block diagram

## Dynamic Metamodeling in DSE 

 - complete static metamodels with dynamic and execution trace metamodels. (log, that could replay the execution)
 - UML specifications do this in plain English.  [ábra a slide-ról]

##Statecharts from Modeling Reactive Behavior 

 - state-based behavior modeling [definition]
	 - static part is the possible states
	 - dynamic part is the currently selected/active state
 - interleaving: there is no way, that two systems do something at the same time, unless it is synchronized
 - statecharts = states + transitions 
	 - concrete state: I'm 4 year-old  
	 - abstract state: since I'm 4, I'm a child (e.g. child-adult - senior abstract states) 
	 - Also, states can be placed in hierarchy 
[kép]