IncQuery
========

![The logo of EMF-IncQuery](mdsd/2014/incquery/logo.png)

Setup
-----

1. Import the project from ```start.zip```.

1. Generate the model, the edit and the editor from the ```genmodel``` file in the ```model``` folder of the ```hu.bme.mit.mdsd.erdiagram``` project.

1. Run as **Eclipse Application**.

1. Import the ```ERDiagramExample``` to the runtime Eclipse and check the instance model.

1. Create a new IncQuery project and name it to ```hu.bme.mit.mdsd.erdiagram.queries```.

1. Create a new query definition in a package named ```hu.bme.mit.mdsd.erdiagram``` and a file named ```queries.eiq```. In the wizard create an empty query. Fill the first query:
    
	```java
	package hu.bme.mit.mdsd.erdiagram
	
	import "hu.bme.mit.mdsd.erdiagram"

	pattern entityWithName(entity, name) {
		Entity.Name(entity,name);
	}
	```

1. Load the query and the instance model to the **Query Explorer**.

Simple Query Language Tutorial
------------------------------

1. Structure your source code to 4 blocks like this:

    ```java
	//-------------------------------
	// Support
	//-------------------------------
	
    //-------------------------------
	// Visualize
	//-------------------------------

	//-------------------------------
	// Validate
	//-------------------------------

	//-------------------------------
	// Derived
	//-------------------------------
	```
	
	Every pattern goes to one of those categories. The ``entityWithName`` goes to **Support**.

1. Create a query to the **Validate** that checks if the name of a ``NamedElement`` is only an empty string:

    ```java
	pattern emptyNamedElement(element: NamedElement) {
		NamedElement.Name(element, "");
	}
	```
	
1. Create a query to the **Validate** that checks if two entity has the same name:

    ```java
	pattern sameNamedEntities(entity1, entity2, commonName) {
		Entity.Name(entity1, commonName);
		Entity.Name(entity2, commonName);
		entity1!=entity2;
	}
	```

1. Create a query to the **Validate** that checks if the name starts with a noncapital letter:

    ```java
	pattern entityStartsWithSmallCase(entity) {
		Entity.Name(entity,name);
		check (
			!name.matches("^[A-Z].+")
		);
	}
	```
	
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
	
1. Create a query to the **Visualize** that summarizes this three validation condition:

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

1. Create a query to the **Visualize** that matches to the well-named entities:

    ```java
	pattern goodEntity(entity, name) {
		Entity.Name(entity, name);
		neg find badEntity(entity,_);
	}
	```

1. Create a query to the **Visualize** that gets the attributes:
    
	```java
	pattern attribute(entity, attribute) {
		Entity.attributes(entity,attribute);
	}
	```
	
1. Create a query to the **Visualize** that gets the attributes:
    
	```java
	pattern attribute(entity, attribute) {
		Entity.attributes(entity,attribute);
	}
	```

1. Create a query to the **Visualize** that gets relations:

    ```java
	pattern relation(entity1, entity2) {
		Relation.leftEnding.target(relation, entity1);
		Relation.rightEnding.target(relation,entity2);
	}
	```
    
1. Create a query to the **Visualize** that matches on the attributes and check the properties:
    
	```java
	pattern attributeWithName(attribute, name, type, key){
		Attribute.Name(attribute,name);
		Attribute.type.Name(attribute,type);
		Attribute.isKey(attribute,true);
		key=="[k]";
	} or {
		Attribute.Name(attribute,name);
		Attribute.type.Name(attribute,type);
		Attribute.isKey(attribute,false);
		key=="";
	}
	```

Visualization tutorial
----------------------
	
1. Use the visualize block to create a view. Annote the patterns:

    ```java
	@Item(item = entity, label = "$name$")
	pattern goodEntity(entity, name)
	
	@Item(item = entity, label = "$name$")
	@Format(color = "#ff0000")
	pattern badEntity(entity, name)

	@Item(item = attribute, label = "$key$$name$: $type$")
	@Format(color = "#00ffff")
	pattern attributeWithName(attribute, name, type, key)

	@Edge(source = entity, target = attribute)
	pattern attribute(entity, attribute)
	
	@Edge(source = entity1, target = entity2)
	pattern relation(entity1, entity2)
	```

1. Watch the result in the **Viewers** sandbox.

Advanced Query language tutorial
--------------------------------

1. For the sake of simplicity switch off the **Query Explorer** for the previous patterns with the following annotation:

    ```java
	@QueryExplorer(display = false)
	```

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

1. Print out how many attributes a well-formed entity has:

    ```java
	@Item(item = entity, label = "$name$ ($attributes$)")
	pattern goodEntity(entity, name, attributes) {
		Entity.Name(entity, name);
		neg find badEntity(entity,_);
		attributes == count find attribute(entity,_);
	}
    ```

Validation
----------

1. At first we need to import the query project to the host Eclipse. To do this copy the path of the project from the properties menu.

1. Close the project in the runtime Eclipse to avoid conflicts.

1. Go to the host Eclipse and import the query project.

1. Annotate some pattern with ``@Constraint``, like:

    ```java
	@Constraint(message = "The name is not unique!", location=entity1, severity = "error")
	pattern sameNamedEntities(entity1, entity2, commonName)

	@Constraint(message = "The name is empty!", location=element, severity = "error")
	pattern emptyNamedElement(element: NamedElement)
	```

1. Start the runtime Eclipse, open the instance model and **right click** on the resource and choose **EMF-IncQuery validation | Initialize EMF-IncQuery validators on Editor**.

1. If you make a mistake an error will rise.

Derived feature
---------------

1. Create a new EReference named ``otherEnding`` in the ``RelationEnding`` to itself. Set the following properties:
    - Changeable = false
    - Derived = true
    - Transient = true
    - Volatile = false
	
1. Annote the pattern pattern ``other``:
    
	```java
	@QueryBasedFeature
	pattern other(ending:RelationEnding, other)
	```

1. Start the runtime Eclipse and try the feature in the instance model.

