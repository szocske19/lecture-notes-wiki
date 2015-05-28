# Foundations of Model Transformation

"We will cover the arrows in the diagram in the slides."

 - Main focus on the first green and red one on the top: Model generation and Back-annotation.

Model T. is formalized in rules, and the transformation is carried out by the MT engine.

## Motivation Examples

 - Object-relational mapping
Hibernate, ...

input: metamodel
output: relational schema

 - transformed with rules
	 - entities -> table
	 - type hierarchy can be flattened so their kind can also be saved in an attribute
	 - the type of attributes are saved as (typed-> table foreign references)
	 - ...
 - Both source and target models have their (simplified, flat) metamodel.

 We introduce a third metamodel, the traceability metamodel connecting the corresponding metamodel parts.

(Remember, that critical embedded systems require traceability.)

## Structure of a GT rule

As a rule-based transformations GT rules have a left and a right side.

 - both are formalized as a graph pattern.
 - in a declarative way, we are about the results and not how it's achieved.

A Negative Application Condition (NAC) also tells, which Objects can not be/allowed to be transformed a candidate for the tr.

[kép a diáról]

e.g., classes that don't have a parent class

## Application of GT rules

 1. Graph pattern matching
 find every node in the graph that can be mapped to the LHS pattern
 2. Applying the NACs in the context of the original matches of step 1. If the NAC matches, the original match is not valid any more.

   NACs can have additional NACs inside.
   [kód]

   Every NAC level alternates the existential and universal quantifiers.

 3. Deletion of LHS/RHS from ... graph.
 4. relation and binding
    creating the new objects/references/connections

### Typical problems

 - We don't always want to delete from the source model! usually we want to preserve them and create traceability relation between the source and the target.

 - Application of the same rule among the same match. The termination scenario of the transformation has to be specified:
for example the implicit usage of the right hand side as a NAC.

 - Dangling edges: What happens after the removal of a node? The incoming and outgoing edges should be deleted?
 - in databases, cascading deletion is common.
But the rule has a sideeffect! (semantics of the execution platform. )

	 - Instead of deletion, the node is marked as dirty, it will no longer be matched.

	 - OR: if the rule would result in a dangling edge, it will not be applied
  => conservative approach:

		 - pro:  side-effect free, helps verification
		 - con: ...



 - Injective and Non-Injective Matching
	 - Injective matching (*kisajátító*): For each node in the LHS, separate
	   nodes are matched in the model graph.

	 - Non-injective matching (*közösködő*): For multiple nodes in the LHS the same node can be matched in the graph.

  => What happens, when the same node has to be removed AND preserved?
  contradictionary requirements

 - con: contradictionary specification
 - solution: nodes to deleted LHS are matched with injective semantics.

linking MDSD with formal verification, statecharts and petri-nets

#### Conflict/ Parallel Independence
Define between two node execution/application.
Two rule rule applications are independent if none of them prevent the application of the other.

Two rules are independent, if no application of them are conflicting.

We want a unique result - the ruleset should be confluent

We have nondeterministic decisions during the transformation but in the end it has to be deterministic.

#### Sequential independence

The order of the rule applications does not affect the result of the rule set application.

If they are not sequentially, they are causally dependent.

But the sequences, the order of rule application can be controlled using causally dependent rules.

## Code Generation by Model Transformation

 - previously: M2M -> M2T transformation (ASF->DOM, DOM -> source code)

### Traceability in Model

 - introducing new references to the source and target models is invasive
 - instead we introduce a traceability model connecting the two model nodes

### Chaining of MT

Introduce multiple sequential transformations in order to

 - reduce gigantic transformations,
 - like in software development, we use the available tools -> multiple methods, smaller parts

## Incrementality in Model Transformations

 - We distinguish incremental forward and backward model transformation.
 - Incremental process is applied when a change is made, avoiding complete reprocessing.

### Incremental Backward Transformation

 - the target model is changed, the source model has to follow
 e.g.
	 - source code (target) is  manually changed
	 - the target is a database view, and modifications are propagated into the source model

 - it is harder to transform backwards, as there are multiple modification resulting the same result in the target
	 - src -> trg specified
	 - trg -> src inferred

### Change Driven Model Transformations

 - the model may not be in the same framework, but you could have an API

 - a change model is synthesized processed into another change model (for the target model)

 - each event of this change model is used to invoke the API calls to modify the target model.

##Level of Incrementality

 - no incrementality: batch transformations
	 - e. g. source code generation, not updated regenerated

 - dirty incrementality:
	 - only the changed models are regenerated
	 - if one model has effect on another one it may have to be reprocessed (dependency analysis).

 - inrementaility by traceability
	 - detecting the not traced elements and generating the missing parts = more fine-grained incrementality
	 - it is highly dependent on traceability (correct trac.) information : remember, for critical systems, this is required

 - event driven transformation
	 - as soon as a modification is detected, and a rule is available, generation occurs
	 - this does not use the traceability information => tranformation chain can be achieved (larger transformations split up into smaller)
		 - separation of concerns
		 - reusability, maintainability

 - Design Space Exploration
	 - find possible design options
	 - needed inputs - declarative requirement/specification
		 - initial design - start state
		 - set of goals to beat
		 - global constraints
		 - transformations
		 - strategy: define how to explore the design space (e.g., DFS, BFS *mélységi bejárás*, *szélességi bejárás*)
	 - the output is (multiple) design alternatives

 - quick fixes: when a constraint is violated, a fixing chain of operations, actions are computed to resolve the problem
 - guidance of exploration:
	 - hints from the designer/end user: e.g.: only take right turns which computing the route to x.
	 - formal analysis
