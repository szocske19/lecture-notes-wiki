Lecture 7.     
#Graphical Concrete Syntax Design for DSLs    
The abstract syntax can be extended with graphical and textual concrete syntaxes. This pont is about the former.     
In case of the textual editors, we enter characers and the Abstract Syntax tree is derived.     
In case of graphical editors, we graphically build the abstract syntax based on the metamodel.    
The editor - which we use to create/edit instances - are required to provide advanced features:     
overview     
copy and paste    
…    
##Technology …    
##Graphical Editor Technologies    
![enter image description here](https://lh3.googleusercontent.com/-kdQJmcDszLI/VVpY-w6f-dI/AAAAAAAAATY/YAGynDIGjiw/s600/technologies.png "technologies.png")  

EMF- GEF low-level Java    
GMF, Graphiti modeling workbenches that support the assembly of DSLs, where we have to write every code    
Sirius - the newest addition, ift was previosly used propuiotely????, it is mature enough from the start.     
##Graphical Modeling     
Graph view of our model: nodes and edges!    
Main concept : Model-View- Contoroller paradigm. with multiple (overview, editor …) views sametimes. The modifications are propagated from models to the views.     
Problem/ complication: the hierarchy containment must be presented. using the presentation libraries.     
Controller: these manipulations have to be wrapped - model mod. is not direct call. The manipulations are wrapped into Command Objects, so undo-redo dommands and alike can be provided.     
### View Models     
The location, color, etc. information is not  stored in the abstract model, but they must be saved somewhere.     
=> separation of the concerns. the code generator is not interested in the color of the node.     
## Technologies    
### GEF     
-not EMF-specific    
### GMF    
provides well-separated view and domain models    
based on GEF and EMF    
complex to start : not much Java coding, but many mapping and other models has a wizard, but it is a lot of work.    
provides the common model for graphical editors  (models)    
figures     
tools     
mapping     
linking these can result in a fully functional editor.     
###Graphiti     
simplified programmatic API every graphity should look and behave allike.     
reputative coding is needed     
spray prject: textual DSC for describing graphical editors.     
###Sirius     
main concept: viewpoints    
every diagram is a view of the model     
graphical     
task/ tree syntax   
Xtext textual syntax   
viewpoint specifications describe:    
viewpoint    
feature provider   
mapping of nodes/edges visualisation   
tools   
### -node and edge mapping describes, what type of  nodes from the abstract syntax (with filtering possibilities)    
and how they should be presented   
mode    
type   
filter   
edge   
source class   
target   
filtering expressions: selecting the nodes, model objets to be presented   
var - model variables   
feature - EMF feature name   
service   
The syntax is the Acceleo or OCL syntax   
Acceleo [expression /]   
#### Node and Edge Tool specification    
The response to a click the command is described in a declarative manner.    
Sirius is an interpreted modeler development framework: it uses reflective API, so it does not have to update every time the specification is changed.    
the editor is not apriori generated   
=> if you change the color repres.  of a node, it is reflected immedately in an opened model editor (that you are currently developing!)   
problems: graphical layout is not trivial   
Textual Editors   
### Technologies   
     
EMF text   
Xtext   
#### Xtext    
Instead of constructing a language from an existing metamodel, Xtext  … uses a metamodel from the language specification.    
=> It is easy to work with   
Xtext uses an already available parsers and …   
   
Grammar consist of :    
nonterminals eg. Num, Digit...   
terminals (alphabet) eg. 1|2| … |0   
Categorisation of Rules:    
regular rules:    
???-> terminal, or    
???-> terminal + nonterminal   
context - free rules:    
?? -> (terminal or nonterminal), or    
?? -> üres halmaz   
Context free: you can apply the rule anytime there are no contextual constraints for application.    
Derivation step:    
??? Find a Sentence and apply applicable rules. : take the left side and replace it with the right side. See example derivation.    
Do this until you arrive a state, everything is a terminal symbol.    
rightmost/leftmost derivation methods:    
witch way you proceed with the derivation.    
<<binary derivation example>>   
The grammar has to be restricted to enhance parsing. We don't want to have the same expression with the different ASP.    
Multiple derivation trees can be parsed, but they should be disambiguate. : New nonterminal symbols have to be introduced.    
The resulting tree is bigger, but is not ambiguous.    
<<example from the slides>>   
tip: shout the right side with a terminal symbol.