﻿--+SqlPlusRoutine
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