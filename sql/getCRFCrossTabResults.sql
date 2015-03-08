/****** Object:  StoredProcedure [dbo].[getCRFCrossTabResults]    Script Date: 03/05/2015 16:04:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		Ewan Mackie
-- Description:	Generates crosstabbing query result set for
-- the provided row/column, using look up tables contained in DB
-- =============================================
CREATE PROCEDURE [dbo].[getCRFCrossTabResults]
	-- Add the parameters for the stored procedure here
	@dataset nvarchar(30),
	@rowvariable nvarchar(30),
	@colvariable nvarchar(30),
	@where nvarchar(4000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	

    --Local variables
	DECLARE @sql nvarchar(4000),
			@colsql nvarchar(500),
			@columns nvarchar(2000),
			@columnnames nvarchar(3000),
			@descriptionRow nvarchar(50),
			@lookupRow nvarchar(50),			
			@lookupCol nvarchar(50)
	
	--Pull Metadata for Look-up tables from DB
	SELECT @descriptionRow = [Description], @lookupRow = LookupTable
	FROM Variable_Metadata
	WHERE Variable = @rowvariable
	
	SELECT @lookupCol = LookupTable
	FROM Variable_Metadata
	WHERE Variable = @colvariable	
	
	-- Create strings of fields from look-up tables.
	SET @colSQL = 
	"SELECT @columns = COALESCE(@columns + ',' + '[' + CAST(Code AS nvarchar) + ']', '[' + CAST(Code AS nvarchar) + ']'),
			@columnnames= COALESCE(@columnnames + ',' + '[' + CAST(Code AS nvarchar) + '] AS [' + Label + ']', '[' + CAST(Code AS nvarchar) + '] AS [' + Label + ']')
	FROM " + @lookupCol + " GROUP BY Code, Label"	
	
	EXEC sp_executesql @colSQL, N'@columns nvarchar(2000) output, @columnnames nvarchar(3000) output',
								@columns output, @columnnames output
	
	-- Build query	
	SET @sql = '
	SELECT [Label] AS [' + @descriptionRow + '], ' + @columnnames + '
	FROM
	(SELECT ' + @rowVariable + ',' + @colvariable + ', Frequency 
	FROM ' + @dataset + @where + ') a 
	JOIN ' + @lookupRow + ' lookup ON a.' + @rowvariable + '= lookup.Code	
	PIVOT
	(
	Sum(Frequency)
	FOR ' + @colvariable + '
	IN (' + @columns + ')
	)
	AS p ORDER BY [Code]'
	
	-- Run query
	EXEC(@sql)
	
END

GO


