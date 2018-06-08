--Select * from dbo.fn_CariFoy (N'0',0,'1000',NULL,'20180101','20180101','20180131',0,N'')
--@firmalar nvarchar(MAX) = null, @caricins tinyint = 0, @carikod nvarchar(25) = ''
--, @grupno tinyint = null, @devirtar datetime = null, @ilktar datetime = null, @sontar datetime = null, @odemeemridegerlemedok tinyint = 0, @SomStr nvarchar(MAX) = ''

Declare @firmalar as nvarchar(10) = '0'
Declare @caricins as int =0 
Declare @carikod as nvarchar(25) = '1000'
Declare @grupno as tinyint = NULL
Declare @devirtarih as datetime = '20180101'
Declare @ilktar as datetime ='20180101' 
Declare @sontar as datetime = '20180131'
Declare @odemeemridegerlemedok as int = 0
Declare @SomStr as nvarchar =''

Select TOP 100 PERCENT * From dbo.fn_HamCariFoy(@firmalar,@caricins,@carikod,@grupno,@ilktar,@sontar,@odemeemridegerlemedok,@SomStr,'')
UNION ALL
SELECT
0,                    -- KAYIT NO
0,                    -- DBCNO
0,                    -- DATABASE NO
'',                   -- CARİ KODU
'',                   -- CARİ İSMİ
'',                   -- FİRMA ÜNVANI
@ilktar,              -- TARİH
'',                   -- SERİ
0,                    -- SIRA
@ilktar,              -- BELGE TARİHİ
'',                   -- BELGE NO
'_'+dbo.fn_GetResource('P',1206,DEFAULT)+'_',            -- EVRAK TİPİ
'_'+dbo.fn_GetResource('P',1206,DEFAULT)+'_',            -- CİNSİ
0,                    -- CİNS
'',                   -- GRUBU
[#msg_S_1712],        -- CARİ HESAP GRUP NO
'',                   -- SRM.MRK.KODU
'',                   -- SRM.MRK.İSMİ
'',                   -- N/İ
dbo.fn_GetResource('P',1340,DEFAULT),           -- DEVREDEN
'',                   -- SORUMLU KODU
'',                   -- SORUMLU İSMİ
@ilktar,              -- VADE TARİH
0,                    -- VADE GÜN
'',                   -- DEPO
0,                    -- MİKTAR
'',                   -- B/A
SUM([msg_S_0101\T]),  -- ANA DÖVİZ BORÇ
SUM([msg_S_0102\T]),  -- ANA DÖVİZ ALACAK
SUM([msg_S_0101\T])-SUM([msg_S_0102\T]), -- ANA DÖVİZ TUTAR
CAST ( 0 AS FLOAT ),  -- ANA DÖVİZ BORÇ BAKİYE
CAST ( 0 AS FLOAT ),  -- ANA DÖVİZ ALACAK BAKİYE
CAST ( 0 AS FLOAT ),  -- ANA DÖVİZ BAKİYE
0,                    -- ALT.DOVİZ KUR
SUM([msg_S_0105\T]),  -- ALT. DÖVİZ BORÇ
SUM([msg_S_0106\T]),  -- ALT. DÖVİZ ALACAK
SUM([msg_S_0105\T])-SUM([msg_S_0106\T]), -- ALT. DÖVİZ TUTAR
CAST ( 0 AS FLOAT ),  -- Alternatif DÖVİZ BORÇ BAKİYE
CAST ( 0 AS FLOAT ),  -- Alternatif DÖVİZ ALACAK BAKİYE
CAST ( 0 AS FLOAT ),  -- Alternatif DÖVİZ BAKİYE
0,                    -- ORJ.DOVİZ KUR
SUM([msg_S_0109\T]),  -- ORJ. DÖVİZ BORÇ
SUM([msg_S_0110\T]),  -- ORJ. DÖVİZ ALACAK
SUM([msg_S_0109\T])-SUM([msg_S_0110\T]), -- ORJ. DÖVİZ TUTAR
CAST ( 0 AS FLOAT ),  -- ORJINAL DÖVİZ BORÇ BAKİYE
CAST ( 0 AS FLOAT ),  -- ORJINAL DÖVİZ ALACAK BAKİYE
CAST ( 0 AS FLOAT ),  -- ORJINAL DÖVİZ BAKİYE
[msg_S_0112]       ,  -- ORJ.DOVİZ,
'',                   -- KARŞI HESAP CİNSİ
'',                   -- KARŞI HESAP KODU
'',                   -- KARŞI HESAP İSMİ
'',                   -- GRUBU
'',                   -- SRM.MRK.KODU
'',                   -- SRM.MRK.İSMİ
'',                   -- PROJE KODU
'',                   -- PROJE ADI
'',                   -- REFERANS NO
'',                   -- KİLİTLİ
'',                   -- PARTİ
0 ,                   -- LOT
'',                   --CİRO CARİ KODU
''                    --CİRO CARİ İSMİ
From dbo.fn_CariTutarlar ( @firmalar,@caricins,@carikod,@grupno,null,dateadd(Day, -1, @ilktar),0,@SomStr,'' )
WHERE (@ilktar is NOT NULL)
GROUP BY [#msg_S_1712],[msg_S_0112]