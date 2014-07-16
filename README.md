TheVault
========

Matt's AS3 Library


--------------------------------------------------

v4.0.8
* ButtonBase removed scaleFactor

--------------------------------------------------

v4.0.7
* Added disableScaling to StateStarlingClickable

--------------------------------------------------

v4.0.6
* Added ButtonBase to components package
* Added ButtonBaseTheme to dataObjects
* Together these add a themeable button for starling
* Should Rename this to ButtonBaseStarling & ButtonBaseThemeStarling

--------------------------------------------------

v4.0.5
* Added StateStarlingClickable to the core - This priovides an onTouch event and fires ON_TRIGGERED when clicked, and also scales the object.
  The onTouch function / the dispatching of the event should be made overiddable eventually.
* Added Textfield extension class for Starling that enables the ability to switch of Multiline

--------------------------------------------------

v4.0.4
* StateMangager.as StateMangagerStarling.as are no longer singletons. They are now used as re-usable classes.
  But added a comment to create an interface that emulates a static version of the same thing.
* Added a Database.as helper class the deals with SQLite.

--------------------------------------------------

v4.0.3
StateMangager.as now takes a DisplayObjectContainer instead of a Stage as the holder for states etc. To match StateMangagerStarling.as

--------------------------------------------------

v4.0.2
Latest version of starling
StateManager & StateManagerStarling removed the removeClassPrefixFunction as it's not required, and slowed down state changing

--------------------------------------------------

v4.0.1
StateMangagerStarling.as now takes a DisplayObjectContainer instead of a Stage as the holder for states etc.

--------------------------------------------------
v4.0.0
This is the base point from which I will tidy up the library, removing any unnecessary classes etc.

--------------------------------------------------

