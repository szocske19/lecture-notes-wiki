# Statecharts = States + Transitions
- first statecharts date back to the '70s
- used to define reactive behavior
- if no event comes, you stay in the stable state.
- extending finite automate:
  - state hierarchy
  - concurrency
  - memory


## State attributes
- +entry action
- +exit
- OR - if the parent is active, only one child can be active at the same time
- AND -  if the parent is active every child/concurrent state must have active state.

## Transitions
Transitions are always connect borders of states, but not necessarily on the same abstraction level. History is a pseudo-state maintaining the "normal" state.

# Triggers
Usually a logical formula based on other states.
- timeout trigger -after given time elapses
- complex transitions
 - fork : ![fork transition](https://lh3.googleusercontent.com/-9u-_m8kphYI/VVpXKovcukI/AAAAAAAAASk/tgqH0ww-5OM/s50/join.png "join.png")
 - join:  ![join transition](https://lh3.googleusercontent.com/-y9XTfx6W3BE/VVpXVp4glMI/AAAAAAAAASw/xEjWxqsZ9mY/s50/fork.png "fork.png")  
 - condition: ![conditional transition](https://lh3.googleusercontent.com/-Mq_AvhZyALE/VVpXe2nOzfI/AAAAAAAAAS8/ocffxVvdGzw/s50/condition.png "condition.png")

With hierarchical states, the active state configuration is always an active state hierarchy.

The propagation of the activeness is  a top-down (AND/OR)  and bottom-up (to be active, the parent also has to be active) at the same time.

## Semantics of Transitions
Always process one event at a time, which is provided by the scheduler. There is no state change without an event. If the same trigger uses multiple transitions - fire in different regions, they (can) fire.

## Steps of Event Processing
0. Select event.

1. The scheduler triggers an event for the statech. - ! in a stable state config.

2. Find/calculate the fireable transitions (fireable = enabled + max. priority).

  A conflict happens, where two triggers are enabled in the same source state. The priority selects the transition to be fired.
  - UML : the "lower" transition has higher priority
  - or the higher behaviour can not be overwritten

3. The selection of the fireable sets (maximal selection of non-conflicting transitions)
  - is nondeterministic.

4. Fire the selected transitons in a nondeterministic order, but this now is not a problem, as there is no conflicting state.

## Textual Modeling Languages
In IDEs, it is the source code. It is parsed and converted into ASTs. But these are not usually presented to the user. When the references are band /resolved inside the tree becomes a graph => Abstract Syntax Graph.

DOM: does not have everything: e.g., the method statements do not have to be present. There is also references to other libraries.
Refactoring can be made in the model view, and then pretty printed back to a source code representing the new DOM.

## Architecture of Compilers
parsing (on demand)
in modern compilers, the parsing is continuous -> AST is always generated.

### Services of Modern Compilers
- Syntactic (grammar is needed):
  - syntax checkign
  - syntax highlighting
  - outline view

- Semantics (resolution of the references):
  - code completion
  - error scheduling
  - refactoring

## Textual Domain Specific Languages
The model is a text file, no longer a visible code model, e.g., a configuration file...
 - Regular Expressions  
 -

### Grammar
- terminal symbols: e.g., Zoltán, István, David
- non-terminal symbols: e.g., `, `, `and`

They can be parsed two way:

![enter image description here](https://lh3.googleusercontent.com/vFU2M3HKSZ3JRdfnFFt6VlKmbJXl-D4CPPUGkmakI9E=s400 "derivationtree.png")

- From sentence level to non-terminal symbols -> construct somehow the sentence ...
- From terminal symbols -> sentence non-terminal symbols

- To parse, you have to have words/tokens, produced by the *Lexer*. ([`c`,`l`,`a`,`s`,`s`] => `class`, character -> token)
- The input of the parser is a token stream.

#### Variable Handling
Variables are references to the declaration in the same scope.
