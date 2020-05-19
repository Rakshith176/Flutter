# TODO
A flutter application where users can add their daily todos.

## Table of contents
* [General info](#general-info)
* [Installation](#installation)
* [About](#about)
* [Screenshots](#screenshots)
* [Packages](#packages)




## General info
This is a todo app with a calendar view which makes it easier for the user to set their events by just clicking on the desired date on the calendar...
The user can add, edit, delete their tasks on thier preference with no limitations on the number of tasks..


## Installation
Run the following code in the command line in your prefered location:
```
git clone https://github.com/Rakshith176/Rakshith.H.R_IRIS_2020.git
```
and follow the flutter set up documentation [Get started with flutter](https://flutter.dev/docs/get-started/install)
once your done with setting flutter on your device use the files that you cloned to start using the app


## About
- The idea used to design this app was mapping the list of elements with a particular date and displaying them when that date was clicked...
- The flutter calendar package is used for displaying and accessing the the calendar..
- Today's date stays highlighted throughout the app..
- The **_events** is a map that maps Date and its respected events that are added in it...
- Everytime the user clicks a date in the calendar(which is present on the screen all the time) user can add the events to that respected date and the events for the date is displayed when the date is clicked..
- The State Management method **setState** was used as the app depended on only one state to be changed (i.e only the map had to be updated on any event that took place.. bloc was too complicated to be implemented for it to be used in this idea of the app)..
-The code has comments which makes easier for the reader to understand it..


## Screenshots
![Screenshot_20200520-020057 1](https://user-images.githubusercontent.com/58885049/82376345-91ebfa80-9a3f-11ea-8aaa-1dbaa7fd12c4.jpg)
![Screenshot_20200520-020252 1](https://user-images.githubusercontent.com/58885049/82376433-bfd13f00-9a3f-11ea-8faf-71d5fb77abbc.jpg)
![20200520_020028 1](https://user-images.githubusercontent.com/58885049/82376738-2f472e80-9a40-11ea-9e0f-535eaf14202e.gif)





## Packages
- Hive: Flutter hive package is used to store data locally.(#https://pub.dev/packages/hive)
- Table calendar: Flutter calendar package for displaying and working on the calendar(#https://pub.dev/packages/table_calendar)
- Flutter Notifications: Notification package was used to display notifications(#https://pub.dev/packages/flutter_local_notifications)


### ** Contact if any part of code is not self explanatory or couldnt figure out the purpose **


### Doubt
I have tried implementing the bloc pattern but got stuck to actually use state as all events are related with the same state and i failed to use it in the ui(i couldnt convert my type of code to the bloc pattern sorry)








