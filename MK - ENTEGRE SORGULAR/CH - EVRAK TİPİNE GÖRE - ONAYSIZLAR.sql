DECLARE @srmkodu as nvarchar(50)
DECLARE @stkodu as nvarchar(50)
DECLARE @chacinsi as tinyint 
DECLARE @chatip as tinyint 
DECLARE @chaevraktip as tinyint  
DECLARE @tarih as nvarchar(10)

SET @srmkodu='DOGUS'
--SET @stkodu='002'
SET @chacinsi = 19 
SET @chatip = 1
SET @chaevraktip= 1
SET @tarih ='20150822'

-- DEVİR TAHSİLAT DÖKÜMÜ - EVRAK TİPİNE GÖRE
select cha_cinsi,cha_evrak_tip,cha_tip,sum(chh.cha_meblag) as meblag
--,cha_cari_cins,cha_kasa_hizmet
from [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
LEFT JOIN [XOZ_MODDEVIR_LOG] dl ON dl.cha_cinsi= chh.cha_cinsi and dl.
where chh.cha_iptal=0 
and chh.cha_srmrkkodu=@srmkodu 
and chh.cha_cinsi=@chacinsi
and chh.cha_tip=@chatip
and chh.cha_evrak_tip=@chaevraktip
and CONVERT(VARCHAR,cha_tarihi,112)<@tarih
group by cha_evrak_tip,cha_cinsi,cha_tip,cha_cari_cins
--,cha_kasa_hizmet,cha_cinsi

