USE [MikroDB_V15_OZPAS];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE FUNCTION [dbo].[fn_STOKLAR_GORUNTU_aa]
(@StokKodu nvarchar(25))
RETURNS @STOKDEPOTBL table
(
[msg_S_0873] int NULL, 
[msg_S_0874] nvarchar(50) COLLATE Turkish_CS_AI NULL, 
[msg_S_0163\T] float NULL, 
[msg_S_0164\T] float NULL, 
[msg_S_1976\T] float NULL, 
[msg_S_1977\T] float NULL, 
[msg_S_1978\T] float NULL, 
[msg_S_1943\T] float NULL, 
[msg_S_0343\T] float NULL
)
WITH EXEC AS CALLER
AS
BEGIN
Declare @DepoyaGiren Float
Declare @DepodanCikan Float
Declare @DepodakiKonsinye Float
Declare @DepodanVerilenKonsinye Float
Declare @Rezervasyon Float
Declare @DepoNo AS integer
Declare @DepoAdi AS nvarchar(50)
DECLARE @aktifUser int
SET @aktifUser=(Select dbo.fn_GetAktifUserNo())
DECLARE @Raporlarda_Depo_Seciminde_Hak_Kontrol_Edilmesin bit
SET @Raporlarda_Depo_Seciminde_Hak_Kontrol_Edilmesin = (select dbo.fn_GetByteParam(5087,default))
Declare Depo_Cursor CURSOR READ_ONLY FAST_FORWARD
FOR
SELECT dep_no,dep_adi
FROM DEPOLAR
WHERE ((@Raporlarda_Depo_Seciminde_Hak_Kontrol_Edilmesin=1) or
(not exists(Select yk_kayitno
from YASAKLI_KAYITLAR
WHERE (dep_RECid_DBCno = yk_dbcno) And
(dep_RECid_RECno = yk_kayitno) and
(yk_tablono = 111) And
(yk_kullanicino = @aktifUser))))
OPEN Depo_Cursor
FETCH NEXT FROM Depo_Cursor INTO @DepoNo, @DepoAdi
WHILE @@FETCH_STATUS=0
BEGIN
IF (dbo.fn_MaliEnvanterHariciDepo(@DepoNo)=1)
BEGIN
SET @DepoyaGiren = 0
SET @DepodanCikan = 0
SET @DepodakiKonsinye = 0
SET @DepodanVerilenKonsinye = 0
SET @Rezervasyon = 0
END
ELSE
BEGIN
Select @DepoyaGiren = dbo.fn_DepoyaGirenMiktar(@StokKodu,@DepoNo,0)
Select @DepodanCikan = dbo.fn_DepodanCikanMiktar(@StokKodu,@DepoNo,0)
Select @DepodakiKonsinye = dbo.fn_DepodakiKonsinyeMiktar(@StokKodu,@DepoNo,0)
Select @DepodanVerilenKonsinye = dbo.fn_DepodanVerilenKonsinyeMiktar(@StokKodu,@DepoNo,0)
Select @Rezervasyon = dbo.fn_Stok_Rezervasyon_Miktari(@StokKodu,@DepoNo,0,255)
END
INSERT INTO @STOKDEPOTBL
Values ( @DepoNo,
@DepoAdi,
@DepoyaGiren,
@DepodanCikan,
(@DepoyaGiren - @DepodanCikan),
@DepodakiKonsinye,
@DepodanVerilenKonsinye,
@Rezervasyon,
(@DepoyaGiren - @DepodanCikan + @DepodakiKonsinye - @DepodanVerilenKonsinye - @Rezervasyon))
FETCH NEXT FROM Depo_Cursor INTO @DepoNo, @DepoAdi
END
CLOSE Depo_Cursor
DEALLOCATE Depo_Cursor
RETURN
END
GO
