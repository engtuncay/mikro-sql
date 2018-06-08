DECLARE @col1 varchar(50)
DECLARE @col2 int
DECLARE @evraktip int
DECLARE @satirnocol int
DECLARE @satirno int
DECLARE @kayitsayisi int
DECLARE @belgetarih date

DECLARE kredikarticursor CURSOR FOR
SELECT cha_evrakno_seri,cha_evrakno_sira,cha_evrak_tip,cha_satir_no FROM [XOZ_KREDIKARTIONAY]

OPEN kredikarticursor
FETCH NEXT FROM kredikarticursor INTO @col1,@col2,@evraktip,@satirnocol

WHILE @@FETCH_STATUS=0
BEGIN

SET @kayitsayisi = ( select count(chh.cha_satir_no)
FROM [CARI_HESAP_HAREKETLERI] as chh
WHERE chh.cha_evrakno_seri = @col1 and chh.cha_evrakno_sira=@col2 and cha_iptal=0 and cha_evrak_tip=@evraktip )

--SET @satirno = ( select chh.cha_satir_no
--FROM [CARI_HESAP_HAREKETLERI] as chh
--WHERE chh.cha_evrakno_seri = @col1 and chh.cha_evrakno_sira=@col2 and cha_iptal=0 and cha_evrak_tip=1)

SET @belgetarih = ( select chh.cha_belge_tarih
FROM [CARI_HESAP_HAREKETLERI] as chh
WHERE chh.cha_evrakno_seri = @col1 and chh.cha_evrakno_sira=@col2 and cha_iptal=0 and cha_evrak_tip=1 and cha_satir_no=@satirnocol)

IF @kayitsayisi = 2 
BEGIN 
PRINT @col1 +' ' + CAST(@col2 AS VARCHAR) + ' ' + CAST(@kayitsayisi AS VARCHAR)
FETCH NEXT FROM kredikarticursor INTO @col1,@col2,@evraktip,@satirnocol
CONTINUE
END

IF @belgetarih IS NULL
BEGIN 
PRINT @col1 +' ' + CAST(@col2 AS VARCHAR) + ' '  --+ CAST(@belgetarih AS VARCHAR)
FETCH NEXT FROM kredikarticursor INTO @col1,@col2,@evraktip,@satirnocol
CONTINUE
END

UPDATE [XOZ_KREDIKARTIONAY] SET cha_tarih_onay=@belgetarih WHERE cha_evrakno_seri=@col1 AND cha_evrakno_sira=@col2
--SELECT * FROM [XOZ_KREDIKARTIONAY] WHERE cha_evrakno_seri=@col1 AND cha_evrakno_sira=@col2

FETCH NEXT FROM kredikarticursor INTO @col1,@col2,@evraktip,@satirnocol
END

CLOSE kredikarticursor
DEALLOCATE kredikarticursor



