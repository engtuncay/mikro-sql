--fn_CariHesapBakiye(@FIRMALAR, @CARICINSI, @CARIKODU, @SORMERKKODU, @PROJEKODU, @GRUPNO, @DOVIZTIPI)
--fn_CariHesapDurum(@firmalar, @caricins, @carikod, @grupno, @ilktar, @sontar, @SorMerkez, @Proje, @odemeemridegerlemedok)

declare @FIRMALAR nvarchar( 50)
declare @CARICINS tinyint
declare @CARIKOD nvarchar( 25)
declare @GRUPNO tinyint
declare @ILKTARIH datetime
declare @SONTARIH datetime
declare @SORMERKEZ nvarchar( 25)
declare @SORMERKKODU nvarchar(25)
declare @PROJE nvarchar( 25)
declare @PROJEKODU nvarchar( 25)
declare @ODEMEEMRIDEGERLEMEDOK tinyint
declare @DOVIZTIPI tinyint

set @CARICINS = 0
set @CARIKOD = 'HT01051'
set @FIRMALAR = ''
set @GRUPNO = 0
set @ILKTARIH = '20140101'
set @ODEMEEMRIDEGERLEMEDOK = 0
set @PROJE = ''
set @PROJEKODU = ''
set @SONTARIH = '20150801'
set @SORMERKEZ = ''
SET @SORMERKKODU=''
set @DOVIZTIPI = 0

--PRINT dbo.fn_CariHesapBakiye('',0,'HT00535', '', '' , 0,0 )
--PRINT dbo.fn_CariHesapBakiye(@firmalar, @caricins, @carikod, @SorMerkez, @Proje, @grupno, @DOVIZTIPI) 
--select fn_CariHesapDurum(@firmalar, @caricins, cari_kod, @grupno, @ilktar, @sontar, @SorMerkez, @Proje, @odemeemridegerlemedok)

--select * from dbo.fn_CariHesapDurum(@firmalar, @caricins, @carikod, @grupno, @ilktar, @sontar, @SorMerkez, @Proje, @odemeemridegerlemedok) as msg30 -- toplam borç,toplam alacak tutarlarını veriyor
select dbo.fn_CariHesapAnaDovizBakiye(@FIRMALAR, @CARICINS, @CARIKOD, @SORMERKKODU, @PROJEKODU, @GRUPNO, @ILKTARIH, @SONTARIH, @ODEMEEMRIDEGERLEMEDOK) bakiye
