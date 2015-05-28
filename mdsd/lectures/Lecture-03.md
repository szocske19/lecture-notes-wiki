#Advanced Concepts and Best Practices  
##Derived Features  

 - calculated from others
 - used as helpers, they don't need to be persisted
 - automatically updated/calculated
 - common derived features:
	 - derived attributes - e.g.: age/birth year (you don't need to have two different attributes for age and birth date as the former can be derived from the latter)
	 - derived references - e.g.:dogs = pets ->Dog (an owner's dogs can be derived from their pets - by choosing the ones whose type are Dog)
	 - derived objects - e.g.: Gangs (if you know who knows who, you can derive so called "gangs" - a group of people where everyone knows everyone)


##Enumeration
Fixed set of symbolic values.  
Use them instead of hard-coded strings. (So only a fixed set of things are used.)  

##Build-in classes  
- NOT user defined classes.
- (e.g..: ints)  

##When to avoid Generalization?  

 - When the object lifecycle requires to change the type of the object -> maybe an attribute could express the same.
 - Bad smell - when  you suspect that something is incorrect - you don't know for sure, but it looks suspicious (antipatterns).
 - Advices:
	- attribute name should represent the multiplicity
	- references should be verbs
	- don't extract explicit lists from reference multiplicity (that is, in the domain model it shouldn't be given explicitly what kind of collection should be used - avoid "xxxList" as attribute type)

#EMF (Eclipse Modelling Framework)  
The goal of domain specific modelling is to present (offer) a dedicated notation for every "stakeholder" (for every aspect of the designing), see slide example.  
EMF is a modelling core, that is the base of several technologies.  

## Domain Specific Modeling Language
checklist creating a dsml:

 - Abstract sytax
 - semantics -static/behavioral
 - concrete syntax -visual presentation

[Example image / UML model]
##Concrete Syntax


|  +\ - |graphical notation | textual notation |
|---:|:---------------------- |:--------------------|
|pros | the human mind could process in a parallel way | after a given size reading is easier|
||enforced syntactically correct model |writing is easier (no drag-'n-drop) |
|cons | has to be arranged |sequential|


The main difference between graphical and textual notation: graphical is easier to read, but textual is easier to write.

###Multiplicity of Notations
1 abstract syntax -> many textual and visual notations
1 abstract model -> many concrete forms in 1 syntax  (e.g.: code with tabs/spaces - syntactic sugars)
1 semantic interpretation -> many abstract models

#EMF
meta-metamodel - Ecore
metamodel - Ecore model (Epackage)  
instance model - Application Data (Resource)

## Semantics
Meaning of concepts in a language.  

 - static - what does the model mean?  
 - dynamic - how does the model change/evolve
###Static Semantics
 - interpolation of metamodel elements  
 - mathematical statements …. the interpretation
 - meaning

We would like to have every type as instance without restrictions.  
MM, WCF |= M  (specification |= implementation)  
If you could instantiate the metamodel and it refills the well-formed constraint, the metamodel is consistent.  
It is enough to show one consistent example to prove that the specification is consistent.  
###Dynamic Semantics  
- Operational (e.g.: how the finite automates may change state at runtime)
	- interpreted
	- how the object/model evolves through time
 - Denotational (translational) : translating concepts in own language to another one
(e.g. : state machines as a Petri-net)

EMF provides:  

 - model manipulation API : automatic getters, setters + logical( e.g.: collection methods)
 - editing support (notification, undo … )
	- observer pattern: when an event occurs, it may create a chain of reactions
	- a stack of operation are recorded, so undo-redo could be executed
	- serialization: generic exporting, solution for, every metamodel
	- reflective API : you could change the program programmatically  

## Containment hierarchy
along refernces  
only the contained objects are serialized
##Ecore Metamodel

-----

Eclipse is a free, open-source software development environment and a platform
with extensible plug-in system for customization. Eclipse comes with its own modeling tools, with the core framework called Eclipse Modeling Framework (EMF).

The EMF project is a modeling framework and code generation facility for building tools and other applications based on a structured data model. From a model specification described in XMI, EMF provides tools and runtime support to produce a set of Java classes for the model, along with a set of adapter classes that enable viewing and command-based editing of the model, and a basic editor. EMF (core) is a common standard for data models, many technologies and frameworks are based on. [The Eclipse Project. Eclipse Modeling Framework.](http://www.eclipse.org/emf)


## Ecore

Ecore is the metamodeling language used by EMF. It has been developed in order
to provide an approach for metamodel definition that supports the direct
implementation of models using a programming language. Ecore is the de facto
standard metamodeling environment of the industry, and several domain-specific
languages are defined using this formalism. [scm]

<<< ecore figure >>>

This figure shows only a small fraction of the metamodel, as there is many more classes in the Ecore metamodel. The main classes are the following:

* *EAttribute* represents a named attribute literal, which also has a type.
* *EClass* represents a class, with optional attributes and optional references. To support inheritance, a class can refer to a number of supertype classes.
* *EDataType* is used to represent simple data types that are treated as atomic (their internal structure is not modeled). Data types are identified by their name.
* *EReference* represents a unidirectional association between EClasses and is identified by a name. It is also possible to mark a reference as a containment that represents composition relation between elements. A bidirectional association should be modeled as two EReference instances mutually connected via their opposite references.


An Ecore model has a root object, representing the whole model. The children of this root object are packages, and the children of those are classes.

More detailed illustrations of the metamodel can be found in the [EMF Documentation](http://download.eclipse.org/modeling/emf/emf/javadoc/2.9.0/org/eclipse/emf/ecore/package-summary.html#details).

Sources:
* Text from Dániel Stein. Incremental Static Analysis of Large Source Code Repositories. Bachelor's thesis,Budapest University of Technology and Economics, Budapest, 12/2014 2014.
* [scm] Gábor Szárnyas. Superscalable modeling. Master's thesis, Budapest University of Technology and Economics, Budapest, 12/2013 2013.

-----

## EMF Waterfall
[kép a slide-ról]
generator model - mapping the MM to the implementation -> parameters for the code generator  

 - model: manipulating the model
 - edit: displaying, commands, undo/redo  
 - editor: treeview editor

All of them are generated.
