# Lecture 1

varro[]mit.bme.hu

##Tárgy követelmények

 - 3HF (3 fős csapatokban),
 - szóbeli vizsga (hf. 50%-ban beleszámít),
 - csoportokról email: febr. 12-ig
 - Felhasznált platformok: Git+Basecamp

Mindig vasárnap este a feltöltési határidő, de a beadás más időpontban van, ezen mindenkinek meg kell jelennie. Munkanaplót kell majd vezetni, és a házi feladat során oda kell figyelni az egyenlő terhelésre.

--------------------------------------

##3 milestones

 1. week 6: module, constraints
 2. week 10: graphical and textual modelling lang.
 3. week 14: code generator for simulation

--------------------------------------

##Motivation for MDSE

- **abstraction**
	- separating the problem into smaller more abstracted problem
	- may finish sooner with this approach
	- \+ portability

- **automated code generation**
	*button --> nice, fancy code instead of maintaining the software, you maintain the model*
	(You don't need unit testing, but have to test in other ways.)
- **quality** is a key driver
	*example: Airbus a380s have been developed with model-driven technologies.*
	certification process might be required
	software tool qualification
	- simultaneously increase productivity and quality 

-----

##Transition from traditional V-model to Y model
1. early validation
	- much cheaper to catch a problem early in the process
	- diagrams are not just for documentation
		- a development tool: *a tool, that introduces new errors into your design*
		- a verification tool: *a tool, that fails to detect existing errors in your design*

2. automated code generation
	- quaility ++
	- tools ++
	- development cost \-\-

------

V-model image, explanation

------

**System design (engineering)**
- Top-down approach
- Carried out by large companies, which often don't do everything themselves
- See their system as a whole and than coming out the exact components
- You can check it in advance (check reliability and availability of your system)

**Software design (engineering)**
- Equipment Design
- Executed by the contractors of these companies

**Non-/Extra-functional properties**
Extra-functional property: property applied to the whole system (*if one component is doing wrong the whole system can be wrong, and all of the components need to cooperate in order to achieve the functionality*) e.g. safety, computer security

**Normal functional property**: press a button -> the phone calls
