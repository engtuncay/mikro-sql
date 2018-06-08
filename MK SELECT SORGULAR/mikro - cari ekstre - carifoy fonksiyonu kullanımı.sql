
-- carifoy parametreler
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

Select msg_S_0088 as kayitno,#msg_S_0200 as cari_kod
--,msg_S_0102 as nAlacakTutartr
--,msg_S_0101 as nBorcTutartr
--, #msg_S_0103 as nCariBakiyetr
, *
from dbo.fn_CariFoy (N'0',0,@carikod,NULL,@devirtarih,@ilktar,@sontar,0,N'')
Order by [msg_S_0089] /* TARİH */ ,[msg_S_0003] /* EVRAK TİPİ */ ,[msg_S_0090] /* SERİ */ ,[msg_S_0091] /* SIRA */

/*
						row.setAlacaktutar(rsa.getFloat("msg_S_0102\\T"));
						row.setBorctutar(rsa.getFloat("msg_S_0101\\T"));
						row.setAlacakborcbakiye(rsa.getDouble("#msg_S_0103\\T"));
						// row.setAlacakbakiye(rsa.getFloat(""));
						row.setTarih(rsa.getDate("msg_S_0089"));
						row.setBelgetarih(rsa.getDate("#msg_S_0092"));
						row.setTur(rsa.getString("msg_S_0003"));
						row.setSerikayitno(rsa.getString("msg_S_0090") + "-" + rsa.getString("msg_S_0091"));
						row.setBelgeno(rsa.getString("#msg_S_0093"));
						row.setMusteriunvani(rsa.getString("#msg_S_0201"));
						row.setSorumluismi(rsa.getString("msg_S_1130"));
*/