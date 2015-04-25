# Sirius

![The logo of Sirius](mdsd/2015/sirius/logo_Sirius.png)

homesite: http://eclipse.org/sirius/

Install Sirius
-------------

Install from eclipse market place: search for Sirius -> Click _Install_ -> etc.

![Eclipse Marketplace... inside Help menu](mdsd/2015/sirius/install_marketplace_module.png)

Output of the laboratory
------------------------

* Modified metamodel can be downloaded from [here](projects/sirius_metamodel.zip)
* Created design project can be downloaded from [here](projects/sirius_design.zip)

Setup the laboratory
--------------------

1. Import the original metamodel projects from [here](projects/incquery-metamodel.zip).
1. (Generate *.edit and *.editor from the appropriate *.genmodel file in the _model_ folder.)
1. Run as **Eclipse Application**.
1. Import the project from [here](projects/incquery-example.zip) to the runtime Eclipse and check the instance model.
1. We will work in **Runtime Eclipse**

Viewpoint specificiation
--------------------------------------------------------

In the **Runtime Eclipse**

1. Create a new **Viewpoint Specification Project** and name it as _hu.bme.mit.mdsd.erdiagram.design while the _Viewpoint specification model_ would be called _erdiagram.odesign_.
   _Note: this is a Sirius related project type to describe a Sirius editor_

1. Switch to **Modeling** perspective
   _Note: Window -> Open perspective -> Other... -> Modeling_

1. In _odesign_ editor, add a new view point: right click on the viewpoint (in the editor) -> New -> Viewpoint. Set its **Model File Extension** property to _"erdiagram"_.
   ![Viewpoint added](mdsd/2015/sirius/viewpoint.png)
   
1. Under the viewpoint, create a diagram representation (right click on the viewpoint -> New Representation -> New Diagram Representation) and set its domain class to our root metamodel class: EntityRelationDiagram.
   ![Diagram added](mdsd/2015/sirius/diagram.png)
   
1. Create a default layer under the diagram representation (right click on the representation -> New Diagram Element -> Default Layer).
   ![Layer added](mdsd/2015/sirius/layer.png)

Visualizing objects
-------------------

Under the default layer:

1. Create a Node typed diagram element (right click on the layer -> New Diagram Element -> Node) and set its domain class to **Entity** and its semantic candidates expression to **feature:entities**.
   _Note: the Semantic Candidate Expression describes the navigation path from the parent domain class to the selected ones. In this the parent is **EntityRelationDiagram** and we select all the object on its **entities** reference._
   _Note: the **feature:** selects a structural feature (attribute or reference) from a domain class_

1. Define a style for the Node (right click on the Node -> New Style -> Square). You can change its properties if you want.
   ![Entity + Style added](mdsd/2015/sirius/style.png)
   
1. Create a Node typed diagram element and set its domain class to **Attribute** and set its semantic candidate expression to _[self.entities.attributes->addAll(self.temporary->filter(Attribute))/]_
   _Note: inside the squre brackets you can acceleo expressions - [acceleo](http://www.acceleo.org/doc/obeo/en/acceleo-2.6-reference.pdf)_
   
1. Create styles and conditional styles for attributes based on the _isKey_ properties. The condition will be the following: _[self.isKey/]_
   _Note: A default style is alway required._
   _Note: Create Conditional Style - right click on the Node -> New Conditional Style -> Conditional Style and then you can create a new style under the conditional style element._
   _Note: Do not forget to fill the predicate expression in the conditional style._
   _Note: If the predicate expression is true the conditional style will be applied._

   ![Style + Conditional Style added](mdsd/2015/sirius/conditional_style.png)
   
Visualizing edges
-----------------

Under the default layer:

1. Display connections between an entity and its attributes
   1. Create a Relation Based Edge typed diagram element (right click on the layer -> New Diagram Element -> Relation Based Edge).
   1. Set its source mapping to Entity (defined previous)
   1. Set its target mapping to Attribute (defined also previous)
   1. Set its target finder expression to _"feature:attributes"_
      _Note: the target finder expression is related to the source mapped objects_
   1. By default, a simple edge style is create which is good for us now, but you can check its properties.
   
   ![Relation Based Edge added](mdsd/2015/sirius/relation_based.png)
   
 1. Display connections between entities based on the relation objects
   1. Create a Relation Based Edge typed diagram element (right click on the layer -> New Diagram Element -> Relation Based Edge).
   1. Set its domain class to Relation
   1. Set its source mapping to Entity (defined previous)
   1. Set its source finder expression to _"[self.leftEnding.target/]"_
   1. Set its target mapping to Attribute (defined also previous)
   1. Set its source finder expression to _"[self.rightEnding.target/]"_
   1. We left the semantic candidates expression empty, but we should fill it with "feature:relations"
      _Note: for the proper functioning, this is not required but recommended_
   1. By default, a simple style is provided for the edge, but define additional conditional styles based on the multiplicity of a relation:
      * [self.leftEnding.multiplicity.toString() = 'One' and self.leftEnding.multiplicity.toString() = 'One'/]
      * [self.leftEnding.multiplicity.toString() = 'Many' and self.leftEnding.multiplicity.toString() = 'One'/]
      * [self.leftEnding.multiplicity.toString() = 'One' and self.leftEnding.multiplicity.toString() = 'Many'/]
      * [self.leftEnding.multiplicity.toString() = 'Many' and self.leftEnding.multiplicity.toString() = 'Many'/]
   1. Change the ending of the edges alse based the multiplicity (inside properties of an edge style, check the decorators tab)
   
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

Creating Edges
----------------

Under the **Section** (create one, if you don't have: right click on the layer -> New Tool -> Section)
   