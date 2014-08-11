Introduction to the Eclipse Modeling Framework
==============================================

Author: Oszkár Semeráth

About the EMF
--------------

From Wikipedia (<http://en.wikipedia.org/wiki/Eclipse_Modeling_Framework>) ,,Eclipse Modeling Framework (EMF) is an Eclipse-based modeling framework and code generation facility for building tools and other applications based on a structured data model.'' EMF's data model is lightweight as it only defines a few but well-defined modeling elements. However, it has an extensive tooling support and community. For example, you can define the textual or graphical syntax of a language and generate the appropriate editors.

EMF can generate Java code from the model with only a click of a button. The generated code is capable of serialisation to XMI and deserialisation from XMI files.

EMF home page: <http://www.eclipse.org/modeling/emf/>

Description of the task
-----------------------
The goal of this exercise is to create the metamodel of customized
Entity-Relationship Diagrams (ERD). Those diagrams can aid the development of
software components that working with complex data structures. A later exercise
will show you how complete database schemes, full classes and the automated
mapping between those can be derived from those documents.

The following image presents an example of Entity Relation diagram.

![Example of an Entity-Relationship diagram](img/emf/ERD1.png)

Prerequisites
-------------

The Eclipse Modeling Tools edition contains every required plug-in.

Ecore model: step-by-step
-------------------------

1. Create a new **Empty EMF Project** by **File | New | Other... | Eclipse
Modeling Framework | Empty EMF Project**. Name it to ``hu.bme.mit.mdsd.erdiagram``.

1. There is a folder in the project named **model**. Create a new
**ECore Model** in it by right click to the folder | New | Other... |
ECore Model. Name it to ``ERDiagram.ecore``.

1. A new editor opens  that shows that the model resource has a yet unnamed empty package. Fill the missing properties in the property view:
    * Name: ``ERDiagram``
    * Ns Prefix: ``hu.bme.mit.mdsd.erdiagram``
    * Ns URI: ``hu.bme.mit.mdsd.erdiagram``
    
    To show unavailable view go to **Window | Show View | Other... | General**.

1. It is possible to create the model in this tree editor but there is a more
convenient editor for this purpose.  Right click to the ecore file and choose
the **Initialize ECore diagram File...** option. Name it to **ERDiagram.ecorediag**.

1. Let's make the following part by dropping metamodel elements from the palette to the diagram:

    ![A very simple Ecore model with two ``EClass``es and an ``EReference`` between them](img/emf/ERDiagram00.png)

1. If you click on a model element you can edit its properties in the **Property view**.
    * Specify the names of the ``EClass``es and the ``EReference``.
    * The ``EClass``es can be set to **Abstract** or **Interface** int this view.
    * The multiplicity of the relation is set to ``0..*``
	* The ``EOpposite`` feature should be presented.
    * The objects of the instance models of the metamodel have to be in a tree hiearcy with respect of the containment references. Set the ``entities`` relation to **Is Containment**.
	* **Appearance:** you can edit the view of the diagram.
    * **Advanced Options:** Direct editing for the properties of the elements of the model.
    The features should be presented:

1. The effect of the diagram editing on the ``.ecore`` file can be observed in the **Outline** view. The next figure shows the actual state of the metamodel in this view.

1. The editor can validate the model with the check symbol visible in the upper part of the following figure

    ![Outline view and the diagram validation button](img/emf/OutlineValidate.png) 
    
1. Note that deleting from model and the diagram are different things.

1. Create the metamodel of the Entity Relation Diagram on your own like it was a class diagram. A possible result is visible on Figure 1.4.
    
    ![The metamodel of the ER diagram](img/emf/ERDiagram01.png) 

1. Add the ``EEnum`` named ``Multiplicity`` to the metamodel, and add two literals to it: ``One`` and ``Many``.

1. Add an abstract ``NamedElement`` class to the metamodel and add inheritance relations to the  Fill the 
The difference between the ``EAttribute`` and ``EReference`` is that the EAttribute is referring to an ``EDataTypes`` opposed to ``EReferences`` that endings to ``EClasses``.
At this phase we have all visible details of the Entity Relation Diagrams.
    ![The metamodel completed with ``EAttributes``](img/emf/ERDiagram02.png)

1. The metamodel lacks of ``EOperations``, because it is basically a data model.

1. Adding namespace to the diagram, this could be the name of the diagram. The types of the attributes should be defined outside of the model, and referred by the diagram. 

    ![The model with the ``AttributeType`` class and the ``namespace`` attribute](img/emf/ERDiagram03.png)

1. The diagram may refer to an existing database with existing tables. The referred table and column names might be described in the diagram (for example the ``User`` entity is stored in the ``USER_TABLE`` because its name is reserved). Note the multiple inheritance at the ``Attribute`` entity. 

    ![The model now supports the connection to databases](img/emf/ERDiagram04.png)

Editor: step-by-step
--------------------
This example shows how to generate classes and an editor from Ecore models.

1. The ecore files are the blueprints of the domain specific languages. To use the tooling support available in Eclipse some kind of Java class  representation of those "boxes" are needed. Fortunately those classes can be automatically generated.

    Right click the ecore file and **New | Other | Eclipse Modeling Framework | EMF Generator Model**. The default ``ERDiagram.genmodel`` is fine. At the next step choose that the generator generate from an Ecore model. In the third step the URI of the Ecore model have to be added. Click on load and next. Choose the only avaliable package to generate and hit finish.

1. Another tree editor opens similar to the ecore editor. Browse some of the setting in the property editor. Right click to the root, and choose the **Generate Model** command. Three package has been generated in the source folder. Browse for example the ``hu.bme.mit.mdsd.erdiagram/src/ERDiagram/EntityRelationDiagram.java`` file, and you can see that nothing strange has been generated. The implementation class has some unusual field, but the implementations of the functions of the interface are quite simple.

1. Generate an **editor**. Right click to the root of the genmodel file, and generate edit and editor in this order.

1. Right click to the project, and choose **Run as | Eclipse** application.

1. Create an empty project by **File | New | Other... | General | Project** and name it to **Diagrams**.

1. Create a new Entity Relation Diagram into the new project by right clicking on it and picking **New | Other | Example EMF Model Creation Wizard | ERDiagram Model**. The name can be the default ``My.erdiagram``, and the model object (what we want to edit) should be **Entity Relation Diagram**.

1. Create the instance model. The editor is quite self-explanatory to use.

   ![The tree editor for the Ecore model](img/emf/ERDInstance.png)

Model manipulation: step-by-step
--------------------------------
The following example shows how to edit the model from code.

1. Create a new **Plug-in Project** by right click | New | Plug-in Project. Name it to ``hu.bme.mit.mdsd.erdiagrammanipulator``.

1. Add the following dependencies:

    -------------------------------- ----------------------------------------------------
    ``hu.bme.mit.mdsd.erdiagram``    The edited domain.
    ``org.eclipse.emf.ecore.xmi``    The instance model is serialised as an XMI document.
    -------------------------------- ----------------------------------------------------
    
1. Create a class to the source folder:

    ------- --------------------------------------
    package ``hu.bme.mit.jpadatamodelmanipulator``
    name    ``ModelEditor``
    ------- --------------------------------------

1. Create an initialisation method for model loading.

    ```java
    public void init() {
       // For the initialisation of the model.
       // Without this the following error happens:
       //  "Package with uri 'hu.bme.mit.mdsd.erdiagram' not found."
       ERDiagramPackage.eINSTANCE.eClass();
          
       // Defining that the files with the .erdiagram extension should be parsed as an xmi.
       Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
       reg.getExtensionToFactoryMap().put("erdiagram", new XMIResourceFactoryImpl());
    }
    ```

1. The model is in an xmi file that can be generally handled as a resource. A resource can be referenced by an URI. Write a method that loads a resource:

    ```java
    public Resource getResourceFromURI(URI uri) {
       ResourceSet resSet = new ResourceSetImpl();
       Resource resource = resSet.getResource(uri, true);
       return resource;
    }
    ```

1. The resource simply can be saved:

    ```java
    public void saveResource(Resource resource) {
       try {
         resource.save(Collections.EMPTY_MAP);
       } catch (IOException e) {
          System.out.println("The following error occured during saving the resource: "
            + e.getMessage());
       }
    }
    ```

1. The content of the resource should be the ED diagram object.

    ```java
    public EntityRelationDiagram getModelFromResource(Resource resource) {
       // check the content!
       EntityRelationDiagram root = (EntityRelationDiagram) resource.getContents().get(0);
       return root;
    }
    ```

1. The ER diagram object should be edited through the interface and instantinated by the generated factory methods. This method creates a custom table data object for every entity that doesn't already have one:

    ```java
    public void editDiagram(EntityRelationDiagram diagram) {
       for(Entity entity : diagram.getEntities()) {
          if(entity.getCustomTable() == null) {
             TableData tableData = ERDiagramFactory.eINSTANCE.createTableData();
             tableData.setTableName(entity.getName().toUpperCase()+"_TABLE");
             entity.setCustomTable(tableData);
          }
       }
    }
    ```

    The result can be printed to the output by this method:

    ```java
    public void printTables(EntityRelationDiagram diagram) {
       for(Entity entity : diagram.getEntities()) {
          System.out.println(entity.getCustomTable().getTableName());
       }
    }
    ```

1. You can get the URI by right click | **Properties** and copy the file to a string. For example my URI is:

    ```java
    URI uri = URI.createFileURI("C:/workspace/Diagrams/My.erdiagram");
    ```

    The main method looks like:

    ```java
    public static void main(String[] args) {
       ModelEditor editor = new ModelEditor();
       editor.init();
       URI uri = URI.createFileURI("C:/workspace/Diagrams/My.erdiagram");
       Resource resource = editor.getResourceFromURI(uri);
       EntityRelationDiagram diagram = editor.getModelFromResource(resource);
       editor.editDiagram(diagram);
       editor.printTables(diagram);
       editor.saveResource(resource);
    }
    ```

    Right click to the class and choose **Run as | Java Application**. This will run our code as a simple Java application that loads modifes and saves a model.

Summary
-------
At the end the following steps have been made:

![The workflow of the laboratory and the dependencies between the artifacts (marked with dashed lines)](img/emf/ERD2.png)

The final metamodel is:

![The final Ecore model](img/emf/ERDiagram05_final.png)

General tips
------------

    * If anything goes wrong with the regeneration and there is problem with your code you have two options:
    * If the document was not edited by hand or it isn't valuable delete it. Generate the code again, and it should be fine. It works on the Manifest.MF and the plugin.xml too.
    * In other case don't be afraid of rewriting. For example if you delete an item from the metamodel the XMI that contains the instance model might have remaining tags with undefined type. That makes the XMI invalid, but it isn't necessary to start over the instance model; simply delete the unwanted part from the code by hand.
  
References
----------

* Tutorial: <http://eclipsesource.com/blogs/tutorials/emf-tutorial/>