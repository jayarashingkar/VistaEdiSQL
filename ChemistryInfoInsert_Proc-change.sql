USE [VistaEdiDB]
GO
/****** Object:  StoredProcedure [dbo].[ChemistryInfoInsert_Proc]    Script Date: 2/22/2018 12:01:40 PM ******/
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
		
	DECLARE @chemName [varchar](8)
	DECLARE @chemValue [varchar](8)				

	-- Delete this - only for temporary testing purpose
	SET @returnMessage = 'PASS'
	
	IF EXISTS (SELECT * FROM [ChemDetail] WHERE [HeatNo] = @HeatNumber)
	BEGIN
		SET  @returnMessage = 'HEATNOEXISTS'
		IF ( @Status != '3')
			   SET @Status = '2'
	END
		
	IF NOT EXISTS (SELECT * FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
	BEGIN			
			SET @returnMessage = 'Heat No. does not exist in bltorder'	
			IF ( @Status != '3')
			BEGIN
			   SET @Status = '2'	
			END
			SET @UACCode  = ''
			SET @Plant  = ''
				
	END
		--ELSE
	IF (@Status != '2')
	BEGIN	
			IF EXISTS (SELECT top 1 Code FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
			BEGIN
				SET @UACCode = (SELECT top 1 Code FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
				SET @Plant = (SELECT top 1 Plant FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
			END
				SET @maxDetialID = (SELECT MAX([DetailID]) FROM [ChemDetail] )+1

				SET  @returnMessage = ''

				--  checks if every chemical is within the min/max value from table chemMinMax01
				-- if it not within value then send the chemical name that is not in limit 
				
				--SET @tempChemicals = dbo.fnCheckMinMaxChem( @Alloy,@Diameter, @chemValue ,@chemName)	
				
			--CHECKING VALUES
			--start
			--Si

				DECLARE @checkSi numeric(8,5)
				SET @checkSi = CAST(@Si AS numeric(8,5))

				DECLARE @lSi numeric(8,5)
				SET @lSi = (SELECT TOP 1 CAST(lSi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hSi numeric(8,5)
				SET @hSi = (SELECT TOP 1 CAST(hSi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkSi<@lSi OR @checkSi>@hSi)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Si'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Si'
					END
				END
			--Fe

				DECLARE @checkFe numeric(8,5)
				SET @checkFe = CAST(@Fe AS numeric(8,5))

				DECLARE @lFe numeric(8,5)
				SET @lFe = (SELECT TOP 1 CAST(lFe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hFe numeric(8,5)
				SET @hFe = (SELECT TOP 1 CAST(hFe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkFe<@lFe OR @checkFe>@hFe)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Fe'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Fe'
					END
				END
			--end			
			--Cu

				DECLARE @checkCu numeric(8,5)
				SET @checkCu = CAST(@Cu AS numeric(8,5))

				DECLARE @lCu numeric(8,5)
				SET @lCu = (SELECT TOP 1 CAST(lCu AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hCu numeric(8,5)
				SET @hCu = (SELECT TOP 1 CAST(hCu AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkCu<@lCu OR @checkCu>@hCu)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Cu'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Cu'
					END
				END
			--end				
			--Mn

				DECLARE @checkMn numeric(8,5)
				SET @checkMn = CAST(@Mn AS numeric(8,5))

				DECLARE @lMn numeric(8,5)
				SET @lMn = (SELECT TOP 1 CAST(lMn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hMn numeric(8,5)
				SET @hMn = (SELECT TOP 1 CAST(hMn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkMn<@lMn OR @checkMn>@hMn)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Mn'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Mn'
					END
				END
			--end				
			--Mg

				DECLARE @checkMg numeric(8,5)
				SET @checkMg = CAST(@Mg AS numeric(8,5))

				DECLARE @lMg numeric(8,5)
				SET @lMg = (SELECT TOP 1 CAST(lMg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hMg numeric(8,5)
				SET @hMg = (SELECT TOP 1 CAST(hMg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkMg<@lMg OR @checkMg>@hMg)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Mg'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Mg'
					END
				END
			--end				
			--Cr

				DECLARE @checkCr numeric(8,5)
				SET @checkCr = CAST(@Cr AS numeric(8,5))

				DECLARE @lCr numeric(8,5)
				SET @lCr = (SELECT TOP 1 CAST(lCr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hCr numeric(8,5)
				SET @hCr = (SELECT TOP 1 CAST(hCr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkCr<@lCr OR @checkCr>@hCr)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Cr'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Cr'
					END
				END
			--end				
			--Ni

				DECLARE @checkNi numeric(8,5)
				SET @checkNi = CAST(@Ni AS numeric(8,5))

				DECLARE @lNi numeric(8,5)
				SET @lNi = (SELECT TOP 1 CAST(lNi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hNi numeric(8,5)
				SET @hNi = (SELECT TOP 1 CAST(hNi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkNi<@lNi OR @checkNi>@hNi)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Ni'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Ni'
					END
				END
			--end				
			--Zn

				DECLARE @checkZn numeric(8,5)
				SET @checkZn = CAST(@Zn AS numeric(8,5))

				DECLARE @lZn numeric(8,5)
				SET @lZn = (SELECT TOP 1 CAST(lZn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hZn numeric(8,5)
				SET @hZn = (SELECT TOP 1 CAST(hZn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkZn<@lZn OR @checkZn>@hZn)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Zn'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Zn'
					END
				END
			--end				
			--Ti

				DECLARE @checkTi numeric(8,5)
				SET @checkTi = CAST(@Ti AS numeric(8,5))

				DECLARE @lTi numeric(8,5)
				SET @lTi = (SELECT TOP 1 CAST(lTi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hTi numeric(8,5)
				SET @hTi = (SELECT TOP 1 CAST(hTi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkTi<@lTi OR @checkTi>@hTi)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Ti'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Ti'
					END
				END
			--end	
			--V

				DECLARE @checkV numeric(8,5)
				SET @checkV = CAST(@V AS numeric(8,5))

				DECLARE @lV numeric(8,5)
				SET @lV = (SELECT TOP 1 CAST(lV AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hV numeric(8,5)
				SET @hV = (SELECT TOP 1 CAST(hV AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkV<@lV OR @checkV>@hV)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'V'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'V'
					END
				END
			--end			
			--Pb

				DECLARE @checkPb numeric(8,5)
				SET @checkPb = CAST(@Pb AS numeric(8,5))

				DECLARE @lPb numeric(8,5)
				SET @lPb = (SELECT TOP 1 CAST(lPb AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hPb numeric(8,5)
				SET @hPb = (SELECT TOP 1 CAST(hPb AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkPb<@lPb OR @checkPb>@hPb)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Pb'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Pb'
					END
				END
			--end			
			--B

				DECLARE @checkB numeric(8,5)
				SET @checkB = CAST(@B AS numeric(8,5))

				DECLARE @lB numeric(8,5)
				SET @lB = (SELECT TOP 1 CAST(lB AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hB numeric(8,5)
				SET @hB = (SELECT TOP 1 CAST(hB AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkB<@lB OR @checkB>@hB)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'B'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'B'
					END
				END
			--end			
			--Be

				DECLARE @checkBe numeric(8,5)
				SET @checkBe = CAST(@Be AS numeric(8,5))

				DECLARE @lBe numeric(8,5)
				SET @lBe = (SELECT TOP 1 CAST(lBe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hBe numeric(8,5)
				SET @hBe = (SELECT TOP 1 CAST(hBe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkBe<@lBe OR @checkBe>@hBe)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Be'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Be'
					END
				END
			--end			
			--Na

				DECLARE @checkNa numeric(8,5)
				SET @checkNa = CAST(@Na AS numeric(8,5))

				DECLARE @lNa numeric(8,5)
				SET @lNa = (SELECT TOP 1 CAST(lNa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hNa numeric(8,5)
				SET @hNa = (SELECT TOP 1 CAST(hNa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkNa<@lNa OR @checkNa>@hNa)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Na'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Na'
					END
				END
			--end			
			--Ca

				DECLARE @checkCa numeric(8,5)
				SET @checkCa = CAST(@Ca AS numeric(8,5))

				DECLARE @lCa numeric(8,5)
				SET @lCa = (SELECT TOP 1 CAST(lCa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hCa numeric(8,5)
				SET @hCa = (SELECT TOP 1 CAST(hCa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkCa<@lCa OR @checkCa>@hCa)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Ca'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Ca'
					END
				END
			--end			
			--Bi

				DECLARE @checkBi numeric(8,5)
				SET @checkBi = CAST(@Bi AS numeric(8,5))

				DECLARE @lBi numeric(8,5)
				SET @lBi = (SELECT TOP 1 CAST(lBi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hBi numeric(8,5)
				SET @hBi = (SELECT TOP 1 CAST(hBi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkBi<@lBi OR @checkBi>@hBi)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Bi'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Bi'
					END
				END
			--end			
			--Zr

				DECLARE @checkZr numeric(8,5)
				SET @checkZr = CAST(@Zr AS numeric(8,5))

				DECLARE @lZr numeric(8,5)
				SET @lZr = (SELECT TOP 1 CAST(lZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hZr numeric(8,5)
				SET @hZr = (SELECT TOP 1 CAST(hZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkZr<@lZr OR @checkZr>@hZr)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Zr'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Zr'
					END
				END
			--end			
			--Li

				DECLARE @checkLi numeric(8,5)
				SET @checkLi = CAST(@Li AS numeric(8,5))

				DECLARE @lLi numeric(8,5)
				SET @lLi = (SELECT TOP 1 CAST(lLi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hLi numeric(8,5)
				SET @hLi = (SELECT TOP 1 CAST(hLi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkLi<@lLi OR @checkLi>@hLi)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Li'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Li'
					END
				END
			--end	
			--Ag

				DECLARE @checkAg numeric(8,5)
				SET @checkAg = CAST(@Ag AS numeric(8,5))

				DECLARE @lAg numeric(8,5)
				SET @lAg = (SELECT TOP 1 CAST(lAg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hAg numeric(8,5)
				SET @hAg = (SELECT TOP 1 CAST(hAg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkAg<@lAg OR @checkAg>@hAg)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Ag'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Ag'
					END
				END
			--end				
			--Sc

				DECLARE @checkSc numeric(8,5)
				SET @checkSc = CAST(@Sc AS numeric(8,5))

				DECLARE @lSc numeric(8,5)
				SET @lSc = (SELECT TOP 1 CAST(lSc AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hSc numeric(8,5)
				SET @hSc = (SELECT TOP 1 CAST(hSc AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkSc<@lSc OR @checkSc>@hSc)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Sc'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Sc'
					END
				END
			--end				
			--Sr

				DECLARE @checkSr numeric(8,5)
				SET @checkSr = CAST(@Sr AS numeric(8,5))

				DECLARE @lSr numeric(8,5)
				SET @lSr = (SELECT TOP 1 CAST(lSr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hSr numeric(8,5)
				SET @hSr = (SELECT TOP 1 CAST(hSr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkSr<@lSr OR @checkSr>@hSr)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'Sr'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'Sr'
					END
				END
			--end				
			--TiZr

				DECLARE @checkTiZr numeric(8,5)
				SET @checkTiZr = CAST(@TiZr AS numeric(8,5))

				DECLARE @lTiZr numeric(8,5)
				SET @lTiZr = (SELECT TOP 1 CAST(lTiZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				DECLARE @hTiZr numeric(8,5)
				SET @hTiZr = (SELECT TOP 1 CAST(hTiZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				
				IF ( @checkTiZr<@lTiZr OR @checkTiZr>@hTiZr)	
				BEGIN					
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
							SET @returnMessage = 'TiZr'
						ELSE
							SET @returnMessage = @returnMessage + ', ' + 'TiZr'
					END
				END
			--end				
			
				IF ((@Status = '1') OR (@Status = '3'))
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
		--END
	END
-- If the values are not within the min/max limits STATUS IS RETURNED AS '2'
--@returnMessage returns the list of Chemicals that are not in the limits


select @returnMessage
--TESTING tempChemicals
--select @tempChemicals, @Status
--select @returnMessage,@hSi

END
