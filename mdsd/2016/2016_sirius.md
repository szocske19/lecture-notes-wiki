# Sirius

![The logo of Sirius](mdsd/2016/sirius/logo_Sirius.png)

homesite: http://eclipse.org/sirius/

Install Sirius
-------------

Install via update site, which you can find here: https://wiki.eclipse.org/Sirius/Update_Sites
On the laboratory we use v3.1.4 on Mars.

Setup the laboratory
--------------------

1. Clone (Xtext branch) and import the following projects from this git repository: https://github.com/FTSRG/mdsd-examples

	```
	hu.bme.mit.mdsd.erdiagram
	hu.bme.mit.mdsd.erdiagram.edit
	hu.bme.mit.mdsd.erdiagram.editor
	```

1. Run as **Eclipse Application**.

Viewpoint specificiation
--------------------------------------------------------

In the **Runtime Eclipse**

1. Switch to **Modeling** perspective

   _Note: Window -> Open perspective -> Other... -> Modeling_

1. Create a new **Viewpoint Specification Project** and name it `hu.bme.mit.mdsd.erdiagram.design` while the _Viewpoint specification model_ would be called `erdiagram.odesign`.
   _Note: this is a Sirius related project type to describe a Sirius editor_

1. In _odesign_ editor, add a new view point: right click on the viewpoint (in the editor) -> New -> Viewpoint. Set its **Model File Extension** property to _"erdiagram"_.
   ![Viewpoint added](mdsd/2016/sirius/viewpoint.png)
   
1. Under the viewpoint, create a diagram representation (right click on the viewpoint -> New Representation -> New Diagram Representation) and set its domain class to our root metamodel class: `EntityRelationDiagram`.
   ![Diagram added](mdsd/2016/sirius/diagram.png)
   
    The default layer is automatically created under the diagram representation. Layers can be switch on and off while using the diagram editor. We will use only the default one.
   ![Layer added](mdsd/2016/sirius/layer.png)

Visualizing objects
-------------------

Under the default layer:

1. Create a Node diagram element (right click on the layer -> New Diagram Element -> Node) and set its domain class to `Entity` and its semantic candidates expression to `feature:entities`. Id can be anything, e.g.: `EntityNode` we will refer to it later.

   _Note_: the Semantic Candidate Expression describes the navigation path from the parent domain class to the selected ones. In this the parent is `EntityRelationDiagram` and we select all the object on its `entities` reference.

   _Note_: the `feature:` selects a structural feature (attribute or reference) from a domain class.

1. Define a style for the Node (right click on the Node -> New Style -> Square). You can change its properties if you want (e.g.: light blue color, disable icon). Also note the label expression is `feature:name` by default.
   ![Entity + Style added](mdsd/2016/sirius/style.png)
   
1. Create a Node diagram element and set its domain class to `Attribute` and set its semantic candidate expression to `[entities.attributes->addAll(temporaralAttributes)/]`. Id can be `AttributeNode`.
   _Note_: inside the square brackets you can Acceleo expressions - [Acceleo](http://www.acceleo.org/doc/obeo/en/acceleo-2.6-reference.pdf).

    _Note_: the `EntityRelationDiagram` has a `temporaralAttributes` containment reference for attributes not belonging to entities. This will be required later on.
   
1. Create styles and conditional styles for attributes based on the `isKey` properties. The condition will be the following: `[isKey/]`. Right click on the Node -> New Conditional Style -> Conditional Style and then you can create a new style under the conditional style element.

   _Note_: A default style is always required.

   _Note_: Do not forget to fill the predicate expression in the conditional style.

   _Note_: If the predicate expression is true the conditional style will be applied.

   ![Style + Conditional Style added](mdsd/2016/sirius/conditional_style.png)

Try it out
----------

1. To try it out, import our example `hu.bme.mit.mdsd.erdiagram.examplediagram` to the runtime Eclipse.
1. Give the Modeling project nature to the imported project in the context menu -> Configure.
1. In the context menu there will be a **Viewpoints Selection** item, click it and add the viewpoint specification we have just started to define.
1. Create a new representation as shown on the next figure. Name it as you want and a new editor will open showing the entities and attributes as nodes.

   ![New representation](mdsd/2016/sirius/create-representation.png)


Visualizing edges
-----------------

### Display connections between an entity and its attributes
  
1. Create a Relation Based Edge diagram element (right click on the layer -> New Diagram Element -> Relation Based Edge) with an id `EntityAttributeEdge`.
1. Set its source mapping to `EntityNode` (defined previous).
1. Set its target mapping to `AttributeNode` (defined also previous).
1. Set its target finder expression to `feature:attributes` or just `[attributes/]`

     _Note_: the target finder expression is related to the source mapped objects.
1. By default, a simple edge style is created. Change its decorator (edge ending) to `NoDecoration`. On the advanced tab set its _Folding Style_ to _Source_. This will allow to collapse an entity's attributes.
   
   ![Relation Based Edge added](mdsd/2016/sirius/relation_based.png)

### Display inheritance relation

Similarly you can define an `InheritanceEdge` between entities with an `isA` relation.

![Inheritance Edge](mdsd/2016/sirius/inheritance-edge.png)

### Display connections between entities based on the relation objects
   
1. Create an Element Based Edge diagram element (right click on the layer -> New Diagram Element -> Element Based Edge) and give an id `RelationEdge`.
1. Set its domain class to `Relation`
1. Set its source mapping to `EntityNode` (defined previous)
1. Set its source finder expression to `[leftEnding.target/]`
1. Set its target mapping to `EntityNode` (defined also previous)
1. Set its source finder expression to `[rightEnding.target/]`
1. We left the semantic candidates expression empty, but we should fill it with `feature:relations`

      _Note_: for the proper functioning, this is not required but recommended.

      ![RelationEdge](mdsd/2016/sirius/relation-edge.png)

1. By default, a simple style is provided for the edge, but define additional conditional styles based on the multiplicity of a relation:
      * `[leftRelationEnding.multiplicity.toString() = 'One' and rightRelationEnding.multiplicity.toString() = 'Many'/]`
      * `[leftRelationEnding.multiplicity.toString() = 'Many' and rightRelationEnding.multiplicity.toString() = 'One'/]`
      * `[leftRelationEnding.multiplicity.toString() = 'Many' and rightRelationEnding.multiplicity.toString() = 'Many'/]`

1. Change the ending of the edges based on the multiplicity (inside properties of an edge style, check the decorators tab)
   
   ![Element Based Edge added](mdsd/2016/sirius/element_based.png)

At this point we have a fully featured view of our model (except, we can't see the name of the relation endings only the name of the relation:
![An entity relation diagram](mdsd/2016/sirius/erdiagram.png)

And we can fold entities, e.g. Person:
![Person collasped](mdsd/2016/sirius/erdiagram-collapsed.png)

Creating Objects
----------------

Create a `section` under the layer, this will represent a section on the **Palette** of the editor (right click on the layer -> New Tool -> Section)

### Create Entities
   
1. Add a _Node Creation_ (right click on Section -> New Element Creation -> Node Creation).
1. Under the green arrow with the begin label, we can define an operation sequence to be executed.
1. Create a new _change context_ and change the context to the container with the `var:container` expression.
1. Create a new instance operation (right click on Begin -> New Operation -> Create Instance).
1. Set its reference name to `entities`. This reference belongs to the EntityRelationDiagram root object, we will add the new entity here.
1. Set its type name to `erdiagram.Entity`, as we want to create a new Entity.
1. Set its variable name to `instance` (default).

 _Note_: you can refer to this object later (`var:<variable name>`).

1. Create a new _change context_ and change the context to the newly created instance with the `var:instance` expression.

1. Under it, create a Set operation (right click on Create Instance Entity -> New Operation -> Set).
      1. Set its feature name to `name`.
      1. Set its value to `newEntity`. This will set the _name_ attribute of the new object.

   ![Create Entity](mdsd/2016/sirius/create_entity.png)

### Create Attributes

It goes in the very same way as creating entities. The catch here is the attributes are contained by entities but now we can't connect a newly created attribute immediately to an entity. For this reason, we will use the `temporalAttributes` containment reference on the `EntitiyRelationDiagram` element. 

   ![Create Attibute](mdsd/2016/sirius/create_attribute.png)

After saving, you can add new entities and attributes on the editor.

_Note_: you can change the display name of the tool with the _Label_ property.

_Note_: **removing** and element also works by default by pressing the _del_ button after selecting an element. You can override this behavior by creating a _Delete Element_ under the section.

Creating Edges
----------------

### Create edge between Entity and Attribute
   
1. Add a _Edge Creation_ (right click on Section -> New Element Creation -> Edge Creation).
1. Set its edge mapping to `EntityAttributeEdge`.
  
   _Note_: this is the edge element that we defined previous (Visualizing edges/1st step).

1. Set its connection start precondition to `[preSource.oclIsTypeOf(Entity)/]`.
1. Set its connection end precondition to `[preTarget.oclIsTypeOf(Attribute)/]`.

    _Note_: these two precondition will restrict the editor to disable undesirable edges.

1. Add a Set operation under the Begin element.
      1. Feature name: `attributes`. (This is related to the source object).
      1. Value expression: `var:target`. This is a variable created automatically and refers to the selected target object.

   ![Create Edge between Attibute and Entity](mdsd/2016/sirius/attribute_edge_create.png)

### Create edge between Entities (using Java Code)

1. Add a _Edge Creation_ (right click on Section -> New Element Creation -> Edge Creation)
1. Set its edge mapping to `RelationEdge`

  _Note_: this is the edge element that we defined previous (Visualizing edges/2nd step).
1. Set its connection start precondition to [preSource.oclIsTypeOf(Entity)/].
1. Set its connection end precondition to [preTarget.oclIsTypeOf(Entity)/].
1. Add an External Java Action operation under the Begin element (right click on the Begin element -> New Extension -> External Java Action)
      1. Set its Java Action Id to `hu.bme.mit.mdsd.erdiagram.design.CreateRelationOperation`.
      1. Add parameters: source, target (right click on the External Java Action -> New -> External Java Action Parameter)
         * Set their properties:
            * name: _source_, value _var:source_
            * name: _target_, value _var:target_
            
      ![Create Relation between Entities](mdsd/2016/sirius/relation_edge_create.png)
      
      1. Open the plugin.xml of the project (or the manifest file).
      1. Switch to the extensions tab.
      1. Add a new extension: `org.eclipse.sirius.externalJavaAction`.
      1. Add a new java action under the extension if it is missing.
      1. Set its id to `hu.bme.mit.mdsd.erdiagram.design.CreateRelationOperation` (same as Java Action Id!)
      1. Specify an action class: `hu.bme.mit.mdsd.erdiagram.design.CreateRelationOperation`. Clicking on the "actionClass*:" link will automatically create the class for you. Insert the following code snippet:
   
		 '''java
		 public class CreateRelationOperation implements IExternalJavaAction {
			@Override
			public void execute(Collection<? extends EObject> selections, Map<String, Object> parameters) {

				Entity source = (Entity) parameters.get("source");
				Entity target = (Entity) parameters.get("target");

				ErdiagramFactory factory = ErdiagramFactory.eINSTANCE;

				Relation relation = factory.createRelation();
				RelationEnding sourceEnding = factory.createRelationEnding();
				RelationEnding targetEnding = factory.createRelationEnding();
				relation.setName("newRelation");
				relation.setLeftEnding(sourceEnding);
				relation.setRightEnding(targetEnding);
				sourceEnding.setTarget(source);
				targetEnding.setTarget(target);

				EntityRelationDiagram root = (EntityRelationDiagram) source.eContainer();
				root.getRelations().add(relation);

			}

			@Override
			public boolean canExecute(Collection<? extends EObject> selections) {
				for (EObject eObject : selections) {
					if(!(eObject instanceof Entity)) {				
						return false;
					}
				}
				return true;
			}
		}
		'''

		_Note_: the added parameters can be reached in the `parameters` map.
		
		![Extension points](mdsd/2016/sirius/extensionpoint.png)

To try it out close the runtime eclipse and import the `*.design` project from the runtime workspace into the host Eclipse. Then start the runtime Eclipse again. This will install the plugin to the runtime Eclipse and the Relation edge creating should work.

Validation
----------

1. Create new validation for our diagram (right click on diagram element -> New Validation -> Validation).
1. Create a new Semantic validation (right click on validation element -> New -> Semantic Validation).
   1. Set its level to `Information`.
   1. Target class: `Attribute`.
   1. Message: `Unnamed attribute!`. This describes what will happen when our model has a problem.
   1. Create an Audit under the semantic validation (right click semantic validation -> new -> audit)
      * Set its audit expression to `[name <> 'newAttribute'/]`.
	  _Note: this describes whether our model is correct or not. If the expression returns false, the element is incorrect._
   1. Create a Quick Fix under the semantic validation (right click semantic validation -> new -> quick fix)
      * Create a Set operation under the Begin element
      _Note: this is also an operation sequence to be executed when someone click on the quick fix
        * feature: _"name"_, value: _"addresss"_

   ![Extension points](mdsd/2016/sirius/validation.png)

Now you can validate your diagram by right click -> "Validate diagram". Any newly created attribute should have an "I" mark next to its name. You can use the quick fix by finding this mark in the _Problems_ view, right clicking and Quick fix.          

You can find the final state of the projects in [this repository](https://github.com/FTSRG/mdsd-examples) by checking out the ``Sirius`` branch.

References
----------

* Sirius basic tutorial: https://wiki.eclipse.org/Sirius/Tutorials/StarterTutorial
* Sirius advanced tutorial: https://wiki.eclipse.org/Sirius/Tutorials/AdvancedTutorial
* Sirius full documentation: https://www.eclipse.org/sirius/doc/
* Acceleo language references: [OCL](https://wiki.eclipse.org/Acceleo/OCL_Operations_Reference) [Acceleo](https://wiki.eclipse.org/Acceleo/Acceleo_Operations_Reference)