﻿USE [VistaEdiDB]
GO
/****** Object:  StoredProcedure [dbo].[ChemistryInfoInsert_Proc]    Script Date: 2/16/2018 7:27:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE 
[dbo].[ChemistryInfoInsert_Proc]
	@Status  [char](1) = NULL,
	@ShipmentNumber [varchar](10) = NULL,
	@ShipmentDate [datetime] = NULL,
	@HeatNumber [varchar](10) = NULL,
	@Alloy [char](10) = NULL,
	@Diameter [char](6) = NULL,

	@Al [varchar](8) = NULL,
	@Sn[varchar](8) = NULL,

    @Si [varchar](8) = NULL,
    @Fe [varchar](8) = NULL,
    @Cu[varchar](8) = NULL,
    @Mn[varchar](8) = NULL,
    @Mg[varchar](8) = NULL,
    @Cr[varchar](8) = NULL,
    @Ni[varchar](8) = NULL,   
    @Zn[varchar](8) = NULL,   
    @Ti[varchar](8) = NULL,
    @V[varchar](8) = NULL,
    @Pb[varchar](8) = NULL,
	
    @B[varchar](8) = NULL,
    @Be[varchar](8) = NULL,
    @Na[varchar](8) = NULL,
    @Ca[varchar](8) = NULL,
    @Bi[varchar](8) = NULL,
    @Zr[varchar](8) = NULL,
    @Li[varchar](8) = NULL,
    @Ag [varchar](8) = NULL,

	@Sc [varchar](8) = NULL,
	@Sr [varchar](8) = NULL,
	@TiZr [varchar](8) = NULL
AS
BEGIN
	DECLARE @returnMessage  varchar(150) = 'PASS'
	DECLARE @tempChemicals  varchar(15) = ''
	DECLARE @UACCode varchar(10) = '0'
	DECLARE @Plant varchar(10) = '0'
	DECLARE @maxDetialID int
		
	-- Delete this - only for temporary testing purpose
	SET @returnMessage = 'PASS'
	
	IF EXISTS (SELECT * FROM [ChemDetail] WHERE [HeatNo] = @HeatNumber)
	BEGIN
		SET  @returnMessage = 'HEATNOEXISTS'
		SET @Status = '2'
	END
	ELSE
	BEGIN 		
		IF NOT EXISTS (SELECT * FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
		BEGIN			
			SET @returnMessage = 'Heat No. does not exist in bltorder'	
			SET @Status = '2'		
		END
		ELSE
		BEGIN	
				SET @UACCode = (SELECT top 1 Code FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
				SET @Plant = (SELECT top 1 Plant FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
				SET @maxDetialID = (SELECT MAX([DetailID]) FROM [ChemDetail] )+1

				SET  @returnMessage = ''


				--check for each Chemical in this list if its values are within the limits 
				-- the function fnCheckMinMaxChem - checks if the value is in limits

				--insert into #temptable (@Si , @Fe , @Cu, @Mn, @Mg, @Cr, @Ni, @Zn, @Ti, @V,
				--@Pb, @B, @Be, @Na, @Ca, @Bi, @Zr, @Li, @Ag, @Sc, @Sr, @TiZr )
				--e.g.
				--@chemName = 'Si'
				--@chemValue = @Si

				-- fnCheckMinMaxChem : checks if the sent value of chemical name is within the min/max value
				-- if the chemValue is within limits then it sends 'PASS'
				-- if it not within value then it send @chemName  
				--SET @tempChemicals = fnCheckMinMaxChem( @Alloy,@Diameter, @chemValue ,@chemName)	
									
				SET @tempChemicals = 'PASS'
				IF (RTRIM(@tempChemicals) != 'PASS')
				BEGIN 
					SET @Status = '2' 
					IF (@returnMessage = '')
						SET @returnMessage = @tempChemicals
					ELSE
						SET @returnMessage = @returnMessage + ', ' + @tempChemicals
				END
				ELSE
				BEGIN
					SET @Status = '1' 
				END
				--	if all the values are in limits (@returnMessage = 'PASS')	
				-- is status is 1
				-- or if the values are not in limits but status is 3 (user accepted the deviation)	
				--in above cases insert values in table : [ChemDetail] and [ChemInfo]

				IF (@returnMessage = 'PASS') AND ((@Status = '1') OR (@Status = '3'))
				BEGIN
					INSERT [dbo].[ChemDetail](
					[HeatNo], [UACCode], [Type], [DetailID], Si , Fe , Cu, Mn, Mg, Cr, Ni, Zn, Ti, V, Pb, B, Be, Na,
					Ca, Bi, Zr, Li, Ag, Sc, Sr, TiZr )
					VALUES (
					@HeatNumber, @UACCode, 'S', @maxDetialID, @Si , @Fe , @Cu, @Mn, @Mg, @Cr, @Ni, @Zn, @Ti, @V,
					@Pb, @B, @Be, @Na, @Ca, @Bi, @Zr, @Li, @Ag, @Sc, @Sr, @TiZr )
   	
				    --------------------------------------------------------------------------------------------------------

					DECLARE @RecId int

					SELECT @RecId = [RecId]
					FROM [dbo].[ChemDetail]
					WHERE @@ROWCOUNT > 0 AND [RecId] = scope_identity()

					INSERT INTO [ChemInfo] 
					([Supplier],[EntryDate], [HeatNo] , [UACCode],  [Alloy], [Plant], [Diameter], [Status])
					 VALUES
					 ('Vista', @ShipmentDate , @HeatNumber , @UACCode, @Alloy , @Plant, @Diameter , @Status )
    
					SELECT @RecId = [RecId]
					FROM [dbo].[ChemInfo]
					WHERE @@ROWCOUNT > 0 AND [RecId] = scope_identity()


				END
		END
	END
-- If the values are not within the min/max limits STATUS IS RETURNED AS '2'
--@returnMessage returns the list of Chemicals that are not in the limits

select @returnMessage, @Status

END
