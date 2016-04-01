# Xtext

![The logo of Xtext](mdsd/2016/xtext/logo.jpg)

homesite: https://eclipse.org/Xtext/

Install Xtext
-------------

Install Xtext 2.9 using the releases update site: http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/

(You can find the link here: https://eclipse.org/Xtext/download.html)

Click Help > Install New Software and complete with next, next finish.

![Install New Software](mdsd/2016/xtext/install.png)

As you can see, we will need Xtend as well.

Create an Xtext language without existing AST metamodel
-------------------------------------------------------

1. Create a new Xtext project with the following name: ```hu.bme.mit.mdsd.erdiagram.text```. Name of the language will be ```hu.bme.mit.mdsd.erdiagram.text.ERDiagramDsl```. It should conform to a fully qualified class name. Extension will be ```er```.

![New project](mdsd/2016/xtext/new-project.png)

You can hit finish, or on the next page you can disable the "Testing support" as we won't need that. This will produce a simple ```Hello``` language with greetings messages. It is worth to check this language.

1. Declare our language

	```
	grammar hu.bme.mit.mdsd.erdiagram.text.ERDiagramDsl with org.eclipse.xtext.common.Terminals
	
	generate eRDiagramDSL "http://www.bme.hu/mit/mdsd/erdiagram/text/ERDiagramDsl"
	```
	
	The ```grammar``` keyword declares the name of our language. The ```with``` keyword defines an inheritance from an other language. In this case, we are inherited from the _Terminals_ language which enables us to use the ```ID``` rule.
	```generate``` keyword is responsible for generating AST metamodel from the language definition. Package name will be _eRDiagramDsl_ and _ns uri_ will be _http://www.bme.hu/mit/mdsd/erdiagram/text/ERDiagramDsl_. Name of the EClasses will be the same as the name of the rules.


1. Entry rule

	Each Xtext language is built up from rules. The entry (or main) rule is the first defined rule which will be the ```ERDiagram``` in our case:
	
	```
	ERDiagram:
		entities+=Entity+
		relations+=Relation*
	;
	```
	
	Syntax: _rule name_ ':' ... ';'
	
	This rule states that our language consists of one or more ```Entity``` object and zero or more ```Relation``` objects (rules). The output of a rule can be stored in AST. To do this, we can define references for AST which will be _entities_ and _relations_ in this case.
	
	```
	' ' -> exatly one
	'*' -> zero, one or more
	'+' -> one or more
	'?' -> zero or one
	
	_reference_  = _eclass_  -> zero or one reference
	_reference_ += _eclass_  -> zero, one or more reference
	_reference_ ?= _keyword_ -> boolean reference
	```
	
	_Note: in this case, 'eClass' equals with a rule name, because the generated AST uses rule names as type names (eClass names)._

1. Attribute type as an enumeration:

	```
	enum AttributeType:
		INT = 'int' | DOUBLE = 'double' | STRING = 'string' | BOOLEAN = 'boolean' | DATETIME = 'datetime'
	;
	```

	We can define enumerable rules which is mapped to an EMF enumeration in the generated AST. It starts with ```enum``` keyword. The key-value pairs are separated by '|' character.

1. 'ID' terminal.

	First definition of _Entity_ rule:
	
	```
	Entity:
		'entity' name=ID ';'?	
	;
	```
	
	Between apostrophe characters, we can define terminals (or keywords) for our language. The 'ID' terminal comes from the _Terminals_ language, and defines a unique identifier rule. An ```Entity``` rule starts with the ```entity``` keyword, than a string comforming to the 'ID' terminal comes from the _Terminals_ language, whic is stored in a _name_ attribute, and finally an optional ';' character (keyword) comes.
	
1. Reference an _instance_ of a rule with `[...]`. Group expressions.
	
	Definition of _Entity_ and _Attribute_ rules:
	
	```
	Entity:
		'entity' name=ID ('isA' isA+=[Entity])*
		('{'
		(attributes+=Attribute) 
		(',' attributes+=Attribute)*
		'}')?
	;
	
	Attribute:
		name=ID ':' type=AttributeType (isKey?='key')?
	;
	```
	
	If we omit the square brackets (`isA+=Entity` instead of `isA+=[Entity]`), then we would have to apply the rule again starting with `entity` keyword, when we would try to use the language. With the square brackets we declare that only a reference is needed to a rule instance: '[' _eclass_ ']'.
	
	_Note: in this case, 'eclass' equals with a rule name, because the generated AST uses rule names as type names._

	We can group expressions with brackets to add cardinality character to the complex grouped expression similarly to the body of the entity we defined: if an entity doesn't have any attribute, then the curly braces can be omitted. 

1. Unordered expressions.

	```
	Relation:
		leftEnding=RelationEnding
		'is related with'		
		rightEnding=RelationEnding
	;
	
	RelationEnding:
		(multiplicity=Multiplicity & (nullable?='nullable')?) target=[Entity]
	;
	
	enum Multiplicity:
		One = "one" | Many = "many"
	;
	```
	
	The '&' character defines an unordered list of the rules.
	In this case, the following solutions are applicable before the entity reference:
	
	 * one nullable
	 * nullable one
	 * many nullable
	 * nullable many
	 * one
	 * many
 
1. The full Xtext code

	```
	grammar hu.bme.mit.mdsd.erdiagram.text.ERDiagramDsl with org.eclipse.xtext.common.Terminals

	generate eRDiagramDsl "http://www.bme.hu/mit/mdsd/erdiagram/text/ERDiagramDsl"
	
	//Entry rule
	ERDiagram:
		entities+=Entity*
		relation+=Relation*
	;

	Entity:
		'entity' name=ID ('isA' isA+=[Entity])*
		('{'
		attributes+=Attribute
		(',' attributes+=Attribute)*
		'}')?
	;

	Attribute:
		name=ID ':' type=AttributeType (isKey?='key')?
	;

	enum AttributeType:
		INT = 'int' | DOUBLE = 'double' | STRING = 'string' | BOOLEAN = 'boolean' | DATETIME = 'datetime'
	;

	Relation:
		leftEnding=RelationEnding
		'is related with'
		rightEnding=RelationEnding
	;

	RelationEnding:
		(multiplicity=MultiplicityType & (nullable?='nullable')?) target=[Entity]
	;

	enum MultiplicityType:
		One = 'one' | Many = 'many'
	;
	```

Building infrastructure
-----------------------

When you modify your _xtext_ files, you have to build the infrastructure for your language. The following figure shows where to click to generate.

![Generate infrastructure](mdsd/2016/xtext/generate_infrastructure.png)

Try our new language
--------------------

1. Start a runtime Eclipse.

1. Create a general project

	_New->Project...->General->Project_ Name: hu.bme.mit.mdsd.erdiagram.text.example
	
	![General Project](mdsd/2016/xtext/general_project.png)

1. Create a file with 'er' extension

	_New->File_ Name: example.er 
	
	![General File with 'er' extension](mdsd/2016/xtext/general_file.png)
	
	Add xtex nature in the pop-up window.
	
	![Xtext nature pop-up](mdsd/2016/xtext/xtext_nature.png)

1. (Optional, if you missed the pop-up window) Add Xtext nature

	Right click on project -> Configuration -> Add Xtext nature

1. Now, you can try out the language. Notice that you can use auto completion and quick fixes as well.

Check out the generated AST
---------------------------

1. Create an example file with 'er' extension and fill it with the following content:

	```
	entity person {
		name : string,
		id : int key
	}

	entity driver isA person {
		licence : string
	}
	
	entity car {
		numberPlate : string key
	}
	
	one person is related with nullable many car
	```

1. Open with Simple Ecore Model Editor

	Right click on the file -> Open -> Open with... -> Simple Ecore Model Editor
	
	![Open with Simple Ecore Model Editor](mdsd/2016/xtext/ecore_editor.png)
	
	This will show you the AST built from the text.
	
	![AST of the text](mdsd/2016/xtext/tree-editor.png)


	
Scoping
-------

Scoping defines which elements are referable by a given reference. For instance, we don't want to enable self inheritance.

1. Open our scope provider

	![Scope Provider](mdsd/2016/xtext/scoping.png)

1. Create the following method:

	```java
	class ERDiagramDslScopeProvider extends AbstractERDiagramDslScopeProvider {

		override IScope getScope(EObject context, EReference reference) {
			if (context instanceof Entity) {
				return Scopes.scopeFor(
					(context.eContainer as ERDiagram)
					.entities.filter[x | x != context]
				)
			}
			return super.getScope(context, reference)
		}

	}
	```
	
	This scope restrict the available objects for the _isA_ reference of all the _Entity_ EClass. The ```Scopes``` class contains static methods to create scope descriptions from a list of EObjects.
	
	_Note: This is an Xtend file, simple Java code is generated under the xtend-gen folder (further description about the language can be found here: http://eclipse.org/xtend/)_

1. Check out in our example (Runtime Eclipse, example.er file).

Validation
----------

Static analysis is always required for any language. In this example, we want to raise an error if a cycle occurs in the inheritance graph.

1. Open the validator Xtend file (ERDiagramDslValidator.xtend).
	
1. A validation method for given type requires the following things: `@Check` annotation, one parameter with the correct type, using the `error`, `warning` or `info` methods to create markers on the editor.

	```java
	class ERDiagramDslValidator extends AbstractERDiagramDslValidator {

		Set<Entity> entitiesAlreadyChecked = new HashSet

		@Check
		def checkCyclicInheritance(Entity entity) {
			checkCyclicInheritance2(entity)
			entitiesAlreadyChecked.clear
		}
	
		def checkCyclicInheritance2(Entity entity) {
			entitiesAlreadyChecked += entity
			for (parent : entity.isA) {
				if (entitiesAlreadyChecked.contains(parent)) {
					error("Cyclic inheritance is not allowed.", 						
						ERDiagramDslPackage.Literals.ENTITY__IS_A)
					return;
				}
				checkCyclicInheritance2(parent)
			}
		}
	
	}
	```
	
	_Note: in a real project much more validation would be needed._

1. Check out in our example (Runtime Eclipse, example.er file)

Create an Xtext language with existing AST metamodel
----------------------------------------------------

1. Import the projects from [here](projects/incquery-metamodel.zip).
1. Switch the AST line

	From (this line implies to generate AST metamodel):	
	```
	generate eRDiagramDSL "http://www.bme.hu/mit/mdsd/erdiagram/text/ERDiagramDSL"
	```
	
	To (this line imports our metamodel):
	```
	import "platform:/resource/hu.bme.mit.mdsd.erdiagram/model/erdiagram.ecore" as er
	```
	
	The metamodel can be access via _er::_ prefix.
	
1. Change return values of rules and correct the reference and attribute names:

	```
	grammar hu.bme.mit.mdsd.erdiagram.text.ERDiagramDSL 
	with org.eclipse.xtext.common.Terminals
	
	import "platform:/resource/hu.bme.mit.mdsd.erdiagram/model/erdiagram.ecore" as er
	
	ERDiagram returns er::EntityRelationDiagram:
		attributetypes+=AttributeType*
		entities+=Entity+
		relations+=Relation*
	;
	
	Relation returns er::Relation:
		'relation'
		leftEnding=RelationEnding
		rightEnding=RelationEnding
	;
	
	RelationEnding returns er::RelationEnding:
		target=[er::Entity] 
		'(' 
		(multiplicity=Multiplicity & 
			(nullable?='nullable')?
		) ')'
	;
	
	enum Multiplicity returns er::MultiplicityType:
		One = "One" | Many = "Many"
	;
	
	Entity returns er::Entity:
		'entity' name=ID ('isA' isA+=[er::Entity])? 
		'{' 
		((attributes+=Attribute) 
		(',' attributes+=Attribute)*)?
		'}'
	;
	
	Attribute returns er::Attribute:
		name=ID ':' type=[er::AttributeType] (isKey?='key')?
	;
	
	AttributeType returns er::AttributeType:
		'type' name=ID ';'?
	;
	```	

1. Do not forget to delete the exported packages in the MANIFEST.MF and to rebuild the infrastructure
1. Finished
	From now, the language uses our metamodel to build AST

References
==========

* detailed documentation: https://eclipse.org/Xtext/documentation/

	