# Model Management (2015. 05. 06.)
 
Motivation: ![motivation](https://lh3.googleusercontent.com/-EOaTdYWO9K8/VVpPZhgOGeI/AAAAAAAAAQ0/jyXfCpXHp2Y/s0/motivation.png "motivation.png")
 
MDE everything is a model => but these are not island  

 - model interchange

 - model persistence
  
 - m. comparison

 

 - versioning
 - co-evolution 
 - global model management
 - model quality
 - collaborative modelling
 
 
##Model interchange:  
late '90s (uml)  
 
 - motivation: exchange models among different modeling tools
	 - they not change diagrams
	 - we are still far away from this goal
 - solution: XMI (XML metadata interchange) implemented by a general way
	 - stable interchange format
	 - XMI standard: intance model => assigns corresponding syntax
if something is not contained by containmenthierachy than it is not serialized => not in the other model  
example xmi 1.0 document (10-15 years ago) 
![enter image description here](https://lh3.googleusercontent.com/-i5-4X6u4qwc/VVpQk9TLjAI/AAAAAAAAARI/UWz6IC3s-io/s0/kod1.png "kod1.png")

![enter image description here](https://lh3.googleusercontent.com/-rGH09JIU8H8/VVpQrz7nXrI/AAAAAAAAARU/xOTrJFhvgoU/s0/kod2.png "kod2.png")
 - very big xml document => no one liked/used that  example xmi 1.1
 ![enter image description here](https://lh3.googleusercontent.com/-oTfm91c6KXI/VVpRUxvvJGI/AAAAAAAAARg/NOE6MhgixSQ/s0/kod3.png "kod3.png")

![enter image description here](https://lh3.googleusercontent.com/-QWAUIdsFtWM/VVpRbyu4kKI/AAAAAAAAARs/47wPQ0rST6I/s0/kod4.png "kod4.png")

   document: represent attributes of a model as an xml attribute
  more practical: smaller, parser - you read elements in one, now you
   don't have to read each line

From that comes: for each object you have an element, for each reference you have an element, for regular attributes you have an attribute, relation have an attribute??  it is a question
if you have multiply outgoing references => you can not allow to not represent this, => two main tricks:  

 - first trick: attributes: default value you don't have to serialize it

 

 - second trick: document structured as element for container, contained
   element, containing 
   => you can have two save all three => two is enough to maintain the situation -> nodes: merge containment with element
   (containment is an attribute)

it doesn't contain type => he is in collection of players => it isn't needed to be represented 
how does xml parser look like: xml document+metamodel=> you get default values from metamodel  
 
 
#model persistence 
 
 
if you are working with large models xml serialization format will be large => what to do 
=> 2 main directions  
 
 

 

 

 -  version control system in the background : you split up the model into separate files/models => handling them with version control system 
in autosar models they use this 
	 
	 -  advantages:
	
	 - disadvantages:lazy loading (you only load parts of the modul, when you start to use it), 2012 doesn't work on large models can't load the whole model
 - database => model persisted in it
-CDO, Pure NoSQL (morsa and MongoEMF), Cloud storage solutions 

 
 
#Model Comparision 
needed for model versioning => E.g. two teams commiting the same document  
if you want to find in text edition changes it is relatively easy 
if you want to do it for models => to identify the diffrences of the model is hard :( we are unlucky if we have to work with models ) 
EMF compare, EMF diffmerge 
  
why model comparision is more difficult => draw one graph  -  draw another graf => complexity of graph comparision O(nˇ2) => more complex than text => because we don't have starting points 
ids can help(if they can't change), because you know they can't change => you normally don't really have it on default (you have to set it)  
before calculationg the actual difference you have to find the similarity => if you don't have you can guess the connection from the context (name, edges, types, attributes)   
 
example on (kép: example: Model Comparision) => what is the best matching - it doesn't obvious 
first you do the matching than compare models  
important !!!

 - rename the existing model and add a new one, otherweise you have two
   classes with the same name
 - deleting elements: move the corresponding elements to another model, and than you can delete the one which you wanted to delete  
#Model Versioning (briefly touched, because we discussed it today partly)  
store fragments in version controll systems => handle their different branches in version controll system, you have to support the merge operation 
 
 
#Model Co-evolution  
model Co-evoution = keep track of changes in a modeling artefact 
you just change another model =>  metamodel evolution => it's becaming more problemating with merging different models when one of it changed. It is a critical problem by automotive systems => autoSAR constantly evolves, you have to support backward compatibility and use the new one as well => you need to recast elements => problem: this model does not parse - it already has some inconsistencies 
but EMF does not tolerate well inconsistencis => e. g. dranging edges => if you have an element point to a nonexisting element => it won't open, you have to solve it in text editor 
##Classification of meta-model changes:  
 - non breaking operation: no need to migrate the models 
 - breaking and resolvable automatic migration of existing models 
 - breaking and not resolvable : automatic migration is not available =>
   you have to open it in text editor to solve it

#Global Model Management:  
megamodels: (comes from french), in a megamodel one element in a megamodel represents the whole model, the whole model is represented by one element 
relations, elements ... (metadata repository, configuration file described as a model) they are regulare models=> same tools for manipulating them 
#Model Quality: 

 - motivation: bugs => you want to catch them at the beggining => design
   decisions etc.
 - example property: satisfiability => a model is satisfiable if it is
   possible to create a valid instantiation of the model
 - valid if it satisfies all constraints => more difficult than it seams
   (showing satisfiability is problematic by big models)

##one way for showing satisfiablity  
constraint satisfaction problem (SAT, SMT) => show a model if it exist, prove if not: a simple instance is a proof but you want to create more complex models => If the model is empty than all the constraints are satisfied, because we found a model, which don't have any constraints to satisfied!!!! 
it can be a big fault!!!! be careful!!!! 
 
 
#Collaborative modeling 
=> there are more teams 

 - offline collaboration => svn, git ... => send commits into a repo ...
 long transactions => if you change your model it becames visible if you change the online model

 - online collaboration => google docs, web modeling framework ...
once you make change, it immediatly get commeted => it will be delagated to all other participants 
there were multiple tools which support this:  
challanges:  

 - locks =>if model merge is complex it seems to be a good idea, but
   most program don't lock in a sane way => possibility to do it manually, but you can forget, to unlock these
 - acces control to models more complex than it seems to be 
  e.g.:  

	 - git : everything/nothing     
	 - svn:acces to documents=> you have to split up the models into fragments => not very flexible, mostly working just if you working in a company