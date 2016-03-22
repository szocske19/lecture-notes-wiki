EMF-IncQuery (Pattern Language)
===============================

The latest and last release of EMF-IncQuery is v1.1. Since March 1st, EMF-IncQuery is merged into the VIATRA project and it's new name is VIATRA Queries. You can read this [blog post](http://viatra.net/news/2016/2/say-goodbye-to-emf-incquery-say-hello-to-viatra-query) for more details.

In this course, we will use EMF-IncQuery v1.1 but you are free to use VIATRA Queries v1.2 in your homework by using the integration or CI updatesites. Milestone build will available at the end of April according to the plans.

![The logo of EMF-IncQuery](mdsd/2016/incquery/logo.png)

homesite: https://www.eclipse.org/incquery/

Install EMF-IncQuery
--------------------

Navigate to the homesite of VIATRA and search for update sites at the download page:
https://eclipse.org/viatra/downloads.php

Find the old EMF-IncQuery _release_ update site and copy it to your clipboard (don't leave white space):
http://download.eclipse.org/viatra/incquery/updates/release

Switch back to your Eclipse instance and select the _Help/Install New Software..._

![Select _Help/Install New Software..._](mdsd/2016/incquery/install.png)

Paste the copied URL to the _Work with_ field, than press _Enter_. When the view is updated, select the _EMF-IncQuery SDK_. Tick the _Contact all update sites during install..._ field. Press _Next_, then _Next_ and finally _Finish_.
After the install process, you should restart Eclipse.

![Install window](mdsd/2016/incquery/install2.png)

For a faster installation, advanced users can untick out the _Contact all update sites during install..._ field, but they have to install _Xtend_ and _Xtext_ technologies manually.

Setup the Laboratory
--------------------

1. Clone and import the following projects from this git repository: https://github.com/FTSRG/mdsd-examples

	```
	hu.bme.mit.mdsd.erdiagram
	hu.bme.mit.mdsd.erdiagram.edit
	hu.bme.mit.mdsd.erdiagram.editor
	```

1. Run as **Eclipse Application**. (Normally, this is not required to develop queries, but we will use the Query Explorer, which needs our erdiagram ecore model installed)
1. Import the following project to the runtime Eclipse and check the instance model.

	```
	hu.bme.mit.mdsd.erdiagram.examplediagrams
	hu.bme.mit.mdsd.erdiagram.example
	```

1. Create a new IncQuery project in the host Eclipse and name it to ```hu.bme.mit.mdsd.erdiagram.queries```.
1. Create a new query definition in a package named ```hu.bme.mit.mdsd.erdiagram.queries``` and a file named ```queries.eiq```. Also add two simple queries (and don't forget to save and build):
    
	```java
	package hu.bme.mit.mdsd.erdiagram.queries
	
	// The following imports the ecore model,
	// you can use auto-completion by hitting ctrl+space after the quotation mark
	import "hu.bme.mit.mdsd.erdiagram"

	pattern entity(e){
		Entity(e);
	}

	pattern entityName(entity, name) {
		Entity.name(entity, name);
	}
	```

As you can see, every pattern have a unique name and several parameters. Inside the body of the patterns, there are different _constraints_. Our first example describes a type constraint and the second one a feature constraint. It states that ``entity`` variable is of eClass ``Entity`` and its ``name`` attribute is the value of ``name`` variable.

Query Explorer
--------------

**Query Explorer** is the primary debug tool for debugging IncQuery patterns at runtime. To open the view: _Window/Show View/Others/EMF-IncQuery/Query Explorer_ or you can simply press the _CTRL + 3_ shortcut and start to type the name of the view. On the left side of the view, there will be patterns inherited from the host eclipse. The middle part will show you the matches of the patterns. To achieve this, we have to load a model into the view:

1. Make sure to save and leave the focus on the opened queries.eiq file.
1. Press the green arrow button on the view.
1. Open our example instance model (_My.erdiagram_).
1. Press the green arrow button on the view.

![Query Explorer](mdsd/2016/incquery/query_explorer.png)

You can also filter the match set by using the panel at the right side of the query explorer.

![Query Explorer](mdsd/2016/incquery/filter.png)

Pattern Language
----------------

1. To get familiar with the language let's write a few validation queries, ill-formedness constraints and well-formedness constraints. Firstly, create a query to checks if the name of a ``NamedElement`` is only an empty string:

	```java
	pattern emptyNamedElement(element: NamedElement) {
		NamedElement.name(element, "");
	}
	```

	This pattern shows, that the parameters can be typed immediately in the parameters list.	

1. Create a query to check if two entity has the same name:

	```java
	pattern sameNamedEntities(entity1, entity2, commonName) {
		Entity.name(entity1, commonName);
		Entity.name(entity2, commonName);
		entity1!=entity2;
	}
	```
	
	This pattern shows the ``!=`` (_not equal_) operator to select two different entites from the instance model. (Use the ``==`` operator to equality)

1. Create a query to check if the name starts with a noncapital letter:

	```java
	pattern entityStartsWithSmallCase(entity) {
		Entity.name(entity, name);
		check (!name.matches("^[A-Z].+"));
	}
	```
	
	This pattern shows the ``check`` block where you can write a wide range of _Xbase_ expressions (similar to Java). In this case, we define a regular expression.

1. The previous queries were ill-formedness constraints. Now let's create a well-formedness constraint, which checks if an entity is well-formed. 

	This pattern shows how to reuse previously defined patterns as sub patterns. To do this, we use the ```find``` keyword then write the id of the sub pattern and finally add the variables. (Variables starting with ```_``` define _don't care_ variables, hence you cannot use them in other lines of the pattern). 

	This pattern also shows how to connect independent bodies in a pattern. To do this, we use the ```or``` keyword that states the pattern has a match if the first _or_ the second _or_ the third _or_ etc body has a match.

	```java
	pattern badEntity(entity) {
		find emptyNamedElement(entity);
	} or {
		find entityStartsWithSmallCase(entity);
	} or {
		find sameNamedEntities(entity, _, _);
	}
	```

	A well-formed constraint ensures that there are no ill-formed structures, hence there are no matches of the ``badEntity``. For that, we can use the ``neg`` key word. 

	```java
	pattern wellFormedEntites() {
		neg find badEntity(_);
	}
	```

1. Next, create a well-formedness constraint for ``Relation``s, checking if it has both ``RelationEnding``s. This will need several helper patterns too.

	```java
	pattern relationWithLeftEnding(r, rle) {
		Relation.leftEnding(r, rle);
	}
	pattern relationWithRightEnding(r, rre) {
		Relation.rightEnding(r, rre);
	}
	// It is required to have at least one positive constraint on a variable:
	pattern relationWithoutEnding(r : Relation) {
		neg find relationWithLeftEnding(r, _);
	} or {
		neg find relationWithRightEnding(r, _);
	}
	pattern wellFormedRelation() {
		N == count find relationWithoutEnding(_);
		N == 0;
	}
	```

	Notice, that using ``neg find`` is equal to using the ``count`` keyword and ensure it "returns" zero.


1. We can also get the number of attributes of an entity:

	```java
	pattern entityAttribute(e, attr) {
		Entity.attributes(e, attr);
	}

	pattern attributeCount(e, N) {
		Entity(e);
		N == count find entityAttribute(e, _);
	}
	```

1. Let's find the entity that is first in the alphabet: 

	```java
	pattern hasBiggerName(e1, e2) {
		Entity.name(e1, name1);
		Entity.name(e2, name2);
		check(name1 > name2);
	}
	
	pattern firtEntity(e : Entity) {
		neg find hasBiggerName(e, _);
	}
	```

1. Let's find all the super entities of an entity by using transitive closure.

	```java
	pattern superEntity(e,superEntity){
		Entity.isA(e,superEntity);
	}
	
	pattern allSuperEntity(e,superEntity) {
		find superEntity+(e, superEntity);
	}
	```

   
Validation
----------

EMF-IncQuery provides facilities to create validation rules based on the pattern language of the framework. These rules can be evaluated on various EMF instance models and upon violations of constraints, markers are automatically created in the Eclipse Problems View.

The **@Constraint** annotation can be used to mark a pattern as a validation rule. If the framework finds at least one pattern with such annotation.

Annotation parameters:
 * _key:_ The parameters, which the constraint violation needs to be attached to.
 * _message:_ The message to display when the constraint violation is found. The message may refer the parameter variables between $ symbols, or their EMF features, such as in $Param1.name$.
 * _severity:_ "warning" or "error"
 * _targetEditorId:_ An Eclipse editor ID where the validation framework should register itself to the context menu. Use "*" as a wildcard if the constraint should be used always when validation is started.
 
To find a specific editor id, we can use the _Plug-in Selection Spy_ tool with a _SHIFT + ALT + F1_ shortcut. Or you can just check plugin.xml in ``hu.bme.mit.mdsd.erdiagram.editor`` project.

![Plug-in Selection Spy](mdsd/2016/incquery/spy.png)

Create a constraint, using the sameNamedEntities pattern:

```java
@Constraint(
	key = {"entity1", "entity2"},
	severity = "error",
	message = "Two entities has the same name $commonName$",
	targetEditorId = "hu.bme.mit.mdsd.erdiagram.presentation.ErdiagramEditorID"
)
pattern sameNamedEntities(entity1, entity2, commonName) {
	Entity.name(entity1, commonName);
	Entity.name(entity2, commonName);
	entity1 != entity2;
}
```

After build a `.validation` plugin project will be generated. Let's start a runtime Eclipse to install the validation plugin. After opening the model, select **EMF-IncQuery Validation | Initialize EMF-IncQuery Validators on Editor**. May be you have to do that twice.

![Plug-in Selection Spy](mdsd/2016/incquery/validation.png)

The following errors should appear (if you double click on the error, it will select the problematic EClasses):

![Plug-in Selection Spy](mdsd/2016/incquery/validation2.png)

The two errors mark the same error. To solve this, add the following parameter to the constraint annotation:

`symmetric = {"entity1", "entity2"}`

After that, it will work as intended:

![Plug-in Selection Spy](mdsd/2016/incquery/validation3.png)

Derived features
----------------

Let's create a derived feature between the ``RelationEnding``s, which returns the other ``RelationEnding`` of their parent ``Relation``. For that the following three steps are required:

1. Define a one way relation between ``RelationEnding``s with multiplicity of [0..1] and name it ``otherEnding``. Then set the following attributes of the feature:
 * derived = true (to indicate that the value of the feature is computed from the model)
 * changeable = false (to remove setter methods)
 * transient = true (to avoid persisting the value into file)
 * volatile = true (to remove the field declaration in the object)

 ![Derived Feature](mdsd/2016/incquery/derivedFeature.png)

 Don't forget to save the model and regenerate the model code!

1. EMF-IncQuery supports the definition of efficient, incrementally maintained, well-behaving derived features in EMF by using advanced model queries and incremental evaluation for calculating the value of derived features and providing automated code generation for integrating into existing applications.

 The **@QueryBasedFeature** annotation can be used to mark a pattern as a derived feature realization. If the framework can find out the feature from the signature of the pattern (_patter name_, _first paramter type_, _second paramter type_), the annotation parameters can be empty.

 Annotation parameters:
 * feature ="featureName" (default: pattern name) - indicates which derived feature is defined by the pattern
 * source ="Src" (default: first parameter) - indicates which query parameter (using its name) is the source EObject, the inferred type of this parameter indicates which EClass generated code has to be modified
 * target ="Trg" (default: second parameter) - indicates which query parameter (using its name) is the target of the derived feature
 * kind ="single/many/counter/sum/iteration" (default: feature.isMany?many:single) - indicates what kind of calculation should be done on the query results to map them to derived feature values
 * keepCache ="true/false" (default: true) - indicates whether a separate cache should be kept with the current value. Single and Many kind derived features can work without keeping an additional cache, as the EMF-IncQuery RETE network already keeps a cache of the current values.

 Let's create the pattern, which finds the other ending and annotate it with ``QueryBasedFeature``:

	```java
	@QueryBasedFeature
	pattern otherEnding(ending : RelationEnding, other : RelationEnding) {
		Relation.leftEnding(relation, ending);
		Relation.rightEnding(relation, other);
	} or {
		Relation.rightEnding(relation, ending);
		Relation.leftEnding(relation, other);
	}
	```
 Save and build. IncQuery will modify the Ecore model with an annotation.

 ![Generated Ecore Annotation](mdsd/2016/incquery/ecore-annotation.png)

1. Reload the ecore model for the genmodel and regenerate the model code. Now if you use the ``relationEnding.getOtherEnding()`` on the model, it will return the correct ``RelationEnding``. Note that you will need additional initialization code for IncQuery, or run it as a JUnit Plug-In test.

Advanced Queries
----------------

1. Create a pattern that detects a circle in the type hierarchy:

    ```java
	pattern circleInTypeHierarchy(entity) {
		find allSuperEntities(entity, entity);
	}
	```

1. Create a pattern that detects a (transitive) diamond in the type type hierarchy:

	```java
	pattern diamondInTypeHierarchy(entity1, entity2, entity3, entity4) {
		find allSuperEntities(entity1,entity2);
		find allSuperEntities(entity1,entity3);
		entity2 != entity3;
		find allSuperEntities(entity2,entity4);
		find allSuperEntities(entity3,entity4);
	}
	```

1. Every diamond has matched at least two times. This should be prevented if we make the pattern assimetric by defining somehow that ``entity2 < entity3``. Let us define an ordering relation between the entities:

    ```java
	pattern order(a, b) {
		Entity.name(a, name1);
		Entity.name(b, name2);
		check(
			name1.compareTo(name2) < 0
		);
	}
	```
	
	And change the diamond code:
	
	```java
	pattern diamondInTypeHierarchy(entity1, entity2, entity3, entity4) {
		find allSuperEntities(entity1,entity2);
		find allSuperEntities(entity1,entity3);
		//entity2 != entity3;
		find order(entity2, entity3);
		find allSuperEntities(entity2,entity4);
		find allSuperEntities(entity3,entity4);
	}
	```

1. By the way, calculate the infimum of the order:
    
	```java
	pattern FirstInOrder(first: Entity) {
		neg find order(_, first);
	}
	```
1. Extend the patterns to get the inherited relations and attributes too:

    ```java
	pattern attribute(entity, attribute) {
		Entity.attributes(entity,attribute);
	} or {
		find allSuperEntities(entity, superEntity);
		find attribute(superEntity, attribute);
	}
	```

    and

    ```java
	pattern relation(entity1, entity2) {
		Relation.leftEnding.target(relation, entity1);
		Relation.rightEnding.target(relation, entity2);
	} or {
		find allSuperEntities(entity1, superEntity);
		find relation(superEntity, entity2);
	}
	```
	
References
----------

* Pattern Language: https://wiki.eclipse.org/EMFIncQuery/UserDocumentation/QueryLanguage
* Validation Framework: https://wiki.eclipse.org/EMFIncQuery/UserDocumentation/Validation
* Query Based Features: https://wiki.eclipse.org/EMFIncQuery/UserDocumentation/Query_Based_Features