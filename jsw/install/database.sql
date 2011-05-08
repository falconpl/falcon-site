-- Main project definitions.
-- Dependency: 	None
-- Success: 	The Project table is created.
-- Time:    	Fast
CREATE TABLE Project (
	id 				INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	name 			VARCHAR(100) NOT NULL COMMENT 'Name of project.',
	enabled			TINYINT NOT NULL DEFAULT 1 COMMENT 'Whether the project is active and can be used.',
	initialStatus	INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Reference to TaskStatus.id; The status of new issues when created.',
	PRIMARY	KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Main projects table.'; 
-- END

-- Basic User information.
-- Dependency: 	[Project]
-- Success: 	The User table is created.
-- Time:    	Fast
CREATE TABLE User (
	id 				INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	email			VARCHAR(100) NOT NULL COMMENT 'User email address.',
	password		VARCHAR(50)  NOT NULL COMMENT 'User password.',
	PRIMARY	KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Basic user info.'; 
-- END

- Linkage between User and Project.
-- Dependency: 	(User), (Project)
-- Success: 	This table is created.
-- Time:    	Fast
CREATE TABLE LinkUserProject (
	userId			INT UNSIGNED NOT NULL COMMENT 'Reference to User.id.',
	projectId 		INT UNSIGNED NOT NULL COMMENT 'Reference to Project.id',
	role			ENUM('viewer','reporter','developer','admin') COMMENT 'Role of user in this project.',
	PRIMARY	KEY(userId, projectId),
	FOREIGN KEY (userId)
		REFERENCES User(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (projectId)
		REFERENCES Project(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Links users and projects and assigns user roles.'; 
-- END

-- Holds task version values.
-- Dependency: 	(Project)
-- Success: 	The Release table is created.
-- Time:    	Fast
CREATE TABLE TaskRelease (
	id 			INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	projectId 	INT UNSIGNED NOT NULL COMMENT 'Reference to Project.id',
	name 		VARCHAR(50) NOT NULL COMMENT 'Name of version.',
	scheduled	DATE NOT NULL COMMENT 'A tentative release date.',
	enabled		TINYINT NOT NULL DEFAULT 1 COMMENT 'Whether users can use this release or not.',
	PRIMARY	KEY(id),
	FOREIGN KEY (projectId)
		REFERENCES Project(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Task release types.'; 
-- END

-- Holds task priority values.
-- Dependency: 	(Project)
-- Success: 	The TaskPriority table is created.
-- Time:    	Fast
CREATE TABLE TaskPriority (
	id 			INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	projectId 	INT UNSIGNED NOT NULL COMMENT 'Reference to Project.id',
	rank		INT NOT NULL DEFAULT 1 COMMENT '1 is highest; for ordering.',
	name 		VARCHAR(50) NOT NULL COMMENT 'Name of priority.',
	PRIMARY	KEY(id),
	FOREIGN KEY TaskPriority_projectId (projectId)
		REFERENCES Project(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Task priorities types.'; 
-- END


-- Holds task category values.
-- Dependency: 	(Project)
-- Success: 	The TaskCategory table is created.
-- Time:    	Fast
CREATE TABLE TaskCategory (
	id 			INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	projectId 	INT UNSIGNED NOT NULL COMMENT 'Reference to Project.id',
	name 		VARCHAR(50) NOT NULL COMMENT 'Name of category.',
	PRIMARY	KEY(id),
	FOREIGN KEY TaskCategory_projectId (projectId)
		REFERENCES Project(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Task categories types.'; 
-- END

-- Holds task status values.
-- Dependency: 	(Project)
-- Success: 	The TaskStatus table is created.
-- Time:    	Fast
CREATE TABLE TaskStatus (
	id 				INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	projectId 		INT UNSIGNED NOT NULL COMMENT 'Reference to Project.id',
	rank			INT NOT NULL DEFAULT 1 COMMENT '1 is highest; for ordering.',
	color			CHAR(6) NULL DEFAULT '' COMMENT 'The color to give the task rows with this status (in hex).',
	name 			VARCHAR(50) NOT NULL COMMENT 'Name of status.',
	closedContext	TINYINT NOT NULL DEFAULT 0 COMMENT 'Whether this status can be used in for closed tasks.',
	PRIMARY KEY(id),
	FOREIGN KEY TaskStatus_projectId (projectId)
		REFERENCES Project(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Task status types.'; 
-- END

-- The table which holds the tasks information.
-- Dependency: 	(User), (Project), (TaskCategory), (TaskStatus), (TaskPriority), (TaskVersion)
-- Success: 	The Task table is created.
-- Time:    	Fast
CREATE TABLE Task (
	id 				INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	projectId		INT UNSIGNED NOT NULL COMMENT 'Reference to Project.id',
	categoryId 		INT UNSIGNED NULL COMMENT 'Reference to TaskCategory.id',
	statusId 		INT UNSIGNED NULL COMMENT 'Reference to TaskStatus.id',
	priorityId 		INT UNSIGNED NULL COMMENT 'Reference to TaskPriority.id',
	releaseId 		INT UNSIGNED NULL COMMENT 'Reference to TaskRelease.id',
	reporterId 		INT UNSIGNED NULL COMMENT 'Reference to User.id',
	dateCreated 	DATETIME NOT NULL COMMENT 'Date task was created.',
	dateUpdated 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last time task was updated.',
	summary 		VARCHAR(128) NOT NULL COMMENT 'A short description of the task.',
	description 	TEXT NOT NULL COMMENT 'Full description of the task.',
	PRIMARY KEY(id),
	FOREIGN KEY Task_projectId (projectId)
		REFERENCES Project(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY Task_categoryId (categoryId)
		REFERENCES TaskCategory(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY Task_statusId (statusId)
		REFERENCES TaskStatus(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY Task_priorityId (priorityId)
		REFERENCES TaskPriority(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY Task_releaseId (releaseId)
		REFERENCES TaskRelease(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY Task_reporterId (reporterId)
		REFERENCES User(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Main tasks table.'; 
-- END

-- User to task mapping.
-- Dependency: 	[User, Task]
-- Success: 	The LinkUserTask table is created.
-- Time:    	Fast
CREATE TABLE LinkUserTask (
	userId 		INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Reference to User.id',
	taskId 		INT UNSIGNED NOT NULL COMMENT 'Reference to Task.id',
	PRIMARY KEY(userId, taskId),
	FOREIGN KEY LinkUserTask_userId (userId)
		REFERENCES User(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (taskId)
		REFERENCES Task(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User to task mapping; one task may have many users assigned.'; 
-- END

-- Notes related to a task.
-- Dependency: 	(Task)
-- Success: 	The TaskNote table is created.
-- Time:    	Fast
CREATE TABLE TaskNote (
	id 				INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	taskId 			INT UNSIGNED NOT NULL COMMENT 'Reference to Task.id',
	creatorId 		INT UNSIGNED NULL COMMENT 'Reference to User.id',
	dateCreated 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date this note was created.',
	subject			VARCHAR(100) NOT NULL COMMENT 'Title of note.',
	description 	TEXT NOT NULL COMMENT 'Full commentary.',
	PRIMARY	KEY(id),
	FOREIGN KEY TaskNote_taskId (taskId)
		REFERENCES Task(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY TaskNote_creatorId (creatorId)
		REFERENCES User(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Each task can have many notes.'; 
-- END


-- Task list filters.
-- Dependency: 	[Task]
-- Success: 	The TaskFilter table is created.
-- Time:    	Fast
CREATE TABLE TaskListFilter (
	id 				INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key.',
	ownerID 		INT UNSIGNED NOT NULL COMMENT 'Reference to User.id',
	projectId		INT UNSIGNED NOT NULL COMMENT 'Reference to Project.id',
	categoryId 		INT UNSIGNED NULL COMMENT 'Reference to TaskCategory.id',
	statusId 		INT UNSIGNED NULL COMMENT 'Reference to TaskStatus.id',
	priorityId 		INT UNSIGNED NULL COMMENT 'Reference to TaskPriority.id',
	releaseId 		INT UNSIGNED NULL COMMENT 'Reference to TaskRelease.id',
	assignedId 		INT UNSIGNED NULL COMMENT 'Reference to User.id',
	reporterId 		INT UNSIGNED NULL COMMENT 'Reference to User.id',
	primarySort		ENUM('id','priority','category','status','release') NOT NULL DEFAULT 'status' COMMENT 'Primary sort column.',
	secondarySort	ENUM('id','priority','category','status','release') NOT NULL DEFAULT 'priority' COMMENT 'Secondary sort column.',
	sortDir			ENUM('asc', 'desc') NOT NULL DEFAULT 'asc' COMMENT 'The directory of the sort.',
	name			VARCHAR(30) NOT NULL COMMENT 'Name of filter.',
	closedPolicy	TINYINT NOT NULL DEFAULT 0 COMMENT '0 shows both opened and closed; > 0 opened only; < 0 closed only.',
	globalContext	TINYINT NOT NULL DEFAULT 0 COMMENT 'True if this filter is available to everyone, false for only the owner.',
	PRIMARY	KEY(id),
	FOREIGN KEY (ownerId)
		REFERENCES User(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (projectId)
		REFERENCES Project(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (categoryId)
		REFERENCES TaskCategory(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (statusId)
		REFERENCES TaskStatus(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (priorityId)
		REFERENCES TaskPriority(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (releaseId)
		REFERENCES TaskRelease(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (assignedId)
		REFERENCES User(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (reporterId)
		REFERENCES User(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Filters for the task list.'; 
-- END

-- Extended User information.
-- Dependency: 	[Project]
-- Success: 	The UserExt table is created.
-- Time:    	Fast
CREATE TABLE UserExt (
	userId 			INT UNSIGNED NOT NULL COMMENT 'Reference to User.id',
	fullname		VARCHAR(100) NOT NULL COMMENT 'User entire name.',
	lang			CHAR(5) NOT NULL DEFAULT 'en_us' COMMENT 'The language to show the user',
	currentProject	INT UNSIGNED NULL COMMENT 'Reference to Project.id; Current project the user has active.',
	currentFilter	INT UNSIGNED NULL COMMENT 'Reference to TaskListFilter.id',
	active			TINYINT NOT NULL DEFAULT 1 COMMENT 'Whether this user is active or not.',
	FOREIGN KEY (userId)
		REFERENCES User(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (currentProject)
		REFERENCES Project(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (currentFilter)
		REFERENCES TaskListFilter(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Extended user info.'; 
-- END

-
-- Create index on (User) to speed up some lookups and to restrict dup emails.
-- Dependency: 	(User)
-- Success: 	Index for (User.email) is created.
-- Time:    	Fast
CREATE UNIQUE INDEX _User_email ON User(email);
-- END

-- Create unique index on [TaskListFilter(ownerId, projectId, name)] to make 
-- 		sure that filter names are unique.
-- Dependency: 	None
-- Success: 	Unique index created.
-- Time:    	Fast
CREATE UNIQUE INDEX _TaskListFilter_opn ON TaskListFilter(ownerId, projectId, name);
-- END

-- Insert initial project data.
-- Dependency:  All project tables created.
-- Success: 	All data inserted successfully.
-- Time:		Fast
--
-- Create the 'default' project.
INSERT INTO Project(name) VALUES('Default Project');

-- Create the 'super' user.
INSERT INTO User(email, password)
	VALUES('super@example.com', 'foobar');

-- Create the super user's extended info.
INSERT INTO UserExt(fullname, userId, currentProject) 
	VALUES('Super Intendent', 1,
		   (SELECT id FROM Project ORDER BY id ASC LIMIT 1));

-- Link the super user to the default project.
INSERT INTO LinkUserProject(userId, projectId, role)
	VALUES((SELECT id FROM User ORDER BY id ASC LIMIT 1),
		   (SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   'admin'); 

-- Insert a release.
INSERT INTO TaskRelease(projectId, name, scheduled)
	VALUES((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '0.1.0_Sample',
		   '2037-01-01');

-- Insert some Priorities.
INSERT INTO TaskPriority(projectId, rank, name)
	VALUES((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '5',
		   'Unknown'),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '4',
		   'Low'),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '3',
		   'Medium'),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '2',
		   'High'),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '1',
		   'Critical');

-- Insert some Statuses.
INSERT INTO TaskStatus(projectId, rank, color, name, closedContext)
	VALUES((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '7',
		   'CCCCCC',
		   'Created',
			0),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '6',
		   'CCFFFF',
		   'Definition',
			0),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '5',
		   '99CC66',
		   'Implementation',
			0),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '4',
		   '6699CC',
		   'Testing',
			0),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '3',
		   '00FF00',
		   'Completed',
			0),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '2',
		   'FFCC99',
		   'Released',
			1),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   '1',
		   'FF0000',
		   'Killed',
			1);

-- Insert some Categories.
INSERT INTO TaskCategory(projectId, name)
	VALUES((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   'Feature'),
		  ((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   'Bug');

-- Insert on task into the default project.
INSERT INTO Task(projectId, categoryId, statusId, priorityId, releaseId, 
				 reporterId, dateCreated, summary, description)
	VALUES((SELECT id FROM Project ORDER BY id ASC LIMIT 1),
		   (SELECT id FROM TaskCategory WHERE name = 'Feature' LIMIT 1),
		   (SELECT id FROM TaskStatus WHERE name = 'Created' LIMIT 1),
		   (SELECT id FROM TaskPriority WHERE name = 'Critical' LIMIT 1),
		   (SELECT id FROM TaskRelease ORDER BY id ASC LIMIT 1),
		   (SELECT id FROM User ORDER BY id ASC LIMIT 1),
		   NOW(),
		   'Configure your task tracker', 
		   'The installation was successful. You should configure the installation, including changing the username and password for the super user.');

-- Link the super user to the task just created above.
INSERT INTO LinkUserTask(userId, taskId)
	VALUES((SELECT id FROM User ORDER BY id ASC LIMIT 1),
		   (SELECT id FROM Task ORDER BY id ASC LIMIT 1));

-- END
		   
-- drop table LinkUserProject, LinkUserTask, TaskCategory, TaskNote, 
-- TaskPriority, TaskRelease, TaskStatus, Task, User, Project
