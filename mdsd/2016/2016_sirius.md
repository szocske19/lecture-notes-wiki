# Sirius

![The logo of Sirius](mdsd/2015/sirius/logo_Sirius.png)

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
   ![Viewpoint added](mdsd/2015/sirius/viewpoint.png)
   
1. Under the viewpoint, create a diagram representation (right click on the viewpoint -> New Representation -> New Diagram Representation) and set its domain class to our root metamodel class: `EntityRelationDiagram`.
   ![Diagram added](mdsd/2015/sirius/diagram.png)
   
    The default layer is automatically created under the diagram representation. Layers can be switch on and off while using the diagram editor. We will use only the default one.
   ![Layer added](mdsd/2015/sirius/layer.png)

Visualizing objects
-------------------

Under the default layer:

1. Create a Node typed diagram element (right click on the layer -> New Diagram Element -> Node) and set its domain class to `Entity` and its semantic candidates expression to `feature:entities`.

   _Note_: the Semantic Candidate Expression describes the navigation path from the parent domain class to the selected ones. In this the parent is `EntityRelationDiagram` and we select all the object on its **entities** reference.

   _Note_: the `feature:` selects a structural feature (attribute or reference) from a domain class.

1. Define a style for the Node (right click on the Node -> New Style -> Square). You can change its properties if you want (e.g.: light blue color, disable icon).
   ![Entity + Style added](mdsd/2015/sirius/style.png)
   
1. Create a Node typed diagram element and set its domain class to `Attribute` and set its semantic candidate expression to `[entities.attributes->addAll(temporaralAttributes)/]`
   _Note_: inside the square brackets you can Acceleo expressions - [Acceleo](http://www.acceleo.org/doc/obeo/en/acceleo-2.6-reference.pdf)
   
1. Create styles and conditional styles for attributes based on the `isKey` properties. The condition will be the following: `[isKey/]`. Right click on the Node -> New Conditional Style -> Conditional Style and then you can create a new style under the conditional style element.

   _Note_: A default style is always required.

   _Note_: Do not forget to fill the predicate expression in the conditional style.

   _Note_: If the predicate expression is true the conditional style will be applied.

   ![Style + Conditional Style added](mdsd/2015/sirius/conditional_style.png)
   
Visualizing edges
-----------------

### Display connections between an entity and its attributes
  
1. Create a Relation Based Edge typed diagram element (right click on the layer -> New Diagram Element -> Relation Based Edge).
1. Set its source mapping to `Entity` (defined previous).
1. Set its target mapping to `Attribute` (defined also previous).
1. Set its target finder expression to `feature:attributes`

     _Note_: the target finder expression is related to the source mapped objects.
1. By default, a simple edge style is create which is good for us now, but you can check its properties.
   
   ![Relation Based Edge added](mdsd/2015/sirius/relation_based.png)
   
### Display connections between entities based on the relation objects
   
1. Create an Element Based Edge typed diagram element (right click on the layer -> New Diagram Element -> Element Based Edge).
1. Set its domain class to `Relation`
1. Set its source mapping to `Entity` (defined previous)
1. Set its source finder expression to `[leftEnding.target/]`
1. Set its target mapping to `Entity` (defined also previous)
1. Set its source finder expression to `[rightEnding.target/]`
1. We left the semantic candidates expression empty, but we should fill it with `feature:relations`

      _Note_: for the proper functioning, this is not required but recommended.
1. By default, a simple style is provided for the edge, but define additional conditional styles based on the multiplicity of a relation:
      * `[leftRelationEnding.multiplicity.toString() = 'Many' and rightRelationEnding.multiplicity.toString() = 'One'/]`
      * `[leftRelationEnding.multiplicity.toString() = 'One' and rightRelationEnding.multiplicity.toString() = 'Many'/]`
      * `[leftRelationEnding.multiplicity.toString() = 'Many' and rightRelationEnding.multiplicity.toString() = 'Many'/]`

1. Change the ending of the edges based on the multiplicity (inside properties of an edge style, check the decorators tab)
   
   ![Element Based Edge added](mdsd/2015/sirius/element_based.png)
   
Creating Objects
----------------

Under the **Section** (create one, if you don't have: right click on the layer -> New Tool -> Section)

1. Create Entities
   1. Add a _Node Creation_ (right click on Section -> New Element Creation -> Node Creation)
   1. Under the green arrow with the begin label, we can define an operation sequence to be executed.
      1. Create a new instance operation (right click on Begin -> New Operation -> Create Instance)
      1. Set its reference name to _"entities"_
         _Note: without any prefix, only the reference name_
         _Note: field is related to the domain class of the diagram (or the container node) where we add the new instance
      1. Set its type name to Entity, as we want to create a new Entity
      1. Set its variable name to _"instance"_
         _Note: we won't use this feature, but with its name, you can refer to this object later (var:<variable name>)
   1. Under the new instance operation, create a Set operation (right click on Create Instance Entity -> New Operation -> Set)
      1. Set its feature name to _"name"_
      1. Set its value to _"undefined"_
      _Note: this will set the name attribute of the new object to "undefined" by default_        

   ![Create Entity](mdsd/2015/sirius/create_entity.png)

1. Create Attributes
   1. Add a _Node Creation_ (right click on Section -> New Element Creation -> Node Creation)
   1. Under the green arrow with the begin label, define the operation sequence.
      1. Create a new instance operation (right click on Begin -> New Operation -> Create Instance)
      1. Despite the fact, that our **EntityRelationDiagram** class cannot contain Attribute typed objects in any of its features, we have to extend the metamodel.
         1. Stop the **RuntimeEclipse**.
         1. Open the _erdiagram.ecore_ file.
         1. Add a new reference to **EntityRelationDiagram**
         	* Name: temporary
         	* Type: Attribute
         	* Multiplicity: many (0..*)
         1. Save the metamodel
         1. Reload it in the genmodel.
         1. Regenerate the model, edit and editor code from the genmodel
         1. Start the **Runtime Eclipse** again.         
		    ![Modified metamodel](mdsd/2015/sirius/metamodel.png)
		 
      1. Set its reference name to _"temporary"_
      1. Set its type name to Attribute
      1. Set its variable name to _"instance"_
   1. Under the new instance operation, create a Set operation (right click on Create Instance Entity -> New Operation -> Set)
      1. Set its feature name to _"name"_
      1. Set its value to _"undefined"_

   ![Create Attibute](mdsd/2015/sirius/create_attribute.png)

Creating Edges
----------------

Under the **Section** (create one, if you don't have: right click on the layer -> New Tool -> Section)

1. Create edge between Entity and Attribute
   1. Add a _Edge Creation_ (right click on Section -> New Element Creation -> Edge Creation)
   1. Set its edge mapping to _"entity_attribute"_
   _Note: this is the edge element that we defined previous (Visualizing edges/1st step)_
   1. Set its connection start precondition to [self->selectByType(Attribute)/]
   _Note: this acceleo expression will select all attribute typed objects
   1. Set its connection end precondition to [self->selectByType(Entity)/]
   _Note: these two precondition will restrict the editor to disable undesirable edges_
   1. Add a Set operation under the Begin element
      1. Feature name: _"attributes"_
      _Note: related to the source object_
      1. Value expression: _"target"_
      _Note: this is a variable created automatically and refers to the selected target object_

   ![Create Edge between Attibute and Entity](mdsd/2015/sirius/attribute_edge_create.png)
   
 1. Create edge between Entities (using Java Code)
   1. Add a _Edge Creation_ (right click on Section -> New Element Creation -> Edge Creation)
   1. Set its edge mapping to _"Relation"_
   _Note: this is the edge element that we defined previous (Visualizing edges/2nd step)_
   1. Set its connection start precondition to [self->selectByType(Entity)/]
   1. Set its connection end precondition to [self->selectByType(Entity)/]
   1. Add an External Java Action operation under the Begin element (right click on the Begin element -> New Extension -> External Java Action)
      1. Set its Java Action Id to _"CreateRelation"_
      1. Add parameters: source, target, container (right click on the External Java Action -> New -> External Java Action Parameter)
         * Set their properties:
            * name: _source_, value _var:source_
            * name: _target_, value _var:target_
            * name: _container_, value _var:container_
            
      ![Create Relation between Entities](mdsd/2015/sirius/relation_edge_create.png)
      
      1. Open the plugin.xml of the project
      1. Switch to the extensions tab
      1. Add a new extension: org.eclipse.sirius.externalJavaAction
      1. Add a new java action under the extension
      1. Set its id to _"CreateRelation"_ (same as Java Action Id!)
      1. Create an action class: CreateRelationOperation
   
		 '''java
		 public class CreateRelationOperation implements IExternalJavaAction {
		
			@Override
			public void execute(Collection<? extends EObject> selections,
					Map<String, Object> parameters) {
				
				Entity source = (Entity) parameters.get("source");
				Entity target = (Entity) parameters.get("target");
				EntityRelationDiagram diagram = (EntityRelationDiagram) parameters.get("container");
				
				Relation relation = ERDiagramFactory.eINSTANCE.createRelation();
				
				RelationEnding leftRelationEnding = ERDiagramFactory.eINSTANCE.createRelationEnding();
				RelationEnding rightRelationEnding = ERDiagramFactory.eINSTANCE.createRelationEnding();
				
				relation.setLeftEnding(leftRelationEnding);
				relation.setRightEnding(rightRelationEnding);
				
				leftRelationEnding.setTarget(source);
				rightRelationEnding.setTarget(target);
				
				leftRelationEnding.setName("undefined");
				rightRelationEnding.setName("undefined");
				
				diagram.getRelations().add(relation);
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
		_Note: the added parameters can be reached in the "parameters" map_
		
		![Extension points](mdsd/2015/sirius/extensionpoint.png)
      
Validation
----------

1. Create new validation for our diagram (right click on diagram element -> New Validation -> Validation)
1. Create a new Semantic validation (right click on validation element -> New -> Semantic Validation)
   1. Set its level to "Information"
   1. Target class: "Attribute"
   1. Message: "Hi! I'm an Address."
   _Note: this describes what will happen when our model has a problem_
   
   1. Create an Audit under the semantic validation (right click semantic validation -> new -> audit)
      * Set its audit expression to _"[self.name <> 'address'/]"_
	  _Note: this describes whether our model is correct or not. If the expression returns false, the element is incorrect._
   1. Create an Quick Fix under the semantic validation (right click semantic validation -> new -> quick fix)
      * Create a Set operation under the Begin element
      _Note: this is also an operation sequence to be executed when someone click on the quick fix
        * feature: _"name"_, value: _"addresss"_

   ![Extension points](mdsd/2015/sirius/validation.png)
          

You can find the final state of the projects in [this repository](https://github.com/FTSRG/mdsd-examples) by checking out the ``Sirius`` branch.

References
----------

Sirius basic tutorial:
Acceleo language references: [OCL|https://wiki.eclipse.org/Acceleo/OCL_Operations_Reference] [Acceleo|https://wiki.eclipse.org/Acceleo/Acceleo_Operations_Reference]