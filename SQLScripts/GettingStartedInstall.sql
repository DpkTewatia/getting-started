USE [GettingStarted]
GO
/****** Object:  Schema [admin]    Script Date: 3/16/2023 8:32:37 AM ******/
CREATE SCHEMA [admin]
GO
/****** Object:  Schema [bad]    Script Date: 3/16/2023 8:32:37 AM ******/
CREATE SCHEMA [bad]
GO
/****** Object:  Schema [best]    Script Date: 3/16/2023 8:32:37 AM ******/
CREATE SCHEMA [best]
GO
/****** Object:  Schema [better]    Script Date: 3/16/2023 8:32:37 AM ******/
CREATE SCHEMA [better]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](64) NOT NULL,
	[LastName] [varchar](64) NOT NULL,
	[Email] [varchar](64) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Email]    Script Date: 3/16/2023 8:32:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer_Email] ON [dbo].[Customer]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [admin].[GenerateCustomers]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [admin].[GenerateCustomers]
AS
BEGIN
	
	SET NOCOUNT ON;

	TRUNCATE TABLE [dbo].[Customer]
	DECLARE @IDX int = 0;
	WHILE @IDX < 1000
	BEGIN
		BEGIN TRY
			INSERT INTO [dbo].[Customer]
			(
				[FirstName],
				[LastName],
				[Email]
			)
			VALUES
			(
				CONCAT('First_Name_', @IDX),
				CONCAT('Last_Name_', @IDX),
				CONCAT('Email_', @IDX, '@youhoo.new')
			)
		END TRY
		BEGIN CATCH
			PRINT @IDX;
		END CATCH;
		SET @IDX += 1
	END
END
GO
/****** Object:  StoredProcedure [bad].[CustomerById]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Selects customer for the given CustomerId, no parameter validation, no return values.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [bad].[CustomerById]
(
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [bad].[CustomerDelete]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Deletes customer for the given CustomerId, no parameter validation, no return values.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [bad].[CustomerDelete]
(
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [bad].[Customers]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers, no parameter validation, no default values, no return values.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [bad].[Customers]
(
	@PageSize int,

	@PageNumber int,
	
	@PageCount int out
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
	DECLARE
		@RowCount int,
		@PageOffset int;
		
	SET @PageNumber -= 1;
	
	SELECT @RowCount = COUNT(1) FROM [dbo].[Customer];
	
	SET @PageCount = @RowCount/@PageSize;
	
	IF (@PageSize * @PageCount) < @RowCount
	BEGIN
		SET @PageCount += 1;
	END;
	
	SET @PageOffset = (@PageSize * @PageNumber);

    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
	ORDER BY
		[Email]
	OFFSET
		@PageOffset ROWS FETCH NEXT @PageSize ROWS ONLY;

END;
GO
/****** Object:  StoredProcedure [bad].[CustomerSave]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts or updates the customer based on the value of the customer id, no parameter validation, no default values, no return values, no duplicate index handling
    --&Author=alan@sqlplus.net
--+SqlPlusRoutine
CREATE PROCEDURE [bad].[CustomerSave]
(
	--+InOut
	--+Comment=Set to 0 for an insert, otherwise provide the customer id
    @CustomerId int out,

    @LastName nvarchar(64),

    @FirstName nvarchar(64),

    @Email varchar(64)
)
AS
BEGIN
 
	SET NOCOUNT ON;

	IF @CustomerId = 0
	BEGIN
		
		INSERT INTO [dbo].[Customer]
		(
			[LastName],
			[FirstName],
			[Email]
		)
		VALUES
		(
			@LastName,
			@FirstName,
			@Email
		);
 
		SET @CustomerId = SCOPE_IDENTITY();

	END
	ELSE
	BEGIN

		UPDATE [dbo].[Customer] SET
			[LastName] = @LastName,
			[FirstName] = @FirstName,
			[Email] = @Email
		WHERE
			[CustomerId] = @CustomerId;

	END;
 
END;
GO
/****** Object:  StoredProcedure [best].[CustomerById]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Selects customer for the given CustomerId, parameter validation, return values.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [best].[CustomerById]
(
	--+Required
	@CustomerId int
)
AS
BEGIN

	SELECT
		[CustomerId], [FirstName], [LastName], [Email]
	FROM
		[dbo].[Customer]
	WHERE
		[CustomerId] = @CustomerId;

	IF @@ROWCOUNT = 0
	BEGIN
		--+Return=NotFound,No customer found for the given id
		RETURN 0;
	END;

	--+Return=Ok,Customer retrieved
	RETURN 1;

END;
GO
/****** Object:  StoredProcedure [best].[CustomerDelete]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@sqlplus.net
    --&Comment=Deletes customer for the given CustomerId, parameter validation, return values.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [best].[CustomerDelete]
(
	--+Required
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.Customer
    WHERE
        [CustomerId] = @CustomerId;

	IF @@ROWCOUNT = 0
	BEGIN
		--+Return=NotFound,No record was deleted
		RETURN 0;
	END
 
	--+Return=OK,Customer was deleted
	RETURN 1;

END;
GO
/****** Object:  StoredProcedure [best].[Customers]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers, parameter validation, default values, return values.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [best].[Customers]
(
	--+Required
	--+Range=10,50
	--+Default=10
	--+Comment=Supply a value in the range of 10-50
	@PageSize int,

	--+Required
	--+Default=1
	@PageNumber int,
	
	@PageCount int out

)
AS
BEGIN
 
    SET NOCOUNT ON;
 
	DECLARE
		@RowCount int,
		@PageOffset int;
		
	SET @PageNumber -= 1;
	
	SELECT @RowCount = COUNT(1) FROM [dbo].[Customer];
	
	SET @PageCount = @RowCount/@PageSize;
	
	IF (@PageSize * @PageCount) < @RowCount
	BEGIN
		SET @PageCount += 1;
	END;
	
	SET @PageOffset = (@PageSize * @PageNumber);

    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
	ORDER BY
		[Email]
	OFFSET
		@PageOffset ROWS FETCH NEXT @PageSize ROWS ONLY;

	IF @@ROWCOUNT = 0
	BEGIN
		--+Return=NoRecords
		RETURN 0;
	END;
	
	--+Return=Ok
	RETURN 1;

END;
GO
/****** Object:  StoredProcedure [best].[CustomerSave]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts or updates the customer based on the value of the customer id, parameter validation, default values, return values, duplicate index handling
    --&Author=alan@sqlplus.net
--+SqlPlusRoutine
CREATE PROCEDURE [best].[CustomerSave]
(
	--+Input
	--+Default=0
	--+Required
	--+Comment=Set to 0 for an insert, otherwise provide the customer id
    @CustomerId int out,

	--+MaxLength=64
	--+Required
	--+Display=Last Name,Description
    @LastName nvarchar(64),

	--+MaxLength=64
	--+Required
	--+Display=First Name,Description
    @FirstName nvarchar(64),

	--+MaxLength=64
	--+Required
	--+Email
    @Email varchar(64)
)
AS
BEGIN
 
	SET NOCOUNT ON;

    BEGIN TRY

		IF @CustomerId = 0
		BEGIN
			INSERT INTO [dbo].[Customer]
			(
				[LastName],
				[FirstName],
				[Email]
			)
			VALUES
			(
				@LastName,
				@FirstName,
				@Email
			);
 
			SET @CustomerId = SCOPE_IDENTITY();
 
			--+Return=Inserted,Customer record was inserted
			RETURN 1;

		END;

		UPDATE [dbo].[Customer] SET
			[LastName] = @LastName,
			[FirstName] = @FirstName,
			[Email] = @Email
		WHERE
			[CustomerId] = @CustomerId
 
		IF @@ROWCOUNT = 0
		BEGIN
			--+Return=NotFound,No customer found for the given id
			RETURN 2;
		END;
 
		--+Return=Modified,Customer record was modified
		RETURN 3;

	END TRY
	BEGIN CATCH
		
		IF ERROR_NUMBER() = 2601
		BEGIN
			--+Return=Duplicate,Cannot insert duplicate email
			RETURN 0;
		END;

		THROW;

	END CATCH
END;
GO
/****** Object:  StoredProcedure [better].[CustomerById]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Selects customer for the given CustomerId, parameter validation, no return values.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerById]
(
	--+Required
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [better].[CustomerDelete]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Deletes customer for the given CustomerId, parameter validation, no return values.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerDelete]
(
	--+Required
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [better].[Customers]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers, parameter validation, default values, no return values.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [better].[Customers]
(
	--+Required
	--+Range=10,50
	--+Default=10
	--+Comment=Supply a value in the range 10-50
	@PageSize int,

	--+Required
	--+Default=1
	@PageNumber int,
	
	@PageCount int out
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
	DECLARE
		@RowCount int,
		@PageOffset int;
		
	SET @PageNumber -= 1;
	
	SELECT @RowCount = COUNT(1) FROM [dbo].[Customer];
	
	SET @PageCount = @RowCount/@PageSize;
	
	IF (@PageSize * @PageCount) < @RowCount
	BEGIN
		SET @PageCount += 1;
	END;
	
	SET @PageOffset = (@PageSize * @PageNumber);

    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
	ORDER BY
		[Email]
	OFFSET
		@PageOffset ROWS FETCH NEXT @PageSize ROWS ONLY;

END;
GO
/****** Object:  StoredProcedure [better].[CustomerSave]    Script Date: 3/16/2023 8:32:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts or updates the customer based on the value of the customer id, parameter validation, default values, no return values, no duplicate index handling
    --&Author=Author
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerSave]
(
	--+Input
	--+Default=0
	--+Required
	--+Comment=Set to 0 for an insert, otherwise provide the customer id
    @CustomerId int out,

	--+MaxLength=64
	--+Required
    @LastName nvarchar(64),

	--+MaxLength=64
	--+Required
    @FirstName nvarchar(64),

	--+MaxLength=64
	--+Required
	--+Email
    @Email varchar(64)
)
AS
BEGIN
 
    SET NOCOUNT ON;

	IF @CustomerId = 0
	BEGIN
		
		INSERT INTO [dbo].[Customer]
		(
			[LastName],
			[FirstName],
			[Email]
		)
		VALUES
		(
			@LastName,
			@FirstName,
			@Email
		);
 
		SET @CustomerId = SCOPE_IDENTITY();

	END
	ELSE
	BEGIN

		UPDATE [dbo].[Customer] SET
			[LastName] = @LastName,
			[FirstName] = @FirstName,
			[Email] = @Email
		WHERE
			[CustomerId] = @CustomerId;

	END;

END;
GO
