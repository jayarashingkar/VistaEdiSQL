USE [VistaEdiDB]
GO
/****** Object:  StoredProcedure [dbo].[ChemistryInfoInsert_Proc]    Script Date: 2/26/2018 11:07:36 AM ******/
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
	DECLARE @returnHeatNo  varchar(150) = ''

	DECLARE @tempChemicals  varchar(15) = ''
	DECLARE @UACCode varchar(10) = '0'
	DECLARE @Plant varchar(10) = '0'
	DECLARE @maxDetialID int
		
	DECLARE @chemName [varchar](8)
	DECLARE @chemValue [varchar](8)				
	
	SET @returnMessage = 'PASS'
	
	IF EXISTS (SELECT * FROM [ChemDetail] WHERE [HeatNo] = @HeatNumber)
	BEGIN		
		IF ( @Status != '3')
		BEGIN
			   SET @Status = '2'
			   SET @returnMessage = 'RECORD WITH HEAT NO ALREADY EXISTS'
			   SET @returnHeatNo = @HeatNumber
		END
	END
		
	IF NOT EXISTS (SELECT * FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
	BEGIN	
			IF ( @Status != '3')
			BEGIN
			   SET @Status = '2'	
			   SET @returnMessage = 'Heat No. does not exist in bltorder'	
			   SET @returnHeatNo = @HeatNumber
			END
			SET @UACCode  = ''
			SET @Plant  = ''
				
	END
		--ELSE
	IF (@Status != '2')
	BEGIN	
			IF EXISTS (SELECT * FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
			BEGIN
				SET @UACCode = (SELECT top 1 Code FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
				SET @Plant = (SELECT top 1 Plant FROM [dbo].[bltorder] WHERE [HEAT_LOT] = @HeatNumber)
			END
			
			SET @maxDetialID = (SELECT MAX([DetailID]) FROM [ChemDetail] )+1
			IF (@maxDetialID IS NULL)
				SET @maxDetialID = 1

			SET  @returnMessage = ''
			SET @returnHeatNo = ''
			--  checks if every chemical is within the min/max value from table chemMinMax01
			-- if it not within value then send the chemical name that is not in limit 
				
			--SET @tempChemicals = dbo.fnCheckMinMaxChem( @Alloy,@Diameter, @chemValue ,@chemName)	
				
			--CHECKING VALUES
			--start
			--iF CONDITION TO MARK AS #REGION			
		IF (@Si = @Si)
			BEGIN
				DECLARE @checkSi numeric(8,5)
				IF (@Si IS NOT NULL)
					SET @checkSi = CAST(@Si AS numeric(8,5))
				ELSE
					SET @checkSi = 0.0

				DECLARE @lSi numeric(8,5)
				DECLARE @hSi numeric(8,5)

				DECLARE @charlSi [varchar](8)
				DECLARE @charhSi [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlSi = (SELECT TOP 1 lSi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhSi = (SELECT TOP 1 hSi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlSi IS NULL) OR (RTRIM(@charlSi) = '') OR (@Status != '3'))
						SET @lSi = 0.0
					ELSE
						SET @lSi = (SELECT TOP 1 CAST(lSi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhSi IS NULL) OR (RTRIM(@charhSi) = '') OR (@Status != '3'))
						SET @hSi = 100.0
					ELSE
						SET @hSi = (SELECT TOP 1 CAST(hSi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
												
						IF (@returnMessage = '')
						BEGIN
								SET @returnMessage = 'Si'								
						END
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Si'
					END
					ELSE
					BEGIN
						SET @lSi = 0.0
						SET @hSi = 100.0
					END
				END	

				
				IF ( @checkSi<=@lSi OR @checkSi>@hSi)	
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
			END
			--Fe
		IF (@Fe = @Fe)
			BEGIN
				DECLARE @checkFe numeric(8,5)
				IF (@Fe IS NOT NULL)
					SET @checkFe = CAST(@Fe AS numeric(8,5))
				ELSE
					SET @checkFe = 0.0

				DECLARE @lFe numeric(8,5)
				DECLARE @hFe numeric(8,5)

				DECLARE @charlFe [varchar](8)
				DECLARE @charhFe [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlFe = (SELECT TOP 1 lFe FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhFe = (SELECT TOP 1 hFe FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlFe IS NULL) OR (RTRIM(@charlFe) = '') OR (@Status != '3'))
						SET @lFe = 0.0
					ELSE
						SET @lFe = (SELECT TOP 1 CAST(lFe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhFe IS NULL) OR (RTRIM(@charhFe) = '') OR (@Status != '3'))
						SET @hFe = 100.0
					ELSE
						SET @hFe = (SELECT TOP 1 CAST(hFe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Fe'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Fe'
					END
					ELSE
					BEGIN
						SET @lFe = 0.0
						SET @hFe = 100.0
					END
				END	

				
				IF ( @checkFe<=@lFe OR @checkFe>@hFe)	
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
			END
			--end			
			--Cu

		IF (@Cu = @Cu)
			BEGIN
				DECLARE @checkCu numeric(8,5)
				IF (@Cu IS NOT NULL)
					SET @checkCu = CAST(@Cu AS numeric(8,5))
				ELSE
					SET @checkCu = 0.0

				DECLARE @lCu numeric(8,5)
				DECLARE @hCu numeric(8,5)

				DECLARE @charlCu [varchar](8)
				DECLARE @charhCu [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlCu = (SELECT TOP 1 lCu FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhCu = (SELECT TOP 1 hCu FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlCu IS NULL) OR (RTRIM(@charlCu) = '') OR (@Status != '3'))
						SET @lCu = 0.0
					ELSE
						SET @lCu = (SELECT TOP 1 CAST(lCu AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhCu IS NULL) OR (RTRIM(@charhCu) = '') OR (@Status != '3'))
						SET @hCu = 100.0
					ELSE
						SET @hCu = (SELECT TOP 1 CAST(hCu AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Cu'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Cu'
					END
					ELSE
					BEGIN
						SET @lCu = 0.0
						SET @hCu = 100.0
					END
				END	

				
				IF ( @checkCu<=@lCu OR @checkCu>@hCu)	
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
			END
			--end				
			--Mn

		IF (@Mn = @Mn)
			BEGIN
				DECLARE @checkMn numeric(8,5)
				IF (@Mn IS NOT NULL)
					SET @checkMn = CAST(@Mn AS numeric(8,5))
				ELSE
					SET @checkMn = 0.0

				DECLARE @lMn numeric(8,5)
				DECLARE @hMn numeric(8,5)

				DECLARE @charlMn [varchar](8)
				DECLARE @charhMn [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlMn = (SELECT TOP 1 lMn FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhMn = (SELECT TOP 1 hMn FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlMn IS NULL) OR (RTRIM(@charlMn) = '') OR (@Status != '3'))
						SET @lMn = 0.0
					ELSE
						SET @lMn = (SELECT TOP 1 CAST(lMn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhMn IS NULL) OR (RTRIM(@charhMn) = '') OR (@Status != '3'))
						SET @hMn = 100.0
					ELSE
						SET @hMn = (SELECT TOP 1 CAST(hMn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Mn'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Mn'
					END
					ELSE
					BEGIN
						SET @lMn = 0.0
						SET @hMn = 100.0
					END
				END	

				
				IF ( @checkMn<=@lMn OR @checkMn>@hMn)	
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
			END
			--end				
			--Mg

		IF (@Mg = @Mg)
			BEGIN
				DECLARE @checkMg numeric(8,5)
				IF (@Mg IS NOT NULL)
					SET @checkMg = CAST(@Mg AS numeric(8,5))
				ELSE
					SET @checkMg = 0.0

				DECLARE @lMg numeric(8,5)
				DECLARE @hMg numeric(8,5)

				DECLARE @charlMg [varchar](8)
				DECLARE @charhMg [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlMg = (SELECT TOP 1 lMg FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhMg = (SELECT TOP 1 hMg FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlMg IS NULL) OR (RTRIM(@charlMg) = '') OR (@Status != '3'))
						SET @lMg = 0.0
					ELSE
						SET @lMg = (SELECT TOP 1 CAST(lMg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhMg IS NULL) OR (RTRIM(@charhMg) = '') OR (@Status != '3'))
						SET @hMg = 100.0
					ELSE
						SET @hMg = (SELECT TOP 1 CAST(hMg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Mg'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Mg'
					END
					ELSE
					BEGIN
						SET @lMg = 0.0
						SET @hMg = 100.0
					END
				END	

				
				IF ( @checkMg<=@lMg OR @checkMg>@hMg)	
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
			END
			--end				
			--Cr
		IF (@Cr = @Cr)
			BEGIN
				DECLARE @checkCr numeric(8,5)
				IF (@Cr IS NOT NULL)
					SET @checkCr = CAST(@Cr AS numeric(8,5))
				ELSE
					SET @checkCr = 0.0

				DECLARE @lCr numeric(8,5)
				DECLARE @hCr numeric(8,5)

				DECLARE @charlCr [varchar](8)
				DECLARE @charhCr [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlCr = (SELECT TOP 1 lCr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhCr = (SELECT TOP 1 hCr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlCr IS NULL) OR (RTRIM(@charlCr) = '') OR (@Status != '3'))
						SET @lCr = 0.0
					ELSE
						SET @lCr = (SELECT TOP 1 CAST(lCr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhCr IS NULL) OR (RTRIM(@charhCr) = '') OR (@Status != '3'))
						SET @hCr = 100.0
					ELSE
						SET @hCr = (SELECT TOP 1 CAST(hCr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Cr'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Cr'
					END
					ELSE
					BEGIN
						SET @lCr = 0.0
						SET @hCr = 100.0
					END
				END	

				
				IF ( @checkCr<=@lCr OR @checkCr>@hCr)	
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
			END
				
			--end				
			--Ni

		IF (@Ni = @Ni)
			BEGIN
				DECLARE @checkNi numeric(8,5)
				IF (@Ni IS NOT NULL)
					SET @checkNi = CAST(@Ni AS numeric(8,5))
				ELSE
					SET @checkNi = 0.0

				DECLARE @lNi numeric(8,5)
				DECLARE @hNi numeric(8,5)

				DECLARE @charlNi [varchar](8)
				DECLARE @charhNi [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlNi = (SELECT TOP 1 lNi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhNi = (SELECT TOP 1 hNi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlNi IS NULL) OR (RTRIM(@charlNi) = '') OR (@Status != '3'))
						SET @lNi = 0.0
					ELSE
						SET @lNi = (SELECT TOP 1 CAST(lNi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhNi IS NULL) OR (RTRIM(@charhNi) = '') OR (@Status != '3'))
						SET @hNi = 100.0
					ELSE
						SET @hNi = (SELECT TOP 1 CAST(hNi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Ni'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Ni'
					END
					ELSE
					BEGIN
						SET @lNi = 0.0
						SET @hNi = 100.0
					END
				END	

				
				IF ( @checkNi<=@lNi OR @checkNi>@hNi)	
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
			END
			--end				
			--Zn

		IF (@Zn = @Zn)
			BEGIN
				DECLARE @checkZn numeric(8,5)
				IF (@Zn IS NOT NULL)
					SET @checkZn = CAST(@Zn AS numeric(8,5))
				ELSE
					SET @checkZn = 0.0

				DECLARE @lZn numeric(8,5)
				DECLARE @hZn numeric(8,5)

				DECLARE @charlZn [varchar](8)
				DECLARE @charhZn [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlZn = (SELECT TOP 1 lZn FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhZn = (SELECT TOP 1 hZn FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlZn IS NULL) OR (RTRIM(@charlZn) = '') OR (@Status != '3'))
						SET @lZn = 0.0
					ELSE
						SET @lZn = (SELECT TOP 1 CAST(lZn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhZn IS NULL) OR (RTRIM(@charhZn) = '') OR (@Status != '3'))
						SET @hZn = 100.0
					ELSE
						SET @hZn = (SELECT TOP 1 CAST(hZn AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Zn'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Zn'
					END
					ELSE
					BEGIN
						SET @lZn = 0.0
						SET @hZn = 100.0
					END
				END	

				
				IF ( @checkZn<=@lZn OR @checkZn>@hZn)	
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
			END
				
			--end				
			--Ti

		IF (@Ti = @Ti)
			BEGIN
				DECLARE @checkTi numeric(8,5)
				IF (@Ti IS NOT NULL)
					SET @checkTi = CAST(@Ti AS numeric(8,5))
				ELSE
					SET @checkTi = 0.0

				DECLARE @lTi numeric(8,5)
				DECLARE @hTi numeric(8,5)

				DECLARE @charlTi [varchar](8)
				DECLARE @charhTi [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlTi = (SELECT TOP 1 lTi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhTi = (SELECT TOP 1 hTi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlTi IS NULL) OR (RTRIM(@charlTi) = '') OR (@Status != '3'))
						SET @lTi = 0.0
					ELSE
						SET @lTi = (SELECT TOP 1 CAST(lTi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhTi IS NULL) OR (RTRIM(@charhTi) = '') OR (@Status != '3'))
						SET @hTi = 100.0
					ELSE
						SET @hTi = (SELECT TOP 1 CAST(hTi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Ti'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Ti'
					END
					ELSE
					BEGIN
						SET @lTi = 0.0
						SET @hTi = 100.0
					END
				END	

				
				IF ( @checkTi<=@lTi OR @checkTi>@hTi)	
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
			END
			--end	
			--V

		IF (@V = @V)
			BEGIN
				DECLARE @checkV numeric(8,5)
				IF (@V IS NOT NULL)
					SET @checkV = CAST(@V AS numeric(8,5))
				ELSE
					SET @checkV = 0.0

				DECLARE @lV numeric(8,5)
				DECLARE @hV numeric(8,5)

				DECLARE @charlV [varchar](8)
				DECLARE @charhV [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlV = (SELECT TOP 1 lV FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhV = (SELECT TOP 1 hV FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlV IS NULL) OR (RTRIM(@charlV) = '') OR (@Status != '3'))
						SET @lV = 0.0
					ELSE
						SET @lV = (SELECT TOP 1 CAST(lV AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhV IS NULL) OR (RTRIM(@charhV) = '') OR (@Status != '3'))
						SET @hV = 100.0
					ELSE
						SET @hV = (SELECT TOP 1 CAST(hV AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'V'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'V'
					END
					ELSE
					BEGIN
						SET @lV = 0.0
						SET @hV = 100.0
					END
				END	

				
				IF ( @checkV<=@lV OR @checkV>@hV)	
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
			END
			--end			
			--Pb
			IF (@Pb = @Pb)
			BEGIN
				DECLARE @checkPb numeric(8,5)
				IF (@Pb IS NOT NULL)
					SET @checkPb = CAST(@Pb AS numeric(8,5))
				ELSE
					SET @checkPb = 0.0

				DECLARE @lPb numeric(8,5)
				DECLARE @hPb numeric(8,5)

				DECLARE @charlPb [varchar](8)
				DECLARE @charhPb [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlPb = (SELECT TOP 1 lPb FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhPb = (SELECT TOP 1 hPb FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlPb IS NULL) OR (RTRIM(@charlPb) = '') OR (@Status != '3'))
						SET @lPb = 0.0
					ELSE
						SET @lPb = (SELECT TOP 1 CAST(lPb AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhPb IS NULL) OR (RTRIM(@charhPb) = '') OR (@Status != '3'))
						SET @hPb = 100.0
					ELSE
						SET @hPb = (SELECT TOP 1 CAST(hPb AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Pb'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Pb'
					END
					ELSE
					BEGIN
						SET @lPb = 0.0
						SET @hPb = 100.0
					END
				END	

				
				IF ( @checkPb<=@lPb OR @checkPb>@hPb)	
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
			END
			--end			
			--B
		IF (@B = @B)
			BEGIN
				DECLARE @checkB numeric(8,5)
				IF (@B IS NOT NULL)
					SET @checkB = CAST(@B AS numeric(8,5))
				ELSE
					SET @checkB = 0.0

				DECLARE @lB numeric(8,5)
				DECLARE @hB numeric(8,5)

				DECLARE @charlB [varchar](8)
				DECLARE @charhB [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlB = (SELECT TOP 1 lB FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhB = (SELECT TOP 1 hB FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlB IS NULL) OR (RTRIM(@charlB) = '') OR (@Status != '3'))
						SET @lB = 0.0
					ELSE
						SET @lB = (SELECT TOP 1 CAST(lB AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhB IS NULL) OR (RTRIM(@charhB) = '') OR (@Status != '3'))
						SET @hB = 100.0
					ELSE
						SET @hB = (SELECT TOP 1 CAST(hB AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'B'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'B'
					END
					ELSE
					BEGIN
						SET @lB = 0.0
						SET @hB = 100.0
					END
				END	

				
				IF ( @checkB<=@lB OR @checkB>@hB)	
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
			END
			--end			
			--Be
		IF (@Be = @Be)
			BEGIN
				DECLARE @checkBe numeric(8,5)
				IF (@Be IS NOT NULL)
					SET @checkBe = CAST(@Be AS numeric(8,5))
				ELSE
					SET @checkBe = 0.0

				DECLARE @lBe numeric(8,5)
				DECLARE @hBe numeric(8,5)

				DECLARE @charlBe [varchar](8)
				DECLARE @charhBe [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlBe = (SELECT TOP 1 lBe FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhBe = (SELECT TOP 1 hBe FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlBe IS NULL) OR (RTRIM(@charlBe) = '') OR (@Status != '3'))
						SET @lBe = 0.0
					ELSE
						SET @lBe = (SELECT TOP 1 CAST(lBe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhBe IS NULL) OR (RTRIM(@charhBe) = '') OR (@Status != '3'))
						SET @hBe = 100.0
					ELSE
						SET @hBe = (SELECT TOP 1 CAST(hBe AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Be'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Be'
					END
					ELSE
					BEGIN
						SET @lBe = 0.0
						SET @hBe = 100.0
					END
				END	

				
				IF ( @checkBe<=@lBe OR @checkBe>@hBe)	
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
			END			--end			
			--Na

		IF (@Na = @Na)
			BEGIN
				DECLARE @checkNa numeric(8,5)
				IF (@Na IS NOT NULL)
					SET @checkNa = CAST(@Na AS numeric(8,5))
				ELSE
					SET @checkNa = 0.0

				DECLARE @lNa numeric(8,5)
				DECLARE @hNa numeric(8,5)

				DECLARE @charlNa [varchar](8)
				DECLARE @charhNa [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlNa = (SELECT TOP 1 lNa FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhNa = (SELECT TOP 1 hNa FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlNa IS NULL) OR (RTRIM(@charlNa) = '') OR (@Status != '3'))
						SET @lNa = 0.0
					ELSE
						SET @lNa = (SELECT TOP 1 CAST(lNa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhNa IS NULL) OR (RTRIM(@charhNa) = '') OR (@Status != '3'))
						SET @hNa = 100.0
					ELSE
						SET @hNa = (SELECT TOP 1 CAST(hNa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Na'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Na'
					END
					ELSE
					BEGIN
						SET @lNa = 0.0
						SET @hNa = 100.0
					END
				END	

				
				IF ( @checkNa<=@lNa OR @checkNa>@hNa)	
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
			END
			--end			
			--Ca

		IF (@Ca = @Ca)
			BEGIN
				DECLARE @checkCa numeric(8,5)
				IF (@Ca IS NOT NULL)
					SET @checkCa = CAST(@Ca AS numeric(8,5))
				ELSE
					SET @checkCa = 0.0

				DECLARE @lCa numeric(8,5)
				DECLARE @hCa numeric(8,5)

				DECLARE @charlCa [varchar](8)
				DECLARE @charhCa [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlCa = (SELECT TOP 1 lCa FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhCa = (SELECT TOP 1 hCa FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlCa IS NULL) OR (RTRIM(@charlCa) = '') OR (@Status != '3'))
						SET @lCa = 0.0
					ELSE
						SET @lCa = (SELECT TOP 1 CAST(lCa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhCa IS NULL) OR (RTRIM(@charhCa) = '') OR (@Status != '3'))
						SET @hCa = 100.0
					ELSE
						SET @hCa = (SELECT TOP 1 CAST(hCa AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Ca'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Ca'
					END
					ELSE
					BEGIN
						SET @lCa = 0.0
						SET @hCa = 100.0
					END
				END	

				
				IF ( @checkCa<=@lCa OR @checkCa>@hCa)	
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
			END
			--end			
			--Bi

		IF (@Bi = @Bi)
			BEGIN
				DECLARE @checkBi numeric(8,5)
				IF (@Bi IS NOT NULL)
					SET @checkBi = CAST(@Bi AS numeric(8,5))
				ELSE
					SET @checkBi = 0.0

				DECLARE @lBi numeric(8,5)
				DECLARE @hBi numeric(8,5)

				DECLARE @charlBi [varchar](8)
				DECLARE @charhBi [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlBi = (SELECT TOP 1 lBi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhBi = (SELECT TOP 1 hBi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlBi IS NULL) OR (RTRIM(@charlBi) = '') OR (@Status != '3'))
						SET @lBi = 0.0
					ELSE
						SET @lBi = (SELECT TOP 1 CAST(lBi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhBi IS NULL) OR (RTRIM(@charhBi) = '') OR (@Status != '3'))
						SET @hBi = 100.0
					ELSE
						SET @hBi = (SELECT TOP 1 CAST(hBi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Bi'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Bi'
					END
					ELSE
					BEGIN
						SET @lBi = 0.0
						SET @hBi = 100.0
					END
				END	

				
				IF ( @checkBi<=@lBi OR @checkBi>@hBi)	
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
			END			--end			
			--Zr

		IF (@Zr = @Zr)
			BEGIN
				DECLARE @checkZr numeric(8,5)
				IF (@Zr IS NOT NULL)
					SET @checkZr = CAST(@Zr AS numeric(8,5))
				ELSE
					SET @checkZr = 0.0

				DECLARE @lZr numeric(8,5)
				DECLARE @hZr numeric(8,5)

				DECLARE @charlZr [varchar](8)
				DECLARE @charhZr [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlZr = (SELECT TOP 1 lZr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhZr = (SELECT TOP 1 hZr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlZr IS NULL) OR (RTRIM(@charlZr) = '') OR (@Status != '3'))
						SET @lZr = 0.0
					ELSE
						SET @lZr = (SELECT TOP 1 CAST(lZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhZr IS NULL) OR (RTRIM(@charhZr) = '') OR (@Status != '3'))
						SET @hZr = 100.0
					ELSE
						SET @hZr = (SELECT TOP 1 CAST(hZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Zr'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Zr'
					END
					ELSE
					BEGIN
						SET @lZr = 0.0
						SET @hZr = 100.0
					END
				END	

				
				IF ( @checkZr<=@lZr OR @checkZr>@hZr)	
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
			END			--end			
			--Li

		IF (@Li = @Li)
			BEGIN
				DECLARE @checkLi numeric(8,5)
				IF (@Li IS NOT NULL)
					SET @checkLi = CAST(@Li AS numeric(8,5))
				ELSE
					SET @checkLi = 0.0

				DECLARE @lLi numeric(8,5)
				DECLARE @hLi numeric(8,5)

				DECLARE @charlLi [varchar](8)
				DECLARE @charhLi [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlLi = (SELECT TOP 1 lLi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhLi = (SELECT TOP 1 hLi FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlLi IS NULL) OR (RTRIM(@charlLi) = '') OR (@Status != '3'))
						SET @lLi = 0.0
					ELSE
						SET @lLi = (SELECT TOP 1 CAST(lLi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhLi IS NULL) OR (RTRIM(@charhLi) = '') OR (@Status != '3'))
						SET @hLi = 100.0
					ELSE
						SET @hLi = (SELECT TOP 1 CAST(hLi AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Li'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Li'
					END
					ELSE
					BEGIN
						SET @lLi = 0.0
						SET @hLi = 100.0
					END
				END	

				
				IF ( @checkLi<=@lLi OR @checkLi>@hLi)	
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
			END			--end	
			--Ag

		IF (@Ag = @Ag)
			BEGIN
				DECLARE @checkAg numeric(8,5)
				IF (@Ag IS NOT NULL)
					SET @checkAg = CAST(@Ag AS numeric(8,5))
				ELSE
					SET @checkAg = 0.0

				DECLARE @lAg numeric(8,5)
				DECLARE @hAg numeric(8,5)

				DECLARE @charlAg [varchar](8)
				DECLARE @charhAg [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlAg = (SELECT TOP 1 lAg FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhAg = (SELECT TOP 1 hAg FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlAg IS NULL) OR (RTRIM(@charlAg) = '') OR (@Status != '3'))
						SET @lAg = 0.0
					ELSE
						SET @lAg = (SELECT TOP 1 CAST(lAg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhAg IS NULL) OR (RTRIM(@charhAg) = '') OR (@Status != '3'))
						SET @hAg = 100.0
					ELSE
						SET @hAg = (SELECT TOP 1 CAST(hAg AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Ag'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Ag'
					END
					ELSE
					BEGIN
						SET @lAg = 0.0
						SET @hAg = 100.0
					END
				END	

				
				IF ( @checkAg<=@lAg OR @checkAg>@hAg)	
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
			END			--end				
			--Sc

		IF (@Sc = @Sc)
			BEGIN
				DECLARE @checkSc numeric(8,5)
				IF (@Sc IS NOT NULL)
					SET @checkSc = CAST(@Sc AS numeric(8,5))
				ELSE
					SET @checkSc = 0.0

				DECLARE @lSc numeric(8,5)
				DECLARE @hSc numeric(8,5)

				DECLARE @charlSc [varchar](8)
				DECLARE @charhSc [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlSc = (SELECT TOP 1 lSc FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhSc = (SELECT TOP 1 hSc FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlSc IS NULL) OR (RTRIM(@charlSc) = '') OR (@Status != '3'))
						SET @lSc = 0.0
					ELSE
						SET @lSc = (SELECT TOP 1 CAST(lSc AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhSc IS NULL) OR (RTRIM(@charhSc) = '') OR (@Status != '3'))
						SET @hSc = 100.0
					ELSE
						SET @hSc = (SELECT TOP 1 CAST(hSc AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Sc'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Sc'
					END
					ELSE
					BEGIN
						SET @lSc = 0.0
						SET @hSc = 100.0
					END
				END	

				
				IF ( @checkSc<=@lSc OR @checkSc>@hSc)	
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
			END
			
						--Sr

		IF (@Sr = @Sr)
			BEGIN
				DECLARE @checkSr numeric(8,5)
				IF (@Sr IS NOT NULL)
					SET @checkSr = CAST(@Sr AS numeric(8,5))
				ELSE
					SET @checkSr = 0.0

				DECLARE @lSr numeric(8,5)
				DECLARE @hSr numeric(8,5)

				DECLARE @charlSr [varchar](8)
				DECLARE @charhSr [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlSr = (SELECT TOP 1 lSr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhSr = (SELECT TOP 1 hSr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlSr IS NULL) OR (RTRIM(@charlSr) = '') OR (@Status != '3'))
						SET @lSr = 0.0
					ELSE
						SET @lSr = (SELECT TOP 1 CAST(lSr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhSr IS NULL) OR (RTRIM(@charhSr) = '') OR (@Status != '3'))
						SET @hSr = 100.0
					ELSE
						SET @hSr = (SELECT TOP 1 CAST(hSr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'Sr'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'Sr'
					END
					ELSE
					BEGIN
						SET @lSr = 0.0
						SET @hSr = 100.0
					END
				END	

				
				IF ( @checkSr<=@lSr OR @checkSr>@hSr)	
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
			END
						--end				
			--TiZr

		IF (@TiZr = @TiZr)
			BEGIN
				DECLARE @checkTiZr numeric(8,5)
				IF (@TiZr IS NOT NULL)
					SET @checkTiZr = CAST(@TiZr AS numeric(8,5))
				ELSE
					SET @checkTiZr = 0.0

				DECLARE @lTiZr numeric(8,5)
				DECLARE @hTiZr numeric(8,5)

				DECLARE @charlTiZr [varchar](8)
				DECLARE @charhTiZr [varchar](8)

				IF EXISTS (SELECT * FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				BEGIN
					SET @charlTiZr = (SELECT TOP 1 lTiZr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									
					SET @charhTiZr = (SELECT TOP 1 hTiZr FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
					IF ((@charlTiZr IS NULL) OR (RTRIM(@charlTiZr) = '') OR (@Status != '3'))
						SET @lTiZr = 0.0
					ELSE
						SET @lTiZr = (SELECT TOP 1 CAST(lTiZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')									

					IF ((@charhTiZr IS NULL) OR (RTRIM(@charhTiZr) = '') OR (@Status != '3'))
						SET @hTiZr = 100.0
					ELSE
						SET @hTiZr = (SELECT TOP 1 CAST(hTiZr AS numeric(8,5))FROM [dbo].[chemMinMax01] WHERE Alloy = @Alloy AND  [Diam]= @Diameter AND TYPE = 'S')
				END
				ELSE 
				BEGIN
					IF (@Status != '3')
					BEGIN
						SET @Status = '2'
						IF (@returnMessage = '')
								SET @returnMessage = 'TiZr'
						ELSE
								SET @returnMessage = @returnMessage + ', ' + 'TiZr'
					END
					ELSE
					BEGIN
						SET @lTiZr = 0.0
						SET @hTiZr = 100.0
					END
				END	

				
				IF ( @checkTiZr<=@lTiZr OR @checkTiZr>@hTiZr)	
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
			END
			
			--end				
			IF (@Status = '2')
			BEGIN
				IF (@returnHeatNo = '')
					SET @returnHeatNo = @HeatNumber
			END

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
--@returnHeatNo resturns the Heat Number that has the deviation. If the record doesn't have deviation, 
--@returnHeatNo is ''


select @returnMessage , @returnHeatNo

END
