#Code Generation 
 - Main goal is improving productivity by reducing the time spent on repetitive activities.
 - It is more general then synthesizing(?) source code. We derive:
	 - documentation
	 - source code
	 - configuration descriptors
	 the(?) specialities of different systems/platforms

	![enter image description here](https://lh3.googleusercontent.com/-oTaLN2UKF6Q/VVpa847ZH4I/AAAAAAAAATo/rGJqi77Rm9A/s600/valamik.png "valamik.png") 
	[Szerintem nem ezt a képet akartuk ide]

	The allocation (optimal allocation) is a complex engineering task.

 - There is a choice between certain attributes:
	- More efficient code can be written manually. But! Efficiency is not the only important property  - some trade-offs have to be made. 
	(There are contradicting requirements, (decisions) /traidings(?) have to be made)
	
	- The level of abstraction is risen, now Java is the low-level language.
 - _Evolution of languages_: design pattern -> code generators use it -> language element.
(Code generators always come from already synthesized code (from  the code **manually** done(?) by a sensor, for us )(???)

## Code Generating Approaches

- dedicated ~ Ad - hoc
	- e.g: python: string outputs pieced together
	- fast and dirty: maintaining is a nightmare, but you rarely modify it
	- zero reuseability
	- if there is no evolution, once it is certified it does not have to be recertified.
- dedicated [kép]
	- the code generator itself is a closed system, but it has a parameter input.
	- slower performance, better reuseablity  
	- black-box approach, where the parameters modify smaller portions of the code, than the template-based approach
		- internally it could use templates.
	- e.g. : SCADE, KC6, MATLAB Simulink, Stateflows  
- template based [kép]
	- "open" generator - one can radically change the behavior of the generator by modifying the templates.
	- parameters may modify the choice of templates  
	- we modify the template to change the behavior of the code  
	- parameters: language, output path, mapping of the source model to the target platform (hu.bme.mit ...), etc. 
	- faster development time: after the templates are already written of course  
	- supports fast-changing environments  
###Direct Source Code Generator  
- linear, single-path generator
- it outputs the source like-by-line.  
- it is driven by the structure of the output
- model-to-code  synchronization:  certain modifications to the code itself gets synched with the model
- in lower levels (C-> Assembly), you don't even try to do this and modify the bytecode (usually).  (?)
#### AST Generation
 - instead of line-by-line serialization, AST generaitation can be done.
	 - AST has the nonterminal nodes
	 - the text have pretty-printing ...(?)
 - non linear process: parts of the code is textualized in different places,  then they are puzzled together.
 - incremental code granularity: only part of the code is generated after a model change, and the affected "puzzle piece" is active

	 - granularity of java: file (compilation unit)
	 - granularity of IncQuery: model change (attribute, reference, (anything that can notify))
	 
###Generator Model
 - for one generator model many input and many output models can be given
 - it stores every additional information
 - helps code generation:
	 - mapping/interlinking/tracing
		 - classname - javafile name + annotations
	 - multiple output stream [kép]
### Model to code synchronization
 - usually with AST using approaches
 - what happens when the generated code is changed?

 
### Manual and generated parts
 
 - rule of Rules: don't override manually changed code
 - don't allow modifications everywhere but have dedicated locations for modifications
 (java does not have c# patial classes)
##Code formatting
_Where to put it?_ 
Model/template/AST _OR_ it should be a separate process by a third-party solution

##Technologies
 - mix of control input and direct target output
	 - JET
	 - Velocity (interpreted)
	 - Xtend(Xpand)

