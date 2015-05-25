Lecture 8    
#Code Generation 
Main goal is importing productivity by reducing the time spent on repetitive activities.    
It is more general then synthetizing source code. We derive:    

 - documentation
 - source code

 
configuration descriptors the specialities of different systems/platforms   
![enter image description here](https://lh3.googleusercontent.com/-oTaLN2UKF6Q/VVpa847ZH4I/AAAAAAAAATo/rGJqi77Rm9A/s600/valamik.png "valamik.png")
The allocation (optimal allocation) is a complex engineering task.    
There is a choice between certain attributes:    
       
     
more efficient code can be written manually But! efficiency is not the only important property  - source trade-offs have to be made. (There are contradicting requirements, (decisions) /traidings have to be made)    
The level of abstraction is rised, now Java is the low-level language.    
Evolution of languages:    
design pattern -> code generators use it -y language element.    
(Code generators always come from already synthesised code (from  the code manually draw??? by a sensor, for us )   
## Code Generating Approaches    
dedicated    
template-based   
dedicated ~ Ad - hoc    
e.g: python: string outputs pieced together   
fast and dirty:    
maintaining is a nightmare, but you rarely modify it    
zero reuseability   
if there is no evolution, once it is certified it does not have to be rcertified.    
dedicated    
the code generator itself is a closed system, but it has a parameter input.   
slower performance, better reuseablity  
black-box approach, where the parameters modify smaller partiions of the code, than the template-based approach  
internally it could use templates.   
e.g. : SCADE, KC6, MATLAB Simulink, Stateflows  
template based  
"open" generator -one can radically change the behaviour of the generator by modifiing the templates.   
parameters may modify the choice of the templates  
we modify the template to change the behavior of the code  
parameters: language output path mapping of the source model to the target platform (hu.bme.mit ...)  
faster development time: agter the templates are already written of course  
supports fast-changing environments  
###Direct Source Code Generator  
linear, single-path generator 
it outputs the source like-by-line.  
it is driven by the stucure of the output 
model - to -code  synchronisation certain modifications to the code itself gets sy.. with the model 
in lower levels (C-> Assembly), you don't even try to do this and modify the bytecode (usually).  
#### AST Generation 
 - instead of line-by-line serialization, AST generaitation can be done.
	 - AST has the nonterminal models
	 - the text have pretty - printing (minentudó)
 - non linear process: parts of the code is textualised in different
   places.  then tey are puzzled together.
 - incremental code granularity: only port of the code is generated
   after a model chage, and the affected "puzzle piece" is active
   
	 - granularity of java: file (compilation unit)	
	 - granularity of Incquery: model change (attribute, reference, (anything that can notify))
###Generator Model
 - for one generator model many inputs and many outputs can be given
 - it stores every additional information
 - helps code generation: 
	 - mapping/interlinking/tracing
		 - classname - javafile name + annotations	 
	 - multiple output stream
### Model to code synchronization
 - usually with AST using approaches
 - what happens when the generated code is changed?
 ### Manual and generated parts
 
 - rule of Rules: don't override manually changed code
 - don't allow modifications everywhere but have dedicated locations for modifications 
 (java does not have c# patial classes) 
##Code formatting
 where to put it? model/template/AST or it should be a separate process by a third-party solution
##Technologies
 - mix of control input and detect??? target output
	 - JET
	 - Velocity interpreter
Xtend(Xpand)