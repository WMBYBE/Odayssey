USE [master]
GO
/****** Object:  User [##MS_PolicyEventProcessingLogin##]    Script Date: 4/19/2025 6:36:41 PM ******/
CREATE USER [##MS_PolicyEventProcessingLogin##] FOR LOGIN [##MS_PolicyEventProcessingLogin##] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [##MS_AgentSigningCertificate##]    Script Date: 4/19/2025 6:36:41 PM ******/
CREATE USER [##MS_AgentSigningCertificate##] FOR LOGIN [##MS_AgentSigningCertificate##]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](255) NOT NULL,
	[email] [varchar](255) NOT NULL,
	[xp] [int] NULL,
	[level] [int] NULL,
	[category_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[task_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[title] [varchar](255) NOT NULL,
	[description] [text] NULL,
	[xp_reward] [int] NULL,
	[is_custom] [bit] NULL,
	[task_type] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Assignments]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Assignments](
	[assignment_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[task_id] [int] NOT NULL,
	[due_date] [date] NULL,
	[task_frequency] [varchar](20) NULL,
	[total_progress] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[assignment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[user_task_assignments]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[user_task_assignments] AS
SELECT 
    ta.assignment_id,
    u.username,
    t.title,
    ta.due_date,
    ta.task_frequency,
    ta.total_progress
FROM task_assignments ta
JOIN users u ON ta.user_id = u.user_id
JOIN tasks t ON ta.task_id = t.task_id;
GO
/****** Object:  Table [dbo].[Task_Progress]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Progress](
	[progress_id] [int] IDENTITY(1,1) NOT NULL,
	[assignment_id] [int] NULL,
	[progress_amt] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[progress_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Categories]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Categories](
	[task_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[task_id] ASC,
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[user_task_progress_summary]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[user_task_progress_summary] AS
SELECT 
    u.username,
    t.title,
    c.name AS category,
    ta.due_date,
    ta.task_frequency,
    t.xp_reward,
    tp.progress_amt
FROM task_progress tp
JOIN task_assignments ta ON tp.assignment_id = ta.assignment_id
JOIN users u ON ta.user_id = u.user_id
JOIN tasks t ON ta.task_id = t.task_id
JOIN task_categories tc ON t.task_id = tc.task_id
JOIN categories c ON tc.category_id = c.category_id;
GO
/****** Object:  View [dbo].[user_leaderboard]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Safer approach (SQL Server 2016+)
CREATE   VIEW [dbo].[user_leaderboard] AS
SELECT 
    u.username,
    SUM(t.xp_reward) AS total_xp,
    COUNT(DISTINCT ta.task_id) AS tasks_completed
FROM dbo.Users u
JOIN dbo.Task_Assignments ta ON u.user_id = ta.user_id
JOIN dbo.Task_Progress tp ON ta.assignment_id = tp.assignment_id
JOIN dbo.Tasks t ON ta.task_id = t.task_id
WHERE tp.progress_amt = 100
GROUP BY u.username;
GO
/****** Object:  Table [dbo].[Categories_Master]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories_Master](
	[category_id] [int] NOT NULL,
	[name] [nvarchar](100) NULL,
	[category_type] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Character_Dialogs]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Character_Dialogs](
	[dialog_id] [int] IDENTITY(1,1) NOT NULL,
	[dialog_text] [nvarchar](255) NOT NULL,
	[personality_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[dialog_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Characters]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Characters](
	[character_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[species] [varchar](100) NOT NULL,
	[role] [varchar](255) NOT NULL,
	[description] [text] NULL,
	[color_scheme] [varchar](255) NULL,
	[Dialog] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[character_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personalities]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personalities](
	[personality_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[personality_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[task_assignments_temp]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[task_assignments_temp](
	[new_assignment_id] [bigint] NULL,
	[user_id] [int] NOT NULL,
	[task_id] [int] NOT NULL,
	[due_date] [date] NULL,
	[task_frequency] [varchar](20) NULL,
	[total_progress] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_Categories]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_customization]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_customization](
	[customization_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[character_id] [int] NOT NULL,
	[personality_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[customization_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Characters] ADD  CONSTRAINT [DF_Characters_Dialog]  DEFAULT ('Hi!') FOR [Dialog]
GO
ALTER TABLE [dbo].[Task_Assignments] ADD  DEFAULT ((0)) FOR [total_progress]
GO
ALTER TABLE [dbo].[Task_Progress] ADD  DEFAULT ((0)) FOR [progress_amt]
GO
ALTER TABLE [dbo].[Tasks] ADD  DEFAULT ((0)) FOR [xp_reward]
GO
ALTER TABLE [dbo].[Tasks] ADD  DEFAULT ((0)) FOR [is_custom]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [xp]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [level]
GO
ALTER TABLE [dbo].[Task_Assignments]  WITH CHECK ADD FOREIGN KEY([task_id])
REFERENCES [dbo].[Tasks] ([task_id])
GO
ALTER TABLE [dbo].[Task_Assignments]  WITH CHECK ADD FOREIGN KEY([task_id])
REFERENCES [dbo].[Tasks] ([task_id])
GO
ALTER TABLE [dbo].[Task_Assignments]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Task_Assignments]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Task_Categories]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories] ([category_id])
GO
ALTER TABLE [dbo].[Task_Categories]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories] ([category_id])
GO
ALTER TABLE [dbo].[Task_Categories]  WITH CHECK ADD FOREIGN KEY([task_id])
REFERENCES [dbo].[Tasks] ([task_id])
GO
ALTER TABLE [dbo].[Task_Categories]  WITH CHECK ADD FOREIGN KEY([task_id])
REFERENCES [dbo].[Tasks] ([task_id])
GO
ALTER TABLE [dbo].[Task_Progress]  WITH CHECK ADD FOREIGN KEY([assignment_id])
REFERENCES [dbo].[Task_Assignments] ([assignment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[User_customization]  WITH CHECK ADD  CONSTRAINT [fk_user_customization_character] FOREIGN KEY([character_id])
REFERENCES [dbo].[Characters] ([character_id])
GO
ALTER TABLE [dbo].[User_customization] CHECK CONSTRAINT [fk_user_customization_character]
GO
ALTER TABLE [dbo].[User_customization]  WITH CHECK ADD  CONSTRAINT [fk_user_customization_personality] FOREIGN KEY([personality_id])
REFERENCES [dbo].[Personalities] ([personality_id])
GO
ALTER TABLE [dbo].[User_customization] CHECK CONSTRAINT [fk_user_customization_personality]
GO
ALTER TABLE [dbo].[User_customization]  WITH CHECK ADD  CONSTRAINT [fk_user_customization_user] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[User_customization] CHECK CONSTRAINT [fk_user_customization_user]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserCategories] FOREIGN KEY([category_id])
REFERENCES [dbo].[User_Categories] ([category_id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UserCategories]
GO
ALTER TABLE [dbo].[Task_Assignments]  WITH CHECK ADD  CONSTRAINT [chk_task_frequency] CHECK  (([task_frequency]='One-time' OR [task_frequency]='Weekly' OR [task_frequency]='Daily'))
GO
ALTER TABLE [dbo].[Task_Assignments] CHECK CONSTRAINT [chk_task_frequency]
GO
ALTER TABLE [dbo].[Task_Assignments]  WITH CHECK ADD  CONSTRAINT [CK_Task_Frequency] CHECK  (([task_frequency]='One-time' OR [task_frequency]='Seasonal' OR [task_frequency]='Weekly' OR [task_frequency]='Daily'))
GO
ALTER TABLE [dbo].[Task_Assignments] CHECK CONSTRAINT [CK_Task_Frequency]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD CHECK  (([task_type]='Seasonal' OR [task_type]='Custom' OR [task_type]='Normal'))
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD CHECK  (([task_type]='Seasonal' OR [task_type]='Custom' OR [task_type]='Normal'))
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRandomDialogByPersonality]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRandomDialogByPersonality]
    @user_personality_id INT
AS
BEGIN
    SELECT TOP 1 dialog_text
    FROM dbo.Character_Dialogs
    WHERE personality_id = @user_personality_id
    ORDER BY NEWID();
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_RandomizeCharacterDialogs]    Script Date: 4/19/2025 6:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RandomizeCharacterDialogs]
AS
BEGIN
    UPDATE c
    SET Dialog = d.dialog_text
    FROM dbo.Characters c
    CROSS APPLY (
        SELECT TOP 1 dialog_text
        FROM dbo.Character_Dialogs
        ORDER BY NEWID()
    ) d;
END;
GO
