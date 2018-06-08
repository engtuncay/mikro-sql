
-- Parametreden Gelenler
DECLARE @mkod AS varchar(30) ='PN293183'     
DECLARE @sektorkodu as varchar(150) = 'PANEK'
DECLARE @gunLimit as int = 45

--SELECT x.cha_tarihi,x.cha_meblag
--FROM (
SELECT cha_tarihi,cha_meblag,
CASE
WHEN chs.cari_Ana_cari_kodu IS NULL THEN chs.cari_Ana_cari_kodu
WHEN chs.cari_Ana_cari_kodu ='' THEN chs.cari_Ana_cari_kodu
ELSE chs.cari_kod
END AS cari_kod2
FROM CARI_HESAP_HAREKETLERI chh WITH (NOLOCK, INDEX=idx_Nonclustered_CARI_HESAP_HAREKETLERI_cha_tip)
LEFT JOIN [CARI_HESAPLAR] chs WITH (NOLOCK) ON chh.cha_kod = chs.cari_kod 
WHERE cha_tip=0 and chs.cari_sektor_kodu = @sektorkodu
--) AS x
--WHERE cari_kod2 = @mkod  --and cha_evrak_tip=63
--ORDER BY x.cha_tarihi desc