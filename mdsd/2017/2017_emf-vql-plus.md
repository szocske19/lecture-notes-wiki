Advanced EMF and VIATRA Query API
===============================

In this laboratory, we will briefly cover some advanced concepts of the Eclipse Modeling Framework and then learn how to use the VIATRA Query API.

Setup
-----

1. Import all the projects from the ``VQL`` branch using this repository: https://github.com/FTSRG/mdsd-examples
1. Create a new Java class in the ``hu.bme.mit.mdsd.example`` project named ``AdvancedEmfAndVqlApi`` with a main method.
1. Use the ``ErdiagramModels`` class to load the example model.

```java
public class AdvancedEmfAndVqlApi {

    public static void main(String[] args) throws ViatraQueryException {

        ErdiagramModels erdiagramModels = new ErdiagramModels();
        erdiagramModels.init();

        Resource resource = erdiagramModels.loadResource(URI.createFileURI(
                "C:\\Users\\meres\\git\\mdsd-examples\\hu.bme.mit.mdsd.erdiagram.examplediagrams\\My.erdiagram"));

        EntityRelationDiagram model = erdiagramModels.getModelFromResource(resource);
    }
}
```

Advanced EMF
------------

### EcoreUtil

EcoreUtil has a few interesting helper methods and nested classes that can be useful when working with EMF.
For example, using the ``.getRootContainer()`` will return the root EObject of the model from any model element.

```java
Attribute attribute = model.getEntities().get(0).getAttributes().get(0);
EObject rootContainer = EcoreUtil.getRootContainer(attribute);
System.out.println(model.equals(rootContainer));
// equals will compare by reference only
```

If you have to clone the whole model, there is a helper class for it called ``EcoreUtil.Copier``.
Let's create a helper method for cloning the model, then try it out:

```java
public static EObject clone(EObject model) {
    Copier copier = new Copier();
    // copies the containment hierarchy only
    // call this multiple times if there multiple roots
    EObject clone = copier.copy(model);
    // copies all the other references in the model
    copier.copyReferences();
    return clone;
}
```

Two models can be compared using the ``EcoreUtil.EqualityHelper``, which also compares all the contained eObjects:

```java
public static void equals(EObject model, EObject clone) {
    EqualityHelper helper = new EqualityHelper();
    boolean equals = helper.equals(model, clone);
    System.out.println(equals);
}
```

Try it out:

```java
EntityRelationDiagram clone = (EntityRelationDiagram) clone(model);
equals(model, clone);
attribute.setName("something");
equals(model, clone);
```

### Switch

Besides the Java classes and interface EMF also generates a <Prefix>Switch that helps to do something based on the type of the model element (like a dispatch method in Xtend).
Let's create a switch that returns a String (generic type argument) and overrides the ``caseAttribute()`` method and the ``defaultCase()`` method (otherwise it will return null).

```java
ErdiagramSwitch<String> erdiagramSwitch = new ErdiagramSwitch<String>() {
    @Override
    public String caseAttribute(Attribute object) {
        return object.getName() + " : " + object.getType();
    }

    @Override
    public String defaultCase(EObject object) {
        return "default";
    }
};
```

Then iterate over the whole model using the ``eAllContents()`` method and call ``doSwitch()`` to do the switch.

```java
TreeIterator<EObject> treeIterator = model.eAllContents();
while (treeIterator.hasNext()) {
    EObject eObject = (EObject) treeIterator.next();
    System.out.println(erdiagramSwitch.doSwitch(eObject));
}
```

### Reflective API

A very good concept of the EMF framework is that you can use the metamodel programatically and manipulate the instance model without knowing anything about the metamodel.
Hence you can create metamodel independent tools.
The most important concepts:
* ``EPackage`` represents the metamodel.
* ``EClass`` represents a class in the metamodel.
* ``EAttribute`` and ``EReference`` are inherited from ``EStructuralFeature`` and represent the references and attributes.
* Several other classes you will come across: ``EEnum``, ``EEnumLiteral``, ``EDataType``, ``EAnnotation``
* An ``EObject`` always has an ``eClass()`` method that returns it's ``EClass``.
* You can retrive a value of an attribute by this reflective method call: ``eObject.eGet(eAttribute)``
* Similarly, you can also set its value (if it is a String): ``eObject.eSet(eAttribute, "newValue")``

Let's traverse the model and obfuscate all the attributes that has ``"name"`` as a name:

```java
TreeIterator<EObject> treeIterator = model.eAllContents();
while (treeIterator.hasNext()) {
    EObject eObject = (EObject) treeIterator.next();

    for (EAttribute eAttribute : eObject.eClass().getEAllAttributes()) {
        if (eAttribute.getName().equals("name")) {
            eObject.eSet(eAttribute,
                    Integer.toString(eObject.eGet(eAttribute).hashCode()));
        }
    }
    System.out.println(erdiagramSwitch.doSwitch(eObject));
}
```

A bit more wierd concpet is that all these reflective classes are derived from ``EObject``.
Yes, the Ecore model is an Ecore model :)

Let's do a similar switch as before, but on the metamodel:

```java
EcoreSwitch<String> ecoreSwitch = new EcoreSwitch<String>() {
    @Override
    public String caseEEnum(EEnum object) {
        return "Enum: " + object.getName();
    }
    @Override
    public String caseEEnumLiteral(EEnumLiteral object) {
        return " Literal: " + object.getName();
    }
    @Override
    public String defaultCase(EObject object) {
        return object.toString();
    }
};

EPackage ePackage = model.eClass().getEPackage();
TreeIterator<EObject> treeIterator2 = ePackage.eAllContents();
while (treeIterator2.hasNext()) {
    EObject eObject = (EObject) treeIterator2.next();
    System.out.println(ecoreSwitch.doSwitch(eObject));
}
```

### Adapters

Adapters are for notifications.
If the model is changed somehow, you will get a notification.
This infrastructure is connected to the ``Notifier`` interface, which is the ancestor of the ``EObject``, ``Resource`` and ``ResourceSet`` interfaces.
It has an ``eAdapters()`` method.
There are quite a few built-in ``Adapter`` implementations that can be handy.
However adapters are a bit hard to use and it's highly recommended to use VIATRA Query advanced features for notifications (see at the end of this tutorial).

Let's create an adapter that notifies if something is changed in the root object:


```java
model.eAdapters().add(new AdapterImpl() {
    @Override
    public void notifyChanged(Notification msg) {

        System.out.println(msg.getNotifier() + " : " + msg.getOldStringValue()
                + " -> " + msg.getNewStringValue());

        super.notifyChanged(msg);
    }
});

model.setName("dfd");
model.getEntities().remove(0);
```

// TODO: Editing domain

// TODO: EMap, Contextual Explorer, XMI, LoadResource

VIATRA Query API
----------------

You will need dependencies to the following:
```java
org.eclipse.viatra.query.runtime // query runtime
org.eclipse.viatra.query.runtime.base.itc // needed for headless mode
hu.bme.mit.mdsd.erdiagram.queries // queries of the previous laboratory
com.google.common.collect // guava, we will using the Sets class only
org.apache.log4j // logging utility that VIATRA uses
```

First of all, let us configure the log4j framework.
It should be configured via file but now we will use a quick and dirty method.:

```java
BasicConfigurator.configure();
Logger.getRootLogger().setLevel(Level.WARN);
```

The main API class of VIATRA Query is the ``ViatraQueryEngine`` which should be initialized on a model (Notifier).
The ``EMFScope`` is required to wrap this notifier (here I use the cloned model so it is unchanged):

```java
EMFScope scope = new EMFScope(clone);
ViatraQueryEngine queryEngine = ViatraQueryEngine.on(scope);
```

Notice that VIATRA generated a bunch of Java classes based on the vql file int .queries project.
It generates four classes for each pattern (expect if it has a private modifier):
* ``<patternName>QuerySpecification`` that represents a pattern.
* ``<patternName>Matcher`` that represents a pattern initialized on a model.
* ``<patternName>Match`` that represents a single result of a query on a model.
* ``<patternName>Processor`` that can be used to do something on a match.

The matcher has a lot of interesting methods, such as getting all the matches, counting the all the matches or you can use a filter on the result set.
Let's see the API in use:

```java
// Get a matcher - it will return the very same matcher if called multiple times on the same engine
EntityCompareMatcher matcher = queryEngine.getMatcher(EntityCompareQuerySpecification.instance());
// Count matches
int countMatches = matcher.countMatches();
System.out.println(countMatches);

// Filter matches by binding the first parameter
Collection<EntityCompareMatch> allMatches = matcher.getAllMatches(clone.getEntities().get(0), null);
for (EntityCompareMatch match : allMatches) {
    System.out.println(match.getE1().getName() + " : " + match.getE2().getName());
}

// Do something for each match
matcher.forEachMatch(new EntityCompareProcessor() {

    @Override
    public void process(Entity pE1, Entity pE2) {
        System.out.println(pE1.getName() + " : " + pE2.getName());
    }
});
```

Initializing a matcher can be costly and it is better to them in batch.
For this use ``QueryGroup`` and call the ``prepare()`` method:
* either the generated java class based on the .vql file's name,
* or for example an anonym implementation of the ``BaseQueryGroup``:

```java
Queries.instance().prepare(queryEngine);

new BaseQueryGroup() {

    @Override
    public Set<IQuerySpecification<?>> getSpecifications() {
        try {
            return Sets.newHashSet(EntitiesQuerySpecification.instance());
        } catch (ViatraQueryException e) {
            e.printStackTrace();
        }
        return null;
    }
}.prepare(queryEngine);
```

Using the ``NavigationHelper`` of VIATRA Query (basically the indexer) also supports notifications basic indexing funcionality and for subsribing to various notifiactions.
For example, you can subsribe to an appearance or disappearance of a specific type of ``EObject``:

```java
// Get the NavigationHepler
NavigationHelper navigationHelper = EMFScope.extractUnderlyingEMFIndex(queryEngine);

// Add listener to any inserted or deleted Entity
navigationHelper.addInstanceListener(Sets.newHashSet(
        ErdiagramPackage.Literals.ENTITY),
        new InstanceListener() {

            @Override
            public void instanceInserted(EClass clazz, EObject instance) {
                System.out.println("Inserted: " + instance);
            }

            @Override
            public void instanceDeleted(EClass clazz, EObject instance) {
                System.out.println("Deleted: " + instance);
            }
        });

// Try it out
Entity entity = clone.getEntities().remove(0);
clone.getEntities().add(entity);
```
