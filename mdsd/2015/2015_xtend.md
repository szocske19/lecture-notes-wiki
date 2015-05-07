




## Xtend

"Xtend is a flexible and expressive dialect of Java, which compiles into readable Java 5 compatible source code." [1]

* [1] https://eclipse.org/xtend/

![The logo of Xtend](mdsd/2015/xtend/xtend-logo.png)


## Entities code generator

1/. Import the [ERDiagram metamodel](projects/incquery-metamodel.zip) and the [example model](mdsd/2015/xtend/example.erdiagram).
2/. Create a new plug-in project with the name hu.bme.mit.mdsd.codegen
3/. Add the next dependencies to the MANIFEST file: ``org.eclipse.xtend.lib``, ``hu.bme.mit.mdsd.erdiagram``
4/. Create a new Xtend class with the name EntitiesGenerator

5/. Create a constructor which needs an ``EntityRelationDiagram`` as a parameter and save it to a field:

```java
EntityRelationDiagram model

new(EntityRelationDiagram model) {
	this.model = model
}
```

Learning about Xtend:
* Semicolons are optional
* The constructor is defined with the ``new`` keyword


6/. Create a method called ``createClassFromEntity``:

```java
def createClassFromEntity(Entity entity)'''
class «entity.name» {

}
'''
```

Learning about Xtend:
* Methods are defined with the ``def`` keyword
* No need of specifying the method return type
* Text written between ``'''`` will return with a ``CharSequence``
* Expressions written between ``« »`` will be replaced by its result as String
* Getter and setter methods can be called without their prefix ``get`` and ``set``
* A parameterless method can be called without the brackets at the end

7/. Add inheritance (will allow only single inheritance for now, multiple inheritance could be done via using interface as EMF does):

```java
class «entity.name» «IF !entity.isA.empty»extends «entity.isA.get(0).name»«ENDIF» {
```

Learning about Xtend:
* Conditional text template should be written in the following way: ``«IF expression» text template «ENDIF»``
* For loops can be used similarly with the ``FOR`` keyword

8/. Add the attributes as private fields to the class in a for loop expression:

```java
«FOR atr : entity.attributes»
	private «atr.type.name» «atr.name»;
«ENDFOR»
```

9/. Create their getter and setter methods:

```java
«FOR atr : entity.attributes»	
	public «atr.type.name» get«atr.name.toFirstUpper»() {
		return «atr.name»;
	}
	
	public void set«atr.name.toFirstUpper»(«atr.type.name» «atr.name») {
		this.«atr.name» = «atr.name»;
	}
«ENDFOR»
```

Learning about Xtend:
* toFirstUpper() is an extension method, which are highlighted with brown colour. Extension methods are static methods with at least one parameter and they can be called on instances of the first parameter type. i.e. These expressions are equivalent: ``atr.name.toFirstUpper``, ``toFirstUpper(atr.name)``

10/. Create a helper method for retrieving the opposite ``RelationEnding``s of an entity.

```java
def getRelationEndings(Entity entity) {
	model.relations.filter[leftEnding.target.equals(entity) || rightEnding.target.equals(entity)].map[
		if (leftEnding.target.equals(entity))
			rightEnding
		leftEnding
	]
}
```

Learning about Xtend:
* The ``filter`` and ``map`` methods are extension methods and are used when working with collections. They are similar to the ones found in the Java 1.8 stream API.
* You can write lambda expressions between the ``[ ]`` brackets. 

11/. Add relations as private fields, with appropriate getter and setter methods to the class:

```java
«FOR relationEnding : entity.relationEndings»
	«IF relationEnding.multiplicity.equals(MultiplicityType.MANY)»
		private List<«relationEnding.target.name»> «relationEnding.name»;
		public List<«relationEnding.target.name»> get«relationEnding.name.toFirstUpper»() {
			if («relationEnding.name» == null)
				«relationEnding.name» = new ArrayList<«relationEnding.target.name»>();
			return «relationEnding.name»;
		}
	«ELSE»
		private «relationEnding.target.name» «relationEnding.name»;
		public «relationEnding.target.name» get«relationEnding.name.toFirstUpper»() {
			return «relationEnding.name»;
		}
		public void set«relationEnding.name.toFirstUpper»(«relationEnding.target.name» «relationEnding.name») {
			this.«relationEnding.name» = «relationEnding.name»;
		}
	«ENDIF»
«ENDFOR»
```

12/. Finally add the required package declaration and imports:

```java
val packageName = "hu.bme.mit.mdsd.codegen.enerated"

def createClassFromEntity(Entity entity)'''
package «packageName»;
	
«IF entity.relationEndings.exists[multiplicity.equals(MultiplicityType.MANY)]»
	import java.util.List;
	import java.util.ArrayList;
«ENDIF»
	
class [...]
```


Learning about Xtend:
* ``val`` is a keyword for final variable, the type is computed from the right hand side.
* Use ``var`` for modifiable variables.
* Use the ``@Accessors`` annotation on a field or class to generate getter and setter methods automatically. You can also set their visibility by passing parameters to the annotation.

```java
@Accessors String packageName = "hu.bme.mit.mdsd.codegen.enerated"
```


## Running the code generator

1/. Add the following dependencies to the MANIFEST file
* ``org.eclipse.core.resources``
* ``org.eclipse.equinox.registry``


2/. Download and import this Java class and plug-in project:
* [CodeGeneratorHelper](mdsd/2015/xtend/CodeGeneratorHelper.java) - this class holds helper methods for creating Java files, put it next to the xtend file
* [hu.bme.mit.mdsd.genbutton](mdsd/2015/xtend/genbutton.zip) - this plug-in project adds a button to the toolbar


3/. Create this method in the Xtend class, it will create the Java file for each entity.


```java
def generateEntities() {
	for(entity : model.entities) {
		CodeGeneratorHelper.createJavaFile(model.eResource, packageName, entity.name.toFirstUpper, entity.createClassFromEntity)
	}
}
```

4/. Add this two lines of code to the CodeGeneratorCommandHandler (find it in the recently imported project)

```java
EntitiesGenerator generator = new EntitiesGenerator(model);
generator.generateEntities();
```

5/. Start a runtime Eclipse, import the codegen project, open the example model in the tree editor, select the EntitiRelationDiagram root element and click the "Generate entities" button. Find the newly generated Java files on the src folder.


### Summary for code generation

With Xtend you can have template based text (code, configuration, documentation, etc.) generators. For that you have to define a method which processes the template, call it and write the results into a file.

However, Xtend is not explicitly design for code generation. Other template base code generation technologies such as Acceleo (Eclipse based technology) and T4 Text Templating (Microsoft .NET based technology) have support for where to generate the files.


## IncQuery Java API

We would like to check the well-formedness constraints (written in IncQuery) on the ER diagram instance model before code generation. To do this we will use the IncQuery Java API.

1/. Create a new IncQuery project and name it hu.bme.mit.mdsd.erdiagram.patterns, then add the hu.bme.mit.mdsd.erdiagram plug-in project as a dependency.

2/. Create a constraints.eiq file under the hu.bme.mit.mdsd.erdiagram.patterns package, then write a well-formedness constraint for ER diagrams.

```java
package hu.bme.mit.mdsd.erdiagram.patterns

import "erdiagram";

pattern relationHasTwoEnding(relation:Relation){
	Relation.leftEnding.target(relation, _);
	Relation.rightEnding.target(relation, _);
}

pattern relationWithoutEndings(relation:Relation){
	neg find relationHasTwoEnding(relation);
}
```

3/. Save it and see the generated Java files in the src-gen folder:

* [PatternName]QuerySpecification.java - Represents a pattern, containing its name, parameters, body, annotations, etc.
* [PatternName]Match.java - Represents a match of a pattern (parameters) on an instance model, containing references to the EObjects.
* [PatternName]Matcher.java - Basically a query specification initialized on a concrete instance model. The match set can obtained from it.
* [PatternName]Processor.java - Abstract class for defining an action on match.
* Constrains.java - IncQuery also generates a class for every .eiq file containing the QuerySpecifications in a list.

4/. Add this IncQuery plug-in project and the org.eclipse.incquery.runtime plug-in as a dependency to the .codegen project.

5/. Create this class and see the usage of the IncQuery Java API:

```java
package hu.bme.mit.mdsd.codegen;

import hu.bme.mit.mdsd.erdiagram.patterns.RelationWithoutEndingsMatcher;
import hu.bme.mit.mdsd.erdiagram.patterns.util.RelationWithoutEndingsProcessor;
import hu.bme.mit.mdsd.erdiagram.patterns.util.RelationWithoutEndingsQuerySpecification;

import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.emf.EMFScope;
import org.eclipse.incquery.runtime.exception.IncQueryException;

import ERDiagram.Relation;

public class CheckConstraints {
	
	public static boolean checkConstraints(Notifier model) throws IncQueryException{
		EMFScope scope = new EMFScope(model);
		IncQueryEngine iqe = IncQueryEngine.on(scope);
		
		RelationWithoutEndingsMatcher matcher = iqe.getMatcher(RelationWithoutEndingsQuerySpecification.instance());
		
		matcher.forEachMatch(new RelationWithoutEndingsProcessor() {
			@Override
			public void process(Relation pRelation) {
				System.out.println("Relation without relation ending " + pRelation);
			}
		});

		if(matcher.countMatches() > 0){
			return false;
		}
		
		return true;
	}
}
```

6/. Call this method before generating the Java classes on the model and only generate the Java classes if the above method returns true.

7/. In a runtime Eclipse add an empty relation to the model and observe that it doesn't generate the Java classes as the well-formedness constraint is violated.


[The final projects can be downloaded from here.](projects/codegen-final.zip)