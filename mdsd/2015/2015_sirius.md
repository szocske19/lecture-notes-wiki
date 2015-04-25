# Sirius

![The logo of Sirius](mdsd/2015/sirius/logo_Sirius.png)

homesite: http://eclipse.org/sirius/

Install Sirius
-------------

Install from eclipse market place: search for Sirius -> Click _Install_ -> etc.

![Eclipse Marketplace... inside Help menu](mdsd/2015/sirius/install_marketplace_module.png)

Output of the laboratory
------------------------

* Modified metamodel can be downloaded from [here](project/sirius_metamodel.zip)
* Created design project can be downloaded from [here](project/sirius_design.zip)

Setup the laboratory
--------------------

1. Import the original metamodel projects from [here](projects/incquery-metamodel.zip).
1. (Generate *.edit and *.editor from the appropriate *.genmodel file in the _model_ folder.)
1. Run as **Eclipse Application**.
1. Import the project from [here](projects/incquery-example.zip) to the runtime Eclipse and check the instance model.
1. We will work in **Runtime Eclipse**

Viewpoint specficiation
--------------------------------------------------------

In the **Runtime Eclipse**

1. Create a new **Viewpoint Specification Project** and name it as _hu.bme.mit.mdsd.erdiagram.design while the _Viewpoint specification model_ would be called _erdiagram.odesign_.
   _Note: this is a Sirius related project type to describe a Sirius editor

1. Switch to **Modeling** perspective
   _Note: Window -> Open perspective -> Other... -> Modeling

1. In _odesign_ editor, add a new view point: right click on the viewpoint (in the editor) -> New -> Viewpoint. Set its **Model File Extension** property to _"erdiagram"_.
   ![Viewpoint added](mdsd/2015/sirius/viewpoint.png)
   
1. Under the viewpoint, create a diagram representation (right click on the viewpoint -> New Representation -> New Diagram Representation) and set its domain class to our root metamodel class: EntityRelationDiagram.
   ![Viewpoint added](mdsd/2015/sirius/diagram.png)
   
1. Create a default layer under the diagram representation (right click on the representation -> New Diagram Element -> Default Layer).
   ![Viewpoint added](mdsd/2015/sirius/layer.png)
