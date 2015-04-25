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
   _Note: this is a Sirius related project type to describe a Sirius editor

1. Switch to **Modeling** perspective
   _Note: Window -> Open perspective -> Other... -> Modeling

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
   _Note: the **feature:** selects a structural feature (attribute or reference) from a domain class

1. Define a style for the Node (right click on the Node -> New Style -> Square). You can change its properties if you want.
   ![Entity + Style added](mdsd/2015/sirius/style.png)
   
1. Create a Node typed diagram element and set its domain class to **Attribute** and set its semantic candidate expression to _[self.entities.attributes->addAll(self.temporary->filter(Attribute))/]_
   _Note: inside the squre brackets you can acceleo expressions - [acceleo](http://www.acceleo.org/doc/obeo/en/acceleo-2.6-reference.pdf)
   
1. Create styles and conditional styles for attributes based on the _isKey_ properties. The condition will be the following: _[self.isKey]_
   _Note: A default style is alway required.
   _Note: Create Conditional Style - right click on the Node -> New Conditional Style -> Conditional Style and then you can create a new style under the conditional style element.
   _Note: Do not forget to fill the predicate expression in the conditional style
   _Note: If the predicate expression is true the conditional style will be applied.

   ![Entity + Style added](mdsd/2015/sirius/conditional_style.png)
   
