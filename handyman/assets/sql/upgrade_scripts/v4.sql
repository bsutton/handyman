update task_status set description = replace(description, 'job', 'task');
update task_status set description = replace(description, 'Job', 'task');


INSERT INTO task_status (name, description, color_code, createdDate, modifiedDate)
VALUE
('Pre-approval', 'The task is yet to be approved by the customer.', '#FFDAB9', datetime('now'), datetime('now')),
('Approved', 'The task has been approved by the customer.', '#3CB371', datetime('now'), datetime('now'));