# Xtext

## Creating a textual language

```
grammar hu.bme.mit.mdsd.erdiagram.text.ERDiagramDSL with org.eclipse.xtext.common.Terminals

generate eRDiagramDSL "http://www.bme.hu/mit/mdsd/erdiagram/text/ERDiagramDSL"

ERDiagram:
	attributeTypes+=AttributeType*
	entities+=Entity+
;

Entity:
	'entity' name=ID ('isA' isA=[Entity])?
	'{'
	((attributes+=Attribute) 
	(',' attributes+=Attribute)*)?
	'}'
;

Attribute:
	name=ID ':' type=[AttributeType] (isKey?='key')?
;

AttributeType:
	'type' name=ID ';'?	
;
```



```
type String

entity person {
	name : String,
	id : String key
}

entity car {
	numberPlate : String key
}
```









```
ERDiagram:
	attributeTypes+=AttributeType*
	entities+=Entity+
	relations+=Relation*
;

Relation:
	'relation' name=ID
	leftEnding=RelationEnding
	rightEnding=RelationEnding
;

RelationEnding:
	target=[Entity]
	'('
	(multiplicity=Multiplicity &
		(nullable?='nullable')?
	)
	')'
;

enum Multiplicity:
	one = "One" | many = "Many"
;
```






```
type String

entity person {
	name : String,
	id : String key
}

entity car {
	numberPlate : String key
}

relation car_person car (Many nullable) person (One)
```


### Start from an existing EMF metamodel

download

### 2.0

new project

## Scope

```
class ERDiagramDSLScopeProvider extends AbstractDeclarativeScopeProvider {

	def scope_Entity_isA(Entity ctx, EReference ref){
		Scopes::scopeFor((ctx.eContainer as EntityRelationDiagram).entities.filter[x | x != ctx]);
	}

}
```


## Validation

```
type String
type Int

entity person isA car{
	name : String,
	id : String key
}

entity owner isA person{
	age : Int
}

entity car isA owner{
	numberPlate : String key
}

relation car (Many nullable) person (One)
```



```
class ERDiagramDSLValidator extends AbstractERDiagramDSLValidator {

	public static val CYCLE = "CYCLE";

	@Check
	def checkCycleInInheritance(Entity ctx) {
		checkCycleInInheritance(ctx, ctx.isA)
	}

	def checkCycleInInheritance(Entity ctx, Collection<Entity> parents) {
		if (parents.contains(ctx)) {
			error("Cycle in the inheritance graph", ERDiagramPackage.Literals.ENTITY__IS_A,CYCLE);
			return;
		}
		for (parent : parents) {
			checkCycleInInheritance(ctx, ctx.isA);
		}
	}

}
```