# RPVendorTracker

## Entities (Models)
 - Items
    - item attributes (rarity, category... etc)
 - Vendors
    - vendor attributes (age, race, weight, gender... etc)
 - ListInterface
    - Interface meant to allow Items and Vendors to be referenced by a single pointer
    - Interfaces don't seem to work as I thought they would've.  (Couldnt do things in Swift that I could do in Java)
## Controllers
I got too lazy... maybe later....

### AddOBjViewController
Today's tasks:

- Finish Add/Edit View
- - Programmatically generate the View

AddObjView Structure:

 /--WRAPPER:STACKVIEW Vertical--\
|------STACKVIEW HORIZONTAL------|
|   StackView   |   Stack view   |
|   Vertical    |   Vertical     |
|     Label     |   TextFields   |
|------------ VIEW --------------|
|>----- LABEL: Description -----<|
|>------ TEXTFIELD : DESC ------<|
|------------ /VIEW -------------|
|---------- TABLE VIEW ----------|
|++++++++ TABLE VIEW CELL +++++++|
|(Cancel)___(AddItem)___(AddEdit)|

Notes: 
 CONDITION: dataType == 0
    - TABLEVIEW and (AddItem) VISIBLE
 CONDITION: dataType == 1
    - TABLEVIEW and (AddItem) NotShown

SPECIFICS
====== ADD VENDORS VIEW ======
--Attributes : 5--
NAME : TEXTFIELD
AGE : Horizontal PickerView
GENDER: Some kind of toggle switch between Male and Female
RACE : Horizontal pickerview
WEIGHT: TextField with +/- buttons
DESC: TextField
INVENTORY: TableView with InventoryItemsCells
--Buttons--
(Cancel) : Goes to main view
(Add Item) : opens popup with pickerview for existing Item
(Add/Edit) : if view came from details, text should be edit, if from main, set to Add

====== ADD ITEMS VIEW =======
--Attributes : 4--
NAME: TEXTFIELD
CATEGORY: Horizontal PickerView
RARITY: Horizontal PickerView
WEIGHT: TEXTFIELD with Buttons
DESC: TEXTFIELD
--Buttons--
(Cancel) : Goes to Main view
(Add/Edit) : If view came from Details, displays edit. Else, displays Add