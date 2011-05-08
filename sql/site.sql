create table members
(
   member_id varchar(15) primary key,
   password varchar(15) character set utf8 not null,
   name varchar(40) character set utf8,
   surname varchar(40) character set utf8,
   email varchar(60),
   homesite varchar(80),
   activity varchar(255) character set utf8,
   status set( 'enabled', 'disabled' ),
   membership set( 'inner', 'outer', 'developer', 'contributor', 'flanker', 'none' ) default 'none'
);

create table projects
(
   project_id varchar(20) primary key,
   name varchar(30) character set utf8 not null unique,
   description TEXT character set utf8,
   project_type set( 'featured', 'internal', 'module', 'project' ) not null,
   status set( 'active', 'inactive' ) default 'active',
   current_version varchar(15) character set utf8,
   next_version varchar(15) character set utf8,
   official_release BIGINT UNSIGNED,
   latest_release BIGINT UNSIGNED,
   svnloc varchar(80),
   details text charset utf8
);

create table project_members
(
   project varchar(20),
   member varchar(15),
   role set( 'admin', 'developer', 'support' ),
   primary key( project, member )
);

create table project_tasks
(
   task_id SERIAL primary key,
   task_project varchar(20),
   task_prjversion varchar(15) charset utf8 ,
   task_name varchar(60),
   task_weight integer,
   task_completion smallint,

   index( task_project, task_prjversion )
);


create table project_dloads
(
   dload_id SERIAL primary key,
   project_id varchar(20) not null,
   rel_id BIGINT UNSIGNED,
   name varchar(30) charset utf8,
   sysres varchar(60),
   description varchar(255) charset utf8,
   dl_type varchar(20),
   relevant boolean not null default false,

   index( project_id, rel_id )
);

create table project_releases
(
   rel_id SERIAL primary key,
   project_id varchar(20) not null,
   rel_name varchar(20) not null,
   changelog TEXT charset utf8,
   free_text TEXT charset utf8,

   index( project_id )
);



create table project_news
(
   news_id SERIAL primary key,
   project varchar(20) ,
   news_title varchar(60) charset utf8 not null,
   news_heading text charset utf8 not null,
   news_content text charset utf8 not null,

   news_poster varchar(15),
   news_posted_on datetime,
   index( project )
);

create table bugtraq
(
   bug_id SERIAL primary key,
   bug_filed_on datetime,
   bug_title varchar(60) character set utf8,
   bug_level set( 'critical', 'relevant', 'annoying', 'glitch', 'desiderata' ),
   bug_poster varchar(15),    /* User id that posted the bug */
   bug_assigned_to varchar(15),   /* User that should fix the bug */
   bug_status set( 'open', 'closed', 'resolved', 'suspended' ),
   bug_mark_duplicate BIGINT UNSIGNED, /* if not null, will point to another serial number in this table */
   bug_comment text charset utf8
);

create table bugtraq_comments
(
   bc_reference BIGINT UNSIGNED,
   bc_commentor varchar(15),  /* User that posted the comment */
   bc_timestamp datetime,
   bc_comment text charset utf8
);


