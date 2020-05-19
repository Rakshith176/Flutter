# TODO
A flutter application where users can add their daily todos.

## Table of contents
* [General info](#general-info)
* [Installation](#installation)
* [About](#about)
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
The idea used to design this app was mapping the list of elements with a particular date and displaying them when that date was clicked...
The flutter calendar package is used for displaying and accessing the the calendar..
The **_events** is a map that maps Date and its respected events that are added in it...
Everytime the user clicks a date in the calendar(which is present on the screen all the time) user can add the events to that respected date and the events for the date is displayed when the date is clicked..
- The State Management method **setState** was used as the app depended on only one state to be changed (i.e only the map had to be updated on any event that took place.. bloc was too complicated to be implemented for it to be used in this idea of the app)..
-The code has comments which makes easier for the reader to understand it..


## Packages
- Hive: Flutter hive package is used to store data locally.(#https://pub.dev/packages/hive)
- Table calendar: Flutter calendar package for displaying and working on the calendar(#https://pub.dev/packages/table_calendar)
- Flutter Notifications: Notification package was used to display notifications(#https://pub.dev/packages/flutter_local_notifications)








