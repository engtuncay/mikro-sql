
DECLARE @_cari_kod as varchar(20) ='MK047C'
DECLARE @_cari_Ana_cari_kodu AS varchar(20) ='MK049'
DECLARE @_cari_sektor_kodu AS varchar(20) ='NESTLE'
DECLARE @_cha_tarihiBas AS date ='20180501'
DECLARE @_cha_tarihiSon AS date ='20180531'

SELECT count(*) as nCountTr FROM [CARI_HESAPLAR] WITH (NOLOCK) 
WHERE cari_Ana_cari_kodu=@_cari_kod and cari_Ana_cari_kodu<>cari_kod and cari_sektor_kodu=@_cari_sektor_kodu
