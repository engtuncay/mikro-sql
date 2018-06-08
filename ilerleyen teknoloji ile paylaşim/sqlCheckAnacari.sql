


DECLARE @_cari_kod AS VARCHAR(20) = 'MK001'
DECLARE @_cari_sektor_kodu AS VARCHAR(20) ='NESTLE'

SELECT count(*) as subesayi FROM [CARI_HESAPLAR] WITH (NOLOCK) 
WHERE cari_Ana_cari_kodu=@_cari_kod and cari_Ana_cari_kodu<>cari_kod and cari_sektor_kodu=@_cari_sektor_kodu