EMF-IncQuery (Pattern Language)
===============================

![The logo of EMF-IncQuery](mdsd/2015/incquery/logo.png)

homesite: https://www.eclipse.org/incquery/

Install EMF-IncQuery
--------------------

Navigate to the homesite of IncQuery and search for update sites at the download page:
https://www.eclipse.org/incquery/download.php

Copy the URL of _Release builds_ update site:
http://download.eclipse.org/incquery/updates/release

Switch back to your Eclipse instance and select the _Help/Install New Software..._

![Select _Help/Install New Software..._](mdsd/2015/incquery/install.png)

Paste the copied URL to the _Work with_ field, than press _Enter_. When the view is updated, select the _EMF-IncQuery SDK_. Tick the _Contact all update sites during install..._ field. Press _Next_, then _Next_ and finally _Finish_.
After the install process, you should restart Eclipse.

![Install window](mdsd/2015/incquery/install2.png)

For a faster installation, advanced users can untick out the _Contact all update sites during install..._ field, but they have to install _Xtend_ and _Xtext_ technologies manually.

Setup the Laboratory
--------------------

1. Import the projects from [here](projects/incquery-metamodel.zip).
1. Run as **Eclipse Application**.
1. Import the project from [here](projects/incquery-example.zip) to the runtime Eclipse and check the instance model.
1. Create a new IncQuery project in the host Eclipse and name it to ```hu.bme.mit.mdsd.erdiagram.queries```.
1. Create a new query definition in a package named ```hu.bme.mit.mdsd.erdiagram``` and a file named ```queries.eiq```. In the wizard create an empty query. Fill the first query:
    
	```java
	package hu.bme.mit.mdsd.erdiagram
	
	import "hu.bme.mit.mdsd.erdiagram"

	pattern entityWithName(entity, name) {
		Entity.Name(entity,name);
	}
	```

1. Load the query and the instance model to the **Query Explorer**.

Query Explorer
--------------

**Query Explorer** is the primary debug tool for debugging IncQuery patterns runtime. To open the view: _Window/Show View/Others/EMF-IncQuery/Query Explorer_ or you can simply press the _CTRL + 3_ shortcut and start to type the name of the view. On the left side of the view, there will be patterns inherited from the host eclipse. The middle part will show you the matches of the patterns. To achive this, we have to load a model into the view:

1.  Open our example instance model (_example.erdiagram_)
1.  then press the green arrow button on the view.

![Query Explorer](mdsd/2015/incquery/query_explorer.png)

Pattern Language
----------------

1. Structure your source code to 4 blocks like this:

    ```java
    //-------------------------------
    // Support
    //-------------------------------
    
    //-------------------------------
    // Validate
    //-------------------------------
    
    //-------------------------------
    // Derived
    //-------------------------------
    ```

    Every pattern goes to one of those categories. The ```entityWithName``` goes to Support. 

    As you can see, every pattern have a unique name and several parameters. Inside the body of the patterns, there different constraints. Our first example describes a feature constraint. It states that ```entity``` variable is of eClass ```Entity``` and its ```name``` attribute is the value of ```name``` variable.

1. Create a query to the **Validate** that checks if the name of a ``NamedElement`` is only an empty string:

    ```java
	pattern emptyNamedElement(element: NamedElement) {
		NamedElement.Name(element, "");
	}
	```
   This pattern shows, that the parameters can be typed immediately in the parameters list.	

1. Create a query to the **Validate** that checks if two entity has the same name:

    ```java
	pattern sameNamedEntities(entity1, entity2, commonName) {
		Entity.Name(entity1, commonName);
		Entity.Name(entity2, commonName);
		entity1!=entity2;
	}
	```
	
	This pattern shows the ```!=``` (_not equal_) operator to select two different entites from the instance model. (Use the ```==``` operator to equality)

1. Create a query to the **Validate** that checks if the name starts with a noncapital letter:

    ```java
	pattern entityStartsWithSmallCase(entity) {
		Entity.Name(entity,name);
		check (
			!name.matches("^[A-Z].+")
		);
	}
	```
	
	This pattern shows the ```check``` block where you can write a wide range of _Xbase_ expressions (similar to Java). In this case, we define a regular expression.
	
1. Create a query to the **Derived** that gets the other endign of a relation ending:
    
	```java
	pattern other(ending:RelationEnding, other) {
		Relation.leftEnding(relation, ending);
		Relation.rightEnding(relation, other);
	} or {
		Relation.rightEnding(relation, ending);
		Relation.leftEnding(relation, other);
	}
	```
	
	This pattern shows how to connect independent bodies in a pattern. To do this, we use the ```or``` keyword that states the pattern has a match if the first _or_ the second _or_ the third _or_ etc body has a match.
	
1. Create a query to the **Support** that summarizes this three validation condition:

    ```java
	pattern badEntity(entity, name) {
		find sameNamedEntities(entity, _other, name);
	} or {
		Entity.Name(entity, name);
		find emptyNamedElement(entity);
	} or {
		Entity.Name(entity, name);
		find entityStartsWithSmallCase(entity);
	}
	```
	
	This pattern shows how to reuse previously defined patterns as sub patterns. To do this, we use the ```find``` keyword then write the id of the sub pattern and finally add the variables. (Variables starting with ```_``` define _don't care_ variables, hence you cannot use them in other lines of the pattern)

1. Create a query to the **Support** that matches to the well-named entities:

    ```java
	pattern goodEntity(entity, name) {
		Entity.Name(entity, name);
		neg find badEntity(entity,_);
	}
	```
	
	This pattern shows ```neg find``` expression to express negation. Those actual parameters of the negative pattern call that are not used elsewhere in the calling body will be quantified; this means that the calling pattern only matches if no substitution of these calling variables could be found.
	
1. Create a query to the **Support** that counts the number of attributes of an entity:  

   ```java
   pattern attribute(entity, attr) {
        Entity.attributes(entity, attr);
   }

   pattern countAttribute(entity : Entity, M) {
	    M == count find attribute(entity, _);
   }
   ```
   
   This pattern shows ```count find``` expression that aggregates multiple matches of a called pattern into a single value.
   
Validation
----------

EMF-IncQuery provides facilities to create validation rules based on the pattern language of the framework. These rules can be evaluated on various EMF instance models and upon violations of constraints, markers are automatically created in the Eclipse Problems View.

The **@Constraint** annotation can be used to mark a pattern as a validation rule. If the framework finds at least one pattern with such annotation.

Annotation parameters:
 * _location:_ The location of constraint represents the pattern parameter (the object) the constraint violation needs to be attached to.
 * _message:_ The message to display when the constraint violation is found. The message may refer the parameter variables between $ symbols, or their EMF features, such as in $Param1.name$.
 * _severity:_ "warning" or "error"
 * _targetEditorId:_ An Eclipse editor ID where the validation framework should register itself to the context menu. Use "*" as a wildcard if the constraint should be used always when validation is started.
 
To find a specific editor id, we can use the _Plug-in Selection Spy_ tool with a _SHIFT + ALT + F1_ shortcut.

![Plug-in Selection Spy](mdsd/2015/incquery/spy.png)

For example:

	```java
	@Constraint(targetEditorId = "ERDiagram.presentation.ERDiagramEditorID",
				severity = "error", 
				message = "The name is not unique",
				location = entity1)
	pattern sameNamedEntities(entity1, entity2, commonName) {
		Entity.Name(entity1, commonName);
		Entity.Name(entity2, commonName);
		entity1!=entity2;
	}
	```

Derived features
----------------

To define a derived feature in your EMF metamodel, you have set the following attributes of the feature:
 * derived = true (to indicate that the value of the feature is computed from the model)
 * changeable = false (to remove setter methods)
 * transient = true (to avoid persisting the value into file)
 * volatile = true (to remove the field declaration in the object)

EMF-IncQuery supports the definition of efficient, incrementally maintained, well-behaving derived features in EMF by using advanced model queries and incremental evaluation for calculating the value of derived features and providing automated code generation for integrating into existing applications.

The **@QueryBasedFeature** annotation can be used to mark a pattern as a derived feature realization. If the framework can find out the feature from the signature of the pattern (_patter name_, _first paramter type_, _second paramter type_), the annotation parameters can be empty.

Annotation parameters:
 * feature ="featureName" (default: pattern name) - indicates which derived feature is defined by the pattern
 * source ="Src" (default: first parameter) - indicates which query parameter (using its name) is the source EObject, the inferred type of this parameter indicates which EClass generated code has to be modified
 * target ="Trg" (default: second parameter) - indicates which query parameter (using its name) is the target of the derived feature
 * kind ="single/many/counter/sum/iteration" (default: feature.isMany?many:single) - indicates what kind of calculation should be done on the query results to map them to derived feature values
 * keepCache ="true/false" (default: true) - indicates whether a separate cache should be kept with the current value. Single and Many kind derived features can work without keeping an additional cache, as the EMF-IncQuery RETE network already keeps a cache of the current values.
 
For example:

Extend our ER Diagram metamodel with following _other_ reference of the ```RelationEnding``` eClass and set the required properties.

![Derived Feature](mdsd/2015/incquery/new_reference.png)

	```java
	@QueryBasedFeature
	pattern other(ending:RelationEnding, other) {
		Relation.leftEnding(relation, ending);
		Relation.rightEnding(relation, other);
	} or {
		Relation.rightEnding(relation, ending);
		Relation.leftEnding(relation, other);
	}
	```

Advanced Queries
----------------

1. Create **Support** patterns for the inheritance:

    ```java
	//@QueryExplorer(display = false)
	pattern superEnitities(entity, superEntity) {
		Entity.isA(entity, superEntity);
	}

	//@QueryExplorer(display = false)
	pattern allSuperEntities(entity, superEntity) {
		find superEnitities+(entity, superEntity);
	}
	```

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
		Entity.Name(a, name1);
		Entity.Name(b, name2);
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