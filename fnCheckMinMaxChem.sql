-------------------------------------------
USE VistaEdiDB
GO


IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'fnCheckMinMaxChem' AND SPECIFIC_SCHEMA = 'dbo')
DROP FUNCTION [dbo].fnCheckMinMaxChem
GO
CREATE FUNCTION fnCheckMinMaxChem
(
	@Alloy [char](10) = NULL,
	@Diameter [char](6) = NULL,
	@chem [varchar](8) = NULL, 
	@chemName [varchar](5) = NULL 
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @tempChemicals varchar(150) = 'PASS' 

	DECLARE @checkChem numeric(8,5)
	
	DECLARE @lChem numeric(8,5)
	DECLARE @lchemName [varchar](8) = NULL 

	DECLARE @hChem numeric(8,5)
	DECLARE @hchemName [varchar](8) = NULL 

	SET @checkChem =CAST( @chem AS numeric(8,5)) 

	SET @lchemName = 'l' + @chemName
	SET @lChem = (SELECT TOP 1 CAST(@lchemName AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')

	SET @hchemName = 'l' + @chemName
	SET @hChem = (SELECT TOP 1 CAST(@hchemName AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
	
	if ( @checkChem<@lChem and @checkChem>@hChem)		
			SET @tempChemicals = 'PASS'
		else
			SET @tempChemicals = @chemName

    RETURN RTRIM(@tempChemicals)
END
GO
