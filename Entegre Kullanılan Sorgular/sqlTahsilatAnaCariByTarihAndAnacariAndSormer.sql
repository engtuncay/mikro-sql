
DECLARE @_cari_Ana_cari_kodu AS varchar(20) ='MK049'
DECLARE @_cari_sektor_kodu AS varchar(20) ='NESTLE'
DECLARE @_cha_tarihiBas AS date ='20180501'
DECLARE @_cha_tarihiSon AS date ='20180530'

select ISNULL(sum(chh.cha_meblag),0) as cha_meblag
from [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod= ch.cari_kod
where chh.cha_cinsi IN(0,1,2,5,19) AND cha_tip=1 and ch.cari_Ana_cari_kodu=@_cari_Ana_cari_kodu and ch.cari_sektor_kodu=@_cari_sektor_kodu
and chh.cha_tarihi>=@_cha_tarihiBas and chh.cha_tarihi<=@_cha_tarihiSon
--ORDER BY chh.cha_tarihi DESC

-- 0:nakit , 1:müşteri çeki , 5: bakiye dengeleme(dekont), 19:müşteri kk
 
--cari_kod,ch.cari_unvan1,chh.cha_evrak_tip,chh.cha_tarihi,chh.cha_meblag 

--cari_kod,ch.cari_unvan1,chh.cha_evrak_tip,chh.cha_tarihi,chh.cha_meblag 
--cha_belge_no LIKE '16705' --cha_evrakno_seri='NS' AND cha_evrakno_sira='27232943'