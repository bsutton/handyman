# Handyman App

Overview

The Handyman App is an Open Source project that is aimed at serving two purposes.
* Create an app to allow a single person handyman business to manage clients and jobs.
* Serve as a sample app for the Flutter framework

The code base will be licensed under the MIT license.
All copyright will be assigned to the 'Handyman Project'.


Many sample applications suffer by not being used in the real world and as a result
are overly trivial or become obsolete as there is little motiviation to keep the
app up to date. By building a real world app and encouraging a community of developers
and handyman users we can create an learning environment for users new to Flutter
and a baseline app that users can copy for there own purposes.


What is my motivation for building this app?



The aim of the app is to support each of the Flutter deployment targets. In keeping
with the aim of being a r deployment target is Android, with reach goals to support iOS, Web and Desktop.

The core functionality:

Manage list of clients
Manage list of suppliers
Manage list of jobs and categories jobs based on a configurable Status - quoting, prospecting, scheduling etc.
Manage Tasks within a Job.
Schedule Jobs/Tasks


For accounting purposes, you should never be able to delete any entity, just mark them as deleted. The UI should normally hide entities ‘marked for deletion’ but there should be an option to show items ‘marked for deletion’ as well as ‘undeleting them’.

Client Details
Full CRUD - 
Type: business or retail
Customer Name 
Notes:
Primary Contact

Additional Contacts - name, email, role, mobile/cell. Primary Site, Preferred communications - phone, text, email
Primary Site
Additional Sites
Default Hourly Rate - taken from system default hourly rate.

The main client view screen should display the phone number and email of the primary contact.
Clicking the phone should give you the option to call or text the phone number.
Clicking the email should trigger an email compose.

Supplier:
Same as Client - could be the same entity with a type flag Supplier/Customer.
There is a possibility that a supplier could also be a customer, but not very likely.

Job Details
A Job belongs to a Client, Clients may have many jobs.

Jobs are the main focus of the application. There should be the concept of an active job and when the user’s enters the App the active job should be displayed by default.  There should be a quick way to navigate to the active job and a simple method to switch to an different active job.

Scheduling
Jobs need to be scheduled.  Often a job will span multiple, non-contiguous, days.  When scheduling a job, all tasks are scheduled for the same day. If an additional day is scheduled then the users should be able to select which tasks are going to be undertake on that day. Tasks will often need to be moved to a new schedule as slippages are common.

The user should also schedule a start time.

A user should be able to see a calendar view of scheduled jobs. A day and week view are desired. 

When viewing a job the users should be able to see a list of tasks associated with the job.
The list should include:
Name, Status, Scheduled Date - if the job has more than one scheduled date.


Status
Site - one of the sites attached to the Client - should default to the client’s primary site.
Primary Contact 

Status Details:
A list of possible states a Job can be in.
Full CRUD.
Name, Description.


Task details:
Job - the job this task is attached to. Should be able to move tasks between jobs.
Name - of task
Status - the status of the Task. The Task status should be configurable system wide. 
Description - description of task, should all urls to be embedded. Rich text would be nice.
Effort - required to complete the task in hours
Hourly Rate - should be populated from the client’s default rate.
Fixed Cost
Total Cost - Time * Hourly rate +  is entered this should be Time * hourly rate + Materials (from checklist) + Time Estimates from checklist.
The idea is that you can build up your total cost using a variety of techniques.

Check list/Action list/Purchase list - should these be separate things?
You should be able to add a checklist to a task.
The user should be able to create a number of ‘standard checklists’ and copy one of those checklists into the task. E.g. A standard checklist might be a list of tools required for a particular type of job.
The user should be able to manually create items for the checklist (full crud).

Each item in the checklist should allow the following information to be attached
Description 
Type - the set of types should be globally configurable - e.g. Materials, Tools
Purchase - flag to indicate that the item needs to be purchased.
Cost - the cost of the item.
Time Estimate - hours required to complete the item.


The user should be able to sort the list of tasks within the job via drag/drop.

Task Attachments
As part of creating a Task you should be able to take photos or add other attachments to the task. 
You should be able to add a note to each attachment.


System configuration:

Sim - on devices that supports multiple sims, the users should be able to select the SIM to be used when calling or texting.

Task Status
The set of system wide task status.
The default set should be:
In progress
To be scheduled
Awaiting materials
Complete
Canceled
On Hold
In Progress

Job Status
The set of system wide job status’.
This should be configurable

Default set:
Prospecting
To be scheduled
Awaiting Materials
Completed
Rejected
On Hold
In progress

Each status should have:
Description
Visibility - visible/hidden - if marked as hidden then views that display jobs should hide jobs with this status. There should be a filter option to show these hidden jobs.

Reminders:
Keeping clients informed of when the handyman will be on site is an important part of the business.
Reminders should be sent out the day before to each client.
On mobile the handyman should get a reminder 30 minutes before the next appointment and again 10 minutes before.  There should be a simple way for the handyman to reschedule the appointment, with some default options - I’m running 10 min late, Will need to move to tomorrow as well as the ability to type a custom message.  The reminder should also offer a ‘click to call’ option in case the handyman needs to call. The message should be sent via the client’s preferred communication channel.
Purchase List
The purchase list is an aggregation collected from the Checklists of Jobs/Tasks where those items are marked as ‘Purchase’.
The aim is that when visiting a supplier the user can see a single purchase list that covers all current Jobs.
There is a question here about how to handle items from jobs that are on-hold, canceled. Perhaps this could be done by an additional flag on Task/Job status that indicates that any items (with that status) should be suppressed from the purchase list.

The user’s should be able to mark items as purchases as they progress through the list.
Items that have been purchases should be moved to the bottom of the list.
The user should be able to sort the list - via drag/drop.

