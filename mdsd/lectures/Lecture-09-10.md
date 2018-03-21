# Foundations of Model Transformation

_"We will cover the arrows in the diagram in the slides."_
[Kép]
 - Main focus on the first green and red one on the top: Model generation and Back-annotation.

Model transformation is formalized in rules, and the transformation is carried out by the model transformation engine.

## Motivation Examples

 - Object-relational mapping
	- Hibernate, etc.
	- _input_: metamodel
	 _output_: relational schema
	- transformed with rules
		 - entities -> table
		 - type hierarchy can be flattened so their kind can also be saved in an attribute
		 - the type of attributes are saved as (typed-> table foreign references)
	- Both source and target models have their (simplified, flat) metamodel.
 We introduce a third metamodel, the traceability metamodel connecting the corresponding metamodel parts.
	 - (_Remember_: Critical embedded systems require traceability.)

## Structure of a Graph Transformation rule

As a rule-based transformations GT rules have a left and a right side.

 - Both are formalized as a graph pattern.
 - In a declarative way - we care about the _results_ and not how it's achieved.

A Negative Application Condition (NAC) also tells, which Objects can _not_ be allowed to be transformed. (For instance, in case that classes that don't have a parent class should be transformed differently than classes that do, you have to describe a NAC so that the rule for parent class won't be applied to children classes.)
[kép a diáról]

## Application of Graph Transformation rules

 1. Graph pattern matching - find every node in the graph that can be mapped to the LHS (left hand side) pattern
 2. Applying the NACs in the context of the original matches of step 1. If the NAC matches, the original match is not valid any more.

   NACs can have additional NACs inside. Logically
   > p ∧ ¬ ( p1 ∧ ¬ p2 )

   meaning
   > ∃ x: p(x) ∧ ¬ ( ∃ x1: p1(x1, x) ∧ ¬ ∃ x2: p2(x2, x1, x) )

   can be unfolded to
   > ∃ x: p(x) ∧ ∀ x1: ¬  p1(x1, x) ∨ ¬ (¬ ∃ x2: p2(x2, x1, x) )
   
   Thus, every NAC level alternates the existential and universal quantifiers.

 3. Deleting LHS/RHS from the graph.
 4. Creation and binding - creating the new objects/references/connections.

### Typical problems

 1. We don't always want to delete directly from the source model! Usually we want to preserve the model and create traceability relation between the source and the target.

 1. Application of the same rule among the same match. The termination scenario of the transformation has to be specified - for example the implicit usage of the right hand side as a NAC.

 1. Dangling edges: What happens after the removal of a node? Should the incoming and outgoing edges be deleted?
    - In databases, cascading deletion is common.
 
	But the rule has a side effect! (Semantics of the execution platform. )

    - Instead of deletion, the node is marked as dirty, it will no longer be matched.
    - OR: if the rule would result in a dangling edge, it will not be applied.
	conservative approach:
	 - pro: side-effect free, helps verification
	 - con: several new rules have to be described in order to deal with any kinds of dangling edges



 1. Injective and Non-Injective Matching
	 - **Injective matching** (_"kisajátító"_): For each node in the LHS, separate nodes are matched in the model graph.

	 - **Non-injective matching** (*"közösködő"*): For multiple nodes in the LHS the same node can be matched in the graph.

_What happens, when the same node has to be removed AND preserved?_
  Contradictionary requirements

 - cause: contradictionary specification
 - solution: nodes to deleted LHS are matched with injective semantics.

_Linking MDSD with formal verification, statecharts and Petri-nets_ (?)

#### Conflict/ Parallel Independence
Defined between two rule execution/application.

- **Independence**:
	- Two _rule applications_ are independent if none of them prevent the application of the other.
	- Two _rules_ are independent, if no application of them are conflicting.

We want a _unique_ result - the rule set should be **confluent**. We have nondeterministic decisions during the transformation but the result should be the same in every execution paths.

#### Sequential independence

The order of the rule applications does not affect the result of the rule set application.

If they are not sequentially, they are causally dependent.

But the sequences, the order of rule application can be controlled using causally dependent rules.

## Code Generation by Model Transformation

 - previously: M2M (_model-to-model_) -> M2T (_model-to-text_) transformation (ASF->DOM, DOM -> source code)

### Traceability in Model

 - introducing new references to the source and target models is invasive
 - instead we introduce a traceability model connecting the two model nodes

### Chaining model transformations

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

 - a change model is synthesized and processed into another change model (for the target model)

 - each event of this change model is used to invoke the API calls to modify the target model.

## Level of Incrementality

 - no incrementality: batch transformations
	 - e. g. source code generation, not updated regenerated

 - dirty incrementality:
	 - only the changed models are regenerated
	 - if one model has effect on another one it may have to be reprocessed (dependency analysis).

 - incrementality by traceability
	 - detecting the not traced elements and generating the missing parts = more fine-grained incrementality
	 - it is highly dependent on traceability (correct trac.) information 

 - event driven transformation
	 - as soon as a modification is detected, and a rule is available, generation occurs
	 - this does not use the traceability information -> transformation chain can be achieved (larger transformations split up into smaller)
		 - separation of concerns
		 - reusability, maintainability

 # Design Space Exploration
	 
 - find possible design options
 - needed inputs - declarative requirement/specification
		 - initial design - start state
		 - set of goals to beat
		 - global constraints
		 - transformations
		 - strategy: define how to explore the design space (e.g. DFS, BFS)
		 
 - the output is (multiple) design alternatives

 - quick fixes: when a constraint is violated, a fixing chain of operations, actions are computed to resolve the problem
 
 - guidance of exploration:
	 - hints from the designer/end user - e.g.: only take right turns while computing the route to x.
	 - formal analysis

