Declare @carikod as nvarchar(25) = '27348'
Declare @devirtarih as datetime = '20180101'
Declare @ilktarih as datetime ='20180101' 
Declare @sontarih as datetime = '20180131'

--tqs 20180316-1005 
Select 
[#msg_S_0200] as cha_kod -- CARİ KODU
--,[msg_S_0088] as cha_RECno -- KAYIT NO -- arka planda olsun
,[#msg_S_0201] as ch_unvan
,[msg_S_0089] as cha_tarihi -- TARİH
,[msg_S_0090] as cha_evrakno_seri -- SERİ
,[msg_S_0091] as cha_evrakno_sira -- SIRA
,[#msg_S_0092] as cha_belge_tarih -- BELGE TARİHİ
,[#msg_S_0093] as cha_belge_no -- BELGE NO
,[msg_S_0094] as evrakuzunisim -- EVRAK TİPİ
,[msg_S_0003] as evrakcinsiuzunisim -- CİNSİ
--,[#msg_S_0158] as cha_cinsi -- HAREKET CİNSİ -- arka planda olsun
,[msg_S_0118] as cha_srmrkkodu -- SRM.MRK.KODU
--,[msg_S_0097] as evraktur -- N/İ
,[#msg_S_0085] as cha_aciklama -- AÇIKLAMA
--,[msg_S_1129] as cha_satici_kodu -- SORUMLU KODU -- arka planda olsun
,[msg_S_1130] as sorumluisim -- SORUMLU İSMİ
,[msg_S_1129] as cha_satici_kodu -- SORUMLU KODU
,[msg_S_1130] as sorumluismi -- SORUMLU İSMİ
,[msg_S_0100] as chtipisim -- B/A
,[msg_S_0101\T] as meblagborc -- ANA DÖVİZ BORÇ
,[msg_S_0102\T] as meblagalacak -- ANA DÖVİZ ALACAK
,[#msg_S_0103\T] as meblagtoplam -- ANA DÖVİZ TUTAR
from dbo.fn_CariFoy (N'0',0,@carikod,NULL,@devirtarih,@ilktarih,@sontarih,0,N'') 
Order by [msg_S_0089] /* TARİH */ ,[msg_S_0094] /* EVRAK TİPİ */ ,[msg_S_0090] /* SERİ */ ,[msg_S_0091] /* SIRA */

