MDSD — Lecture 2. (18/02/2015)  
# MDSD Principles – Languages and Models 
3 pillars: Language, Model, X 
 
 
## Model
Representation of a system.  
Only a selection of features/properties of the modelled system. 

- reduced complexity  
- selected the important features/properties 

## Concepts 
- **code**: coding language 
- **model**: modelling language, frameworks, etc.  
- **metamodelling language**: a common language to describe/capture/specify models of a domain
- **code -> bytecode**:
When you use a compiler to generate bytecode (use a higher level of abstraction), you don't want to modify the bytecode itself. The more mature a compiler is, the more it could optimize the code. You may loose optimization by using an abstract layer. But (!) your productivity may increase! 

![Concepts image, so the upper "list" is a bit of an explanation]()

-----

## Modeling Languages 
 
**Domain Specific Languages** (DSLs):  languages that are designed specifically for a certain domain or context. 
DSLs have been largely used in computer science. Examples: HTML, Logo, VHDL, Mathematica, SQL 
 
*Often you knows the domain of your model, so you could crate less expensive language. But you will gain analysability. * 
 
**General Purpose Modeling Languages** (GPMLs, GMLs, or GPLs): languages that can be applied to any sector or domain for (software) modeling purposes. The typical examples are: UML, Petri-nets, or state machines 
 
## Domain Specific Modeling Language 
- **Abstract Model:**
"The Model" -- the core for most of the tools we develop. The tooling is based on this representation. 
- **Concrete Model:** 
Graphical/Textual view of the instance model. You don't need to present every information every time.  
 
### Types of Models 
1. Modelled properties
    - **static models:** structural shape, connection, etc. class diagram, ER-diagram.  
    - **dynamic models:** the dynamic behaviour -- sequence diagram, BPMN, compiler event processing 
2. Purpose/usage
    - **traceability models:** follow the chain of elements and bind the requirements to a part of the system meaning that it is responsible for a specific requirement. And the other way around as well.  
    - **execution trace models:** -- sequence models. The specific run of the system 
    - **analysis models**  
    - **simulation models** 
 
### Metamodeling 
To represent the models itself -- means of abstraction, highlighting the properties of the models. 
MOF -- 4 levels -> there can be more, only the concept of metamodeling is important. 

## Model Transformation 
E.g. transforming COBOL legacy code to newer languages.  
The concept of code transformation, queries exists in the world of models. And between them! Model-to-Model (M2M), M2T (Text), T2T, T2M 

-----

![Image (maybe a simplified one?)]()

-----

First, languages are represented by their metamodel, a precise specification of the language.  The concrete model is formalized with the language/metamodel.  Then the translation rules between the languages/models is described. This expresses, how any of the instance model elements are to be transformed.  Last, these rules are passed by auto transformation engine and the transformation is executed.  

------

![Image]()

------
 
# Domain modeling
- **metamodels**: 
Precise specification of domain language. Language for describing the abstract syntax. 
Aggregation is providing an important concept: container hierarchy.  
  
*Why generalisation instead of inheritance?*  

- in *programing*, we use **top-down** concept 
- in *modelling* we use the opposite, **bottom-up** 

The evolution of the language describes this. 
 
##Type conformance 
 
Each model element is an instance of a metamodel element.  

- **Direct type:** there is no other type exists lower in the hierarchy 
- **Indirect type:** superclass, there is a lower type.  
 
*"is a"* could mean two things:  
- classification (instance of): **not** transitive.  
- generalization (super type of relation): transitive.  
 
In modelling multiple inheritance is possible.  
Restriction (usually): each model element only has single direct type. 
But multiple classification, from multiple domains is allowed. (In class, there are some exceptions.) 
 
### Type conformance of references 
 
**Type conformance** (formally): A link in a model is type conformant, if *type(src(link))* is subtype of *src(type(link))*, *type(trg(link))* is subtype of *trg(type(link))*. 
 
Informally:  
The type of the source object is a subtype of the source class of the link’s type. The type of the target object is a subtype of the target class of the link’s type. 

![I guess we need an image here.]()
 
## Container hierarchy 
- single root element 
- if an element is not contained it won't be saved/serialized 
	- no circular containment 
	- nodes themselves can be in 2 circle in the metamodel.  
 
## Multiplicity restrictions 
upper and lower bounds: 

- 0..1 
- 0..* 
- 1 (usually containment) 
